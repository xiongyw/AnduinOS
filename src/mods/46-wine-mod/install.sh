set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

print_ok "Install Deepin Wine8-stable and WxWork"

# https://deepin-wine.i-m.dev/
wget -O- https://deepin-wine.i-m.dev/setup.sh | sh

# https://github.com/zq1997/deepin-wine/issues/388#issuecomment-2574693119
# https://github.com/zq1997/deepin-wine/issues/402#issuecomment-2749925133
apt purge $INTERACTIVE libsane1 libsane-common
cat <<EOF > /etc/apt/preferences.d/com.qq.weixin.work.deepin.pref
Package: libsane1
Pin: release l=deepin-wine
Pin-Priority: 600

Package: libsane-common
Pin: release l=deepin-wine
Pin-Priority: 600
EOF

# this will install deepin-wine8-stable as a dependency
apt install $INTERACTIVE com.qq.weixin.work.deepin

# reinstall `gnome-control-center*` which was removed by `purge libsane1`
apt install $INTERACTIVE gnome-control-center*

# https://github.com/zq1997/deepin-wine/issues/378
sed -i 's/7z x[^;]*$/& || true/' /opt/deepinwine/tools/run_v4.sh

judge "Install Deepin Wine8-stable and WxWork"
