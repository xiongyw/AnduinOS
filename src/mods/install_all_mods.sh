#!/bin/bash

#==========================
# Set up the environment
#==========================
set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error
source /root/mods/shared.sh
source /root/mods/args.sh

#==========================
# Variables for mods
#==========================
print_ok "Building variables for mods:"

echo "TARGET_UBUNTU_VERSION=$TARGET_UBUNTU_VERSION"
echo "BUILD_UBUNTU_MIRROR=$BUILD_UBUNTU_MIRROR"
echo "TARGET_NAME=$TARGET_NAME"
echo "TARGET_BUSINESS_NAME=$TARGET_BUSINESS_NAME"
echo "TARGET_BUILD_VERSION=$TARGET_BUILD_VERSION"

#==========================
# Execute mods
#==========================
mods=("$SCRIPT_DIR"/*)
IFS=$'\n' sorted_mods=($(sort <<<"${mods[*]}"))
for mod in "${sorted_mods[@]}"; do
    if [[ -d "$mod" && -f "$mod/install.sh" ]]; then
        print_info "#####################################################################################"
        print_info "Processing mod: $mod"
        print_info "#####################################################################################"
        (
            cd "$mod" && \
            chmod +x install.sh && \
            bash "$mod/install.sh"
        )
#        # Check if the install script executed successfully
#        if [ $? -eq 0 ]; then
#            print_info "Mod $mod processed successfully."
#        else
#            print_info "Error processing mod $mod."
#        fi
#        # Prompt user to continue or abort
#        while true; do
#            read -p "Continue to the next mod? (Y/N): " response
#            case "$response" in
#                [Yy]*)
#                    break  # Continue to the next mod
#                    ;;
#                [Nn]*)
#                    print_info "Aborting further processing."
#                    exit 0  # Exit the script
#                    ;;
#                *)
#                    print_info "Please enter Y or N."
#                    ;;
#            esac
#        done
    fi
done
