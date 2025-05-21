set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

print_ok "Install Weixin For Linux v4.0.1"

cat ./WeChatLinux_x86_64.deb.* > /tmp/WeChatLinux_x86_64.deb
apt install $INTERACTIVE /tmp/WeChatLinux_x86_64.deb
rm /tmp/WeChatLinux_x86_64.deb


judge "Install Weixin For Linux v4.0.1"
