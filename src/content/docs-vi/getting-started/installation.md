---
title: Cài Đặt
description: "Documentation for Cài Đặt
description:
section: getting-started
category: getting-started
order: 2
published: true"
section: getting-started
category: getting-started
order: 2
published: true
---

# Cài Đặt

Hướng dẫn này sẽ giúp bạn cài đặt AgencyOS và thiết lập môi trường phát triển. Bạn có thể chọn giữa cài đặt thủ công hoặc sử dụng AgencyOS CLI.

## Yêu Cầu

Trước khi cài đặt AgencyOS, đảm bảo bạn có:

- **Node.js** v18 trở lên
- **npm** v10 trở lên (hoặc bun, pnpm, yarn)
- **Git** để quản lý phiên bản
- **AgencyOS CLI CLI** đã cài đặt (`claude`)
- **Google Gemini API Key** từ [Google AI Studio](https://aistudio.google.com)

## Phương Pháp 1: Cài Đặt Thủ Công

Phương pháp này cho bạn quyền kiểm soát hoàn toàn quá trình cài đặt.

### Bước 1: Sao Chép Các File AgencyOS

Sao chép tất cả thư mục và file từ repo `mekong-engineer` vào dự án của bạn:

```bash
# Sao chép các file và thư mục sau:
.claude/*
docs/*
plans/*
CLAUDE.md
```

### Bước 2: Cấu Hình API Key Gemini (Tuỳ Chọn)

**TẠI SAO?**  
AgencyOS từng sử dụng [Human MCP](https://www.npmjs.com/package/human-analyzer) để phân tích hình ảnh và video vì Gemini có khả năng xử lý vision tốt. Tuy nhiên, Anthropic đã ra mắt [**Agent Skills**](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview) hỗ trợ context engineering tốt hơn, nên toàn bộ công cụ Human MCP đã được chuyển thành Agent Skills.

**Lưu ý:** Gemini API hiện đang có hạn mức miễn phí khá rộng rãi.

1. Vào [Google AI Studio](https://aistudio.google.com) và lấy API Key của bạn
2. Sao chép file `.claude/skills/.env.example` thành `.claude/skills/.env` rồi dán key vào biến môi trường `GEMINI_API_KEY`

Vậy là bạn đã sẵn sàng sử dụng.

### Bước 3: Khởi Động AgencyOS CLI

Khởi động AgencyOS CLI trong dự án làm việc của bạn:

```bash
# Chế độ tiêu chuẩn
claude

# Bỏ qua permissions (sử dụng cẩn thận)
claude --dangerously-skip-permissions
```

### Bước 4: Khởi Tạo Tài Liệu

Chạy lệnh `/docs:init` để quét và tạo specs cho dự án:

```bash
/docs:init
```

Lệnh này tạo ra các file markdown trong thư mục `docs`:
- `codebase-summary.md`
- `code-standards.md`
- `system-architecture.md`
- Và nhiều hơn nữa...

Bây giờ dự án của bạn đã sẵn sàng để phát triển!

## Phương Pháp 2: AgencyOS CLI

CLI cung cấp cách tự động để thiết lập các dự án AgencyOS.

### Cài Đặt

Cài đặt AgencyOS CLI toàn cục:

```bash
# npm
npm install -g mekong-cli

# bun
bun add -g mekong-cli

# Xác minh cài đặt
mk --version
```

### Khởi Tạo hoặc Cập Nhật AgencyOS Engineer

**Lưu ý:** Lệnh này nên được chạy từ thư mục gốc của dự án.

```bash
# Chế độ tương tác (khuyến nghị)
mk init

# Với tùy chọn
mk init --kit engineer

# Phiên bản cụ thể
mk init --kit engineer --version v1.0.0

# Với mẫu loại trừ
mk init --exclude "local-config/**" --exclude "*.local"

# Chế độ global - sử dụng thư mục cấu hình theo platform
mk init --global
mk init -g --kit engineer
```

### Cập Nhật CLI

Để cập nhật công cụ dòng lệnh `mk` lên phiên bản mới nhất:

```bash
mk update
```

**Lưu ý:** Lệnh này chỉ cập nhật CLI, không cập nhật file AgencyOS Engineer. Dùng `mk init` để cập nhật AgencyOS Engineer.

### Xác Thực

CLI yêu cầu **GitHub Personal Access Token (PAT)** để tải xuống các bản phát hành từ repository riêng tư (`mekong-engineer` và `mekong-marketing`).

**Chuỗi Dự Phòng Xác Thực:**

1. **GitHub CLI**: Sử dụng `gh auth token` nếu GitHub CLI đã cài đặt và xác thực
2. **Biến Môi Trường**: Kiểm tra `GITHUB_TOKEN` hoặc `GH_TOKEN`
3. **OS Keychain**: Lấy token đã lưu từ keychain hệ thống
4. **Nhắc Người Dùng**: Nhắc nhập token và đề nghị lưu an toàn

**Tạo Personal Access Token:**

1. Vào GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Tạo token mới với scope `repo` (cho repository riêng tư)
3. Sao chép token

**Thiết Lập Token Qua Biến Môi Trường:**

```bash
export GITHUB_TOKEN=ghp_your_token_here
```

## Xác Minh Cài Đặt

Sau khi cài đặt (bất kỳ phương pháp nào), xác minh mọi thứ đã được thiết lập đúng:

```bash
# Kiểm tra AgencyOS CLI có sẵn
claude --version

# Kiểm tra thư mục .claude tồn tại
ls -la .claude/
```

## Cập Nhật AgencyOS

Giữ AgencyOS Engineer luôn cập nhật:

```bash
# Cập nhật AgencyOS Engineer lên phiên bản mới nhất
mk init

# Cập nhật lên phiên bản cụ thể
mk init --version v1.2.0
```

**Loại trừ các file cụ thể khi cập nhật:**

```bash
# Không ghi đè CLAUDE.md
mk init --exclude CLAUDE.md
```

**Cập nhật CLI:**

```bash
# Cập nhật công cụ dòng lệnh ck
mk update
```

## Khắc Phục Sự Cố

### Lỗi Quyền

Trên macOS/Linux, bạn có thể cần sudo:

```bash
sudo npm install -g mekong-cli
```

Hoặc cấu hình npm để sử dụng thư mục khác:

```bash
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
```

### Không Tìm Thấy AgencyOS CLI

Nếu lệnh `claude` không được tìm thấy:

1. Cài đặt AgencyOS CLI CLI từ [claude.ai/code](https://claude.ai/code)
2. Khởi động lại terminal
3. Xác minh với `claude --version`

### Xác Thực GitHub Thất Bại

Nếu CLI không thể xác thực:

1. Cài đặt GitHub CLI: `brew install gh` (macOS) hoặc xem [cli.github.com](https://cli.github.com)
2. Xác thực: `gh auth login`
3. Xác minh: `gh auth status`
4. Hoặc thiết lập biến môi trường: `export GITHUB_TOKEN=your_token`

## Bước Tiếp Theo

Bây giờ AgencyOS đã được cài đặt, tiếp tục với:

- [Hướng Dẫn Bắt Đầu Nhanh](/docs/getting-started/quick-start) - Xây dựng dự án đầu tiên
- [Giải Thích CLAUDE.md](/docs/core-concepts/claude-md) - Hiểu file cấu hình
- [Workflows](/docs/core-concepts/workflows) - Tìm hiểu về quy trình phát triển
