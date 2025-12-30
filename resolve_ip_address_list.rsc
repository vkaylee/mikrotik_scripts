# Info
# https://github.com/vkaylee/mikrotik_scripts/blob/main/resolve_ip_address_list.rsc
# Hybrid version for both RouterOS v6 and v7
:log info "--- Starting Hybrid Address List Update Script ---"

# === Detection ===
:local osVersion [/system resource get version]
:local isV7 false
:if ([:pick $osVersion 0 1] = "7") do={ :set isV7 true }

# === Configuration Data ===
:local lists {
    "chatgpt-allowed"={
        "chat.openai.com"; "chatgpt.com"; "platform.openai.com"; "api.openai.com";
        "auth.openai.com"; "auth0.openai.com"; "ai.com"; "static.oaistatic.com";
        "cdn.oaistatic.com"; "challenges.cloudflare.com"; "arkoselabs.com";
        "stripe.com"; "files.oaiusercontent.com"; "chatgpt.livekit.cloud";
        "oaistatic.com"; "oaiusercontent.com"; "statsig.com"; "featuregates.org"
    };
    "auth-providers-allowed"={
        "login.microsoftonline.com"; "login.live.com"; "msauth.net"; "aadcdn.msftauth.net";
        "appleid.apple.com"; "idmsa.apple.com"; "gsa.apple.com"
    };
    "google-allowed"={
        "google.com"; "www.google.com"; "google.com.vn"; "www.google.com.vn";
        "accounts.google.com"; "translate.google.com"; "translate.googleapis.com";
        "ssl.gstatic.com"; "fonts.gstatic.com"; "www.gstatic.com"; "csi.gstatic.com";
        "ajax.googleapis.com"; "apis.google.com"
    };
    "wechat-allowed"={
        "weixin.qq.com"; "wechat.com"; "www.wechat.com"; "web.wechat.com"; "wx.qq.com";
        "login.weixin.qq.com"; "file.wx.qq.com"; "file.web.wechat.com"; "weixinbridge.com";
        "szmwx.qpic.cn"; "szmmsns.qpic.cn"; "qlogo.cn"; "qpic.cn"; "mp.weixin.qq.com";
        "res.wx.qq.com"; "short.weixin.qq.com"; "sgminorshort.wechat.com"; "sgshort.wechat.com";
        "sglong.wechat.com"; "dns.wechat.com"; "sgreport.wechat.com"; "sgquic.wechat.com";
        "web1.wechat.com"; "dl.wechat.com"; "servicewechat.com"; "mmbizurl.cn"; "mmecimage.cn";
        "myqcloud.com"; "wechatapp.com"; "store.mp.video.tencent-cloud.com"
    }
}

# === Execution ===
:foreach listName,domains in=$lists do={
    :foreach domain in=$domains do={
        :do {
            :if ($isV7) do={
                # --- v7 Native FQDN Mode ---
                :if ([:len [/ip firewall address-list find list=$listName address=$domain]] = 0) do={
                    /ip firewall address-list add list=$listName address=$domain comment="native-fqdn"
                    :log info ("v7: Added FQDN $domain to $listName")
                }
            } else={
                # --- v6 Legacy Resolve Mode ---
                :local ip [:resolve $domain]
                :if ([:len [/ip firewall address-list find list=$listName address=$ip]] = 0) do={
                    /ip firewall address-list add list=$listName address=$ip timeout=1d comment="v6-auto $domain"
                    :log info ("v6: Resolved $domain -> $ip added to $listName")
                }
            }
        } on-error={
            :log warning ("Failed to process $domain on list $listName")
        }
    }
}