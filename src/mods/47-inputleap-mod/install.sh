set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

print_ok "Install InputLeap_3.0.2_ubuntu_24-04_amd64.deb"

# https://github.com/input-leap/input-leap/releases/tag/v3.0.2
apt install $INTERACTIVE ./InputLeap_3.0.2_ubuntu_24-04_amd64.deb

judge "Install InputLeap_3.0.2_ubuntu_24-04_amd64.deb"
