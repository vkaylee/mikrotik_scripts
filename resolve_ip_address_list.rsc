:log info "--- Starting Final Address List Update Script (V6) ---"

# ===== é…ç½®åŒº =====
:local commentToAdd "auto"

:local chatgptListName "chatgpt-allowed"
:local authListName "auth-providers-allowed"

:local chatgptDomains {
    "chat.openai.com";
    "chatgpt.com";
    "platform.openai.com";
    "api.openai.com";
    "auth.openai.com";
    "auth0.openai.com";
    "ai.com";
    "static.oaistatic.com";
    "cdn.oaistatic.com";
    "challenges.cloudflare.com";
    "arkoselabs.com";
    "stripe.com";
    "files.oaiusercontent.com"
}

:local authDomains {
    "login.microsoftonline.com";
    "login.live.com";
    "appleid.apple.com";
    "idmsa.apple.com"
}

# ===== æ‰§è¡ŒåŒº =====
:log info "Removing old entries with comment~\"auto\"..."
/ip firewall address-list remove [find where comment~$commentToAdd]

# ===== å‡½æ•°ï¼šæ‰¹é‡è§£æžå¹¶æ·»åŠ  =====
:global AddResolvedIPs do={
    :local listName ($1)
    :local domainList ($2)
    :foreach domain in=$domainList do={
        :do {
            :local ip [:resolve $domain]
            :if ($ip != "") do={
                /ip firewall address-list add list=$listName address=$ip timeout=1d comment=("$domain $commentToAdd")
                :log info ("Added $domain -> $ip to $listName")
            }
        } on-error={
            :log warning ("Failed to resolve $domain")
        }
    }
}

# ===== æ·»åŠ  ChatGPT ç›¸å…³ =====
:log info "--> Updating ChatGPT Address List..."
$AddResolvedIPs $chatgptListName $chatgptDomains

# ===== æ·»åŠ  Apple / Microsoft ç™»å½•æœåŠ¡ =====
:log info "--> Updating Auth Provider Address List..."
$AddResolvedIPs $authListName $authDomains

:log info "--- Script Finished Successfully ---"