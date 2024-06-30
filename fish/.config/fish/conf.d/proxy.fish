function proxy-on
    set -gx http_proxy "http://127.0.0.1:20171"
    set -gx https_proxy "http://127.0.0.1:20171"
    set -gx all_proxy "socks5://127.0.0.1:20170"
end

function proxy-off
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy
end

proxy-on
