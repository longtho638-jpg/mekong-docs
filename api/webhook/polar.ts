import type { VercelRequest, VercelResponse } from '@vercel/node';
import crypto from 'crypto';

// License key generator utility
function generateLicenseKey(): string {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const segments = 4;
    const segmentLength = 4;

    const parts: string[] = [];
    for (let i = 0; i < segments; i++) {
        let segment = '';
        for (let j = 0; j < segmentLength; j++) {
            segment += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        parts.push(segment);
    }

    return `AGENCYOS-${parts.join('-')}`;
}

// Simple in-memory store for demo (replace with Supabase in production)
// In production, this would use Supabase client
const licenses: Map<string, any> = new Map();

export default async function handler(req: VercelRequest, res: VercelResponse) {
    // Only accept POST
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method not allowed' });
    }

    try {
        const body = req.body;

        // Verify webhook signature (in production)
        const signature = req.headers['x-polar-signature'];
        const webhookSecret = process.env.POLAR_WEBHOOK_SECRET;

        // For now, skip signature verification if no secret configured
        if (webhookSecret && signature) {
            const expectedSignature = crypto
                .createHmac('sha256', webhookSecret)
                .update(JSON.stringify(body))
                .digest('hex');

            if (signature !== `sha256=${expectedSignature}`) {
                console.error('Invalid webhook signature');
                return res.status(401).json({ error: 'Invalid signature' });
            }
        }

        // Handle different event types
        const eventType = body.event || body.type;

        if (eventType === 'order.created' || eventType === 'checkout.completed') {
            const data = body.data;
            const email = data?.customer?.email || data?.email;
            const productName = data?.product?.name || data?.items?.[0]?.product?.name || 'Pro';
            const orderId = data?.id || data?.order_id;

            if (!email) {
                console.error('No email in webhook payload');
                return res.status(400).json({ error: 'Missing email' });
            }

            // Generate license key
            const licenseKey = generateLicenseKey();

            // Store license (in production, use Supabase)
            const licenseData = {
                license_key: licenseKey,
                email: email,
                plan: productName.toLowerCase(),
                status: 'active',
                polar_order_id: orderId,
                created_at: new Date().toISOString(),
                expires_at: null // Lifetime license
            };

            licenses.set(licenseKey, licenseData);

            // In production with Supabase:
            // const { error } = await supabase.from('licenses').insert(licenseData);

            console.log('License created:', { email, plan: productName, licenseKey });

            // Send email with license key (in production, use Resend)
            if (process.env.RESEND_API_KEY) {
                try {
                    await fetch('https://api.resend.com/emails', {
                        method: 'POST',
                        headers: {
                            'Authorization': `Bearer ${process.env.RESEND_API_KEY}`,
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            from: 'AgencyOS <noreply@agencyos.network>',
                            to: email,
                            subject: '🏯 Your AgencyOS License Key',
                            html: `
                <h1>Welcome to AgencyOS!</h1>
                <p>Thank you for your purchase. Here's your license key:</p>
                <div style="background: #1a1a1a; padding: 20px; border-radius: 8px; margin: 20px 0;">
                  <code style="font-size: 24px; color: #22c55e;">${licenseKey}</code>
                </div>
                <h2>Quick Start:</h2>
                <pre style="background: #1a1a1a; padding: 16px; border-radius: 8px;">
git clone https://github.com/longtho638-jpg/agencyos-starter.git
cd agencyos-starter
pip install -r requirements.txt
python activate.py ${licenseKey}
                </pre>
                <p>Need help? Reply to this email or visit <a href="https://agencyos.network/docs">our docs</a>.</p>
                <p>🏯 Win Without Fighting!</p>
              `
                        })
                    });
                    console.log('Email sent to:', email);
                } catch (emailError) {
                    console.error('Failed to send email:', emailError);
                    // Continue anyway - license is created
                }
            }

            return res.status(200).json({
                success: true,
                license_key: licenseKey,
                message: 'License created successfully'
            });
        }

        // Handle other events
        console.log('Unhandled webhook event:', eventType);
        return res.status(200).json({ received: true, event: eventType });

    } catch (error) {
        console.error('Webhook error:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
}
