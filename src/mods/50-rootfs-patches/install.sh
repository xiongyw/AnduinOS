set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

# this is a place to adding or replace simple files in rootfs

#------------------------------------------------------------------
print_ok "Copying /etc/tmux.conf"
cp ./tmux.conf /etc/tmux.conf
chown root:root /etc/tmux.conf
judge "Copying /etc/tmux.conf"

#------------------------------------------------------------------
print_ok "Copying /etc/gitconfig"
cp ./gitconfig /etc/gitconfig
chown root:root /etc/gitconfig
judge "Copying /etc/gitconfig"

#------------------------------------------------------------------
print_ok "Copying /etc/vim/vimrc.local"
mkdir -p /etc/vim
cp ./vimrc.local /etc/vim/vimrc.local
chown root:root /etc/vim/vimrc.local
judge "Copying /etc/vim/vimrc.local"

#------------------------------------------------------------------
print_ok "Copying extra fonts to /usr/share/fonts/truetype/"
tar xzvf ./truetype-fonts.tgz -C /usr/share/fonts
fc-cache -f -v
judge "Copying extra fonts to /usr/share/fonts/truetype/"

#------------------------------------------------------------------
print_ok "Copying /usr/local/bin/difft"
#cp ./difft-0.63.0 /usr/local/bin/difft
cat ./difft-0.63.0.part-* > /usr/local/bin/difft-0.63.0
chown root:root /usr/local/bin/difft-0.63.0
chmod +x /usr/local/bin/difft-0.63.0
ln -s /usr/local/bin/difft-0.63.0 /usr/local/bin/difft
judge "Copying /usr/local/bin/difft"

#------------------------------------------------------------------
print_ok "Adding git branch display to /etc/skel/.bashrc..."

# Append git branch display function to .bashrc
cat << 'EOF' >> /etc/skel/.bashrc

# Git branch display in prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
EOF

judge "Add git branch display to /etc/skel/.bashrc"
#------------------------------------------------------------------

print_ok "mkdir /opt/AppImage/"
mkdir -p /opt/AppImage
chown -R root:root /opt/AppImage
judge "mkdir /opt/AppImage"

#------------------------------------------------------------------
# asbru-cm
print_ok "Setting up asbru-cm"
cat ./asbru-cm-6.4.0-1-x86_64.AppImage.part-* > /opt/AppImage/asbru-cm-6.4.0-1-x86_64.AppImage
chmod +x /opt/AppImage/asbru-cm-6.4.0-1-x86_64.AppImage
ln -s /opt/AppImage/asbru-cm-6.4.0-1-x86_64.AppImage /usr/local/bin/asbru-cm
mkdir /tmp/asbru-cm
pushd /tmp/asbru-cm
/usr/local/bin/asbru-cm --appimage-extract
cp squashfs-root/asbru-cm.svg /usr/share/icons/hicolor/scalable/apps/
cp squashfs-root/asbru-cm.desktop /usr/share/applications/
sed -i 's|^Icon=.*$|Icon=/usr/share/icons/hicolor/scalable/apps/asbru-cm.svg|' /usr/share/applications/asbru-cm.desktop
popd
rm -rf /tmp/asbru-cm
judge "Setting up asbru-cm"

#------------------------------------------------------------------
# Cherry-Studio
print_ok "Setting up cherrystudio"
cat ./Cherry-Studio-1.2.10-x86_64.AppImage.part-* > /opt/AppImage/Cherry-Studio-1.2.10-x86_64.AppImage
chmod +x /opt/AppImage/Cherry-Studio-1.2.10-x86_64.AppImage
ln -s /opt/AppImage/Cherry-Studio-1.2.10-x86_64.AppImage /usr/local/bin/cherrystudio
mkdir /tmp/cherrystudio
pushd /tmp/cherrystudio
/usr/local/bin/cherrystudio --appimage-extract
cp squashfs-root/usr/share/icons/hicolor/128x128/apps/cherrystudio.png /usr/share/icons/hicolor/128x128/apps/
cp squashfs-root/cherrystudio.desktop /usr/share/applications/
sed -i 's|Exec=AppRun --no-sandbox %U|Exec=cherrystudio --no-sandbox %U|' /usr/share/applications/cherrystudio.desktop
sed -i 's|^Icon=.*$|Icon=/usr/share/icons/hicolor/128x128/apps/cherrystudio.png|' /usr/share/applications/cherrystudio.desktop
popd
rm -rf /tmp/cherrystudio
judge "Setting up cherrystudio"

#------------------------------------------------------------------
# Google-chrome
print_ok "Setting up google-chrome"
cat ./Google-Chrome-stable-136.0.7103.92-1-x86_64.AppImage.part-* > /opt/AppImage/Google-Chrome-stable-136.0.7103.92-1-x86_64.AppImage
chmod +x /opt/AppImage/Google-Chrome-stable-136.0.7103.92-1-x86_64.AppImage
ln -s /opt/AppImage/Google-Chrome-stable-136.0.7103.92-1-x86_64.AppImage /usr/local/bin/google-chrome
mkdir /tmp/google-chrome
pushd /tmp/google-chrome
/usr/local/bin/google-chrome --appimage-extract
cp squashfs-root/google-chrome.png /usr/share/icons/hicolor/128x128/apps/
rm /usr/share/icons/Fluent/scalable/apps/google-chrome*.svg
cp squashfs-root/google-chrome.desktop /usr/share/applications/
sed -i 's|^Icon=.*$|Icon=/usr/share/icons/hicolor/128x128/apps/google-chrome.png|' /usr/share/applications/google-chrome.desktop
popd
rm -rf /tmp/google-chrome
judge "Setting up google-chrome"

#------------------------------------------------------------------
# update icon and desktop caches
gtk-update-icon-cache -f /usr/share/icons/hicolor
update-desktop-database

#------------------------------------------------------------------
##
#cat << 'EOF' >> /etc/skel/.profile
#PATH="/opt/AppImage:$PATH"
#EOF

#------------------------------------------------------------------
