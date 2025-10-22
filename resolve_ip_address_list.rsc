:log info "--- Starting Final Address List Update Script (V7) ---"

# === Definition
:local commentToAdd "auto"
#===============================#
# Change logs
# Don't remove, just adding because the record will be removed automatically when exceeding the timeout.
# One domain can have multiple ips
:global AddResolvedIPs do={
    :local listName ($1)
    :local domainList ($2)
    :local timeout ($3)
    :foreach domain in=$domainList do={
        :do {
            :local ip [:resolve $domain]
            :if ($ip != "") do={
                # Check: the IP is exist or not
                :local commentValue ("$ip $domain $commentToAdd")
                # Find the record by the $listName and the comment
                :local addrId [/ip firewall address-list find list=$listName comment=("$commentValue")]
                # if the record id is not exist, do adding
                :if ([:len $addrId] = 0) do={
                    # Add, the record will exist in 1 day
                    /ip firewall address-list add list=$listName address=$ip timeout=$timeout comment=("$commentValue")
                    :log info ("Added $domain -> $ip to $listName")
                }
            }
        } on-error={
            :log warning ("Failed to resolve $domain")
        }
    }
}

# Exec
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
$AddResolvedIPs "chatgpt-allowed" $chatgptDomains "1d"


:local authDomains {
    "login.microsoftonline.com";
    "login.live.com";
    "appleid.apple.com";
    "idmsa.apple.com"
}
$AddResolvedIPs "auth-providers-allowed" $authDomains "1d"