import type { APIRoute } from 'astro';
import { Polar } from '@polar-sh/sdk';

// Product ID mapping
const PRODUCTS = {
    starter: 'af7a521d-142b-45b5-9dd2-337417b0d6b2',
    pro: 'a8323c67-a6f4-4055-8609-aea2f5687e63',
    franchise: 'c2a5666b-bb41-43e5-9d0d-0dc30aee76df'
};

export const GET: APIRoute = async ({ url }) => {
    const plan = url.searchParams.get('plan') || 'pro';
    const email = url.searchParams.get('email');

    const productId = PRODUCTS[plan as keyof typeof PRODUCTS];

    if (!productId) {
        return new Response(JSON.stringify({ error: 'Invalid plan' }), {
            status: 400,
            headers: { 'Content-Type': 'application/json' }
        });
    }

    try {
        const polar = new Polar({
            accessToken: process.env.POLAR_ACCESS_TOKEN!
        });

        const checkout = await polar.checkouts.create({
            products: [productId],
            successUrl: `https://agencyos.network/success?plan=${plan}`,
            ...(email && { customerEmail: email })
        });

        // Redirect to checkout
        return Response.redirect(checkout.url, 302);
    } catch (error: any) {
        console.error('Checkout error:', error);
        return new Response(JSON.stringify({ error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
};
