set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

print_ok "Setting up hostname..."
echo "$TARGET_NAME" > /etc/hostname

# note that this changes the transient hostname of the host, even it's in chroot ENV,
# as the /proc/sys/kernel/hostname is shared (bind mounted). we need to set it back
# when exited from chroot env.
hostname "$TARGET_NAME"
judge "Set up hostname to $TARGET_NAME"

print_ok "Configuring locales and resolvconf..."
apt update
apt install $INTERACTIVE \
    locales \
    systemd-resolved \
    apt-utils \
    --no-install-recommends
judge "Install locales and resolvconf"

print_ok "Configuring locales..."
echo "$LANG UTF-8" > /etc/locale.gen
locale-gen
update-locale LANG=$LANG LC_ALL=$LANG
judge "Configure locales"
