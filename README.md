# MikroTik Address List Resolver (Hybrid v6/v7)

A MikroTik RouterOS script to automatically update Address Lists, supporting both **v6** (Legacy Resolve) and **v7** (Native FQDN).

## ✨ Features

- **Hybrid Support**: Automatically detects RouterOS version and applies the optimal resolution method.
- **v7 Native FQDN**: Leverages the native FQDN feature in v7, automatically tracking CNAMEs and multiple A records. Ideal for CDN-backed services (Cloudflare, Akamai).
- **v6 Fallback**: Reverts to the traditional `:resolve` mechanism if running on older v6 versions.
- **Pre-configured Domain Groups**: Includes ready-to-use lists for:
    - **ChatGPT**: OpenAI, ChatGPT, Cloudflare challenges.
    - **Google**: Search, Translate, Fonts, APIs.
    - **WeChat**: Messaging, Images, Mini-programs.
    - **Auth Providers**: Microsoft, Google, Apple ID.

## 🚀 Getting Started

### 1. Install Script
Copy the content of `resolve_ip_address_list.rsc` and paste it into **System -> Scripts** on your MikroTik router.

### 2. Manual Execution
You can run the script manually using:
```routeros
/system script run resolve_ip_address_list
```

### 3. Configure Scheduler (Recommended)
To keep lists updated (crucial for v6), create a Scheduler to run every 5-10 minutes:
```routeros
/system scheduler
add interval=5m name=update-address-lists on-event="/system script run resolve_ip_address_list" start-time=startup
```

## 🛠 Development & Testing

This project includes a Python test suite to ensure script syntax and logic are correct.

**Run tests:**
```bash
python3 tests/test_mikrotik_script.py
```

## 📝 Note for v7 Users
On RouterOS v7, domains appear directly in the `Address` column of `IP -> Firewall -> Address List`. The actual IP addresses are automatically resolved by the system and displayed as **D (Dynamic)** entries associated with the same `list-name`.

---
*Maintained to help the community optimize routing and security on MikroTik devices.*
