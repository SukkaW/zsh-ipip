# -------------------------------------------------
# A zsh plugin for ipip
# Sukka (https://skk.moe)
# -------------------------------------------------

ipip() {


    if [ -n "$1" ]; then
        ipip_html=$(curl https://www.ipip.net/ip/$1.html -s)
    else
        ipip_html=$(curl https://www.ipip.net/ip.html -s)
    fi

    # ip
    ip=$(echo -n "$ipip_html" | grep 'href="/ip/' | tr -d '[:space:]' | sed 's|<a style="background: none;color: #0A246A;width: auto;" href="||g' | sed 's|</a></span>||g' | sed 's|.*>||g' | tr -d '[:space:]')

    # geo location
    geo=$(echo -n "$ipip_html" | grep 'style="display: inline-block;text-align: center;width: 720px;float: left;line-height: 46px;height: 46px;"' | sed 's|<span style="display: inline-block;text-align: center;width: 720px;float: left;line-height: 46px;height: 46px;">||g' | sed 's|</span>||g' | tr -d '[:space:]')

    # owner_domain
    isp=$(echo -n "$ipip_html" | awk '/<span style="display: inline-block;text-align: center;width: 720px;float: left;line-height: 46px;">/{i++}i==1{print; exit}' | sed 's|<span style="display: inline-block;text-align: center;width: 720px;float: left;line-height: 46px;">||g' | sed 's|</span>||g' | tr -d '[:space:]')

    # idc
    is_idc=$(echo -n "$ipip_html" | grep '<span style="display: inline-block;text-align: center;width: 720px;float: left;line-height: 46px;">' | grep 'IDC')
    is_anycast=$(echo -n "$ipip_html" | grep 'ANYCAST')

    # ASN
    asn=$(echo -n "$ipip_html" | grep "https://whois.ipip.net" -m3 | sed 's|.*https://whois.ipip.net||g' | sed 's|</a> </td>||g' | sed 's|.*>||g' | sed -n '1p' | tr -d '[:space:]')
    cidr=$(echo -n "$ipip_html" | grep "https://whois.ipip.net" -m3 | sed 's|.*https://whois.ipip.net||g' | sed 's|</a> </td>||g' | sed 's|.*>||g' | sed -n '2p' | tr -d '[:space:]')
    org=$(echo -n "$ipip_html" | grep "https://whois.ipip.net" -m3 | sed 's|.*https://whois.ipip.net||g' | sed 's|</a> </td>||g' | sed 's|.*>||g' | sed -n '3p' | tr -d '[:space:]')

    echo ""
    echo "* 当前 IP \t $ip"
    echo "* 地理位置 \t $geo"
    echo "* 运营商 \t $isp"
    echo ""
    echo "* ASN \t\t $asn"
    echo "* CIDR \t\t $cidr"
    echo "* ASN 组织 \t $org"
    echo ""
    if [ -n "$is_idc" ]; then
        echo "* 该 IP 段为 IDC 机房使用"
    fi
    if [ -n "$is_anycast" ]; then
        echo "* 该 IP 段为 ANYCAST IP 段"
    fi
}
