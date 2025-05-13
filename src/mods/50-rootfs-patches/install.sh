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
export PS1='\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ '
EOF

judge "Add git branch display to /etc/skel/.bashrc"
#------------------------------------------------------------------

print_ok "Copying /opt/AppImage/*.AppImage"
mkdir -p /opt/AppImage
#cp ./*.AppImage /opt/AppImage/
cat ./asbru-cm-6.4.0-1-x86_64.AppImage.part-* > /opt/AppImage/asbru-cm-6.4.0-1-x86_64.AppImage
cat ./Cherry-Studio-1.2.10-x86_64.AppImage.part-* > /opt/AppImage/Cherry-Studio-1.2.10-x86_64.AppImage
cat ./Google-Chrome-stable-136.0.7103.92-1-x86_64.AppImage.part-* > /opt/AppImage/Google-Chrome-stable-136.0.7103.92-1-x86_64.AppImage
chown root:root /opt/AppImage/*.AppImage
chmod +x /opt/AppImage/*.AppImage
cat << 'EOF' >> /etc/skel/.profile
PATH="/opt/AppImage:$PATH"
EOF
judge "Copying /optAppImage/*.AppImage"

#------------------------------------------------------------------
