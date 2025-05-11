set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

#--------------------------------------------------------
print_ok "Install r-base, r-base-dev"
apt update
apt install -y r-base r-base-dev
judge "Install r-base, r-base-dev"


#--------------------------------------------------------
print_ok "Copying /etc/R/Rprofile.site"
mkdir -p /etc/R
mv /etc/R/Rprofile.site /etc/R/Rprofile.site.orig
cp ./Rprofile.site /etc/R/Rprofile.site
chmod 644 /etc/R/Rprofile.site
judge "Copying /etc/R/Rprofile.site"

#--------------------------------------------------------
print_ok "Install rstudio-2025.05.0-496"
# rstudio comes with a pandoc v3.4
cat ./rstudio-2025.05.0-496-amd64.deb.part-* > /tmp/rstudio-2025.05.0-496-amd64.deb
apt install -y /tmp/rstudio-2025.05.0-496-amd64.deb
rm -f /tmp/rstudio-2025.05.0-496-amd64.deb
# system-wide pandoc v3.1
apt install -y pandoc
judge "Install rstudio-2025.05.0-496"

#--------------------------------------------------------
print_ok "Install R packages"
Rscript -e 'install.packages(c("rmarkdown", "bookdown", "pagedown", "knitr", "rmdformats", "tufte", "tinytex"))'
judge "Install R packages"

#--------------------------------------------------------
print_ok "Install TinyTex"
Rscript -e 'tinytex::install_tinytex(force=TRUE, dir="/opt/TinyTex")'
cat << 'EOF' >> /etc/skel/.profile
PATH="/opt/TinyTex/bin/x86-64-linux:$PATH"
EOF
judge "Install TinyTex"

#--------------------------------------------------------
print_ok "Install Asymptote"
apt install -y asymptote asymptote-doc asymptote-x11
judge "Install Asymptote"

