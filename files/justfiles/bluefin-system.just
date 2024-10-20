# vim: set ft=make :
########################
### bluefin-system.just
########################
## Lifted from Bluefin, removed unwanted commands
## Standardized verbs
# configure- = configure something that is pre-installed on the image
# install-   = install something, no uninstall or configuration provided
# setup-     = install something and also provide configuration and/or uninstallation options
# toggle-    = turn something on/off, logic can be automatic or manual selection
# fix-       = apply fix/patch/workaround for something
# foo        = no verb is used for shortcuts or something deemed important enough to use a super memorable name

# Run a one minute system benchmark
benchmark:
    echo 'Running a 1 minute benchmark ...'
    cd /tmp && stress-ng --matrix 0 -t 1m --times


# Configure docker,libvirt container manager permissions
virt-group:
    #!/usr/bin/env bash
    append_group() {
    local group_name="$1"
    if ! grep -q "^$group_name:" /etc/group; then
      echo "Appending $group_name to /etc/group"
      grep "^$group_name:" /usr/lib/group | sudo tee -a /etc/group > /dev/null
    fi
    }

    append_group docker
    append_group libvirt

    sudo usermod -aG docker $USER
    sudo usermod -aG libvirt $USER
    echo "Logout to use docker, libvirt"

# Configure grub bootmenu visibility
configure-grub:
    @/usr/libexec/configure-grub.sh

alias rollback-helper := rebase-helper
alias switch-channel := rebase-helper


# Toggle tailscale
toggle-tailscale:
    #!/bin/bash
    set -euo pipefail
    source /usr/lib/ujust/ujust.sh
    source /usr/lib/os-release

    TAILSCALED_STATUS="$(systemctl is-enabled tailscaled || true )"

    if [ "$TAILSCALED_STATUS" == "enabled" ] || [ "$TAILSCALED_STATUS" == "disabled" ]; then
        TAILSCALED="Installed"
    else 
        TAILSCALED="Not Found"
        echo "${b}${red}Unable to enable or disable Tailscale.${n}"
        echo "The tailscaled service must be present and either enabled or disabled to run this script."
        echo "tailscaled service status: $TAILSCALED_STATUS"
    fi


    if [ "$TAILSCALED" == "Installed" ]; then
      echo "Enable or disable Tailscale?"
      TS_OPTION=$(ugum choose Enable Disable)

      # gnome-extensions is only available on Bluefin (Gnome)
      if [ "$VARIANT" == "silverblue" ]; then
        TAILSCALE_QS="$(gnome-extensions list | grep -q "tailscale@joaophi.github.com"; echo $?)"
        if [ "$TAILSCALE_QS" == 0 ]; then
          TAILSCALE_QS="Installed"
        else
          echo "The Tailscale QS extension for Gnome is not installed. Please install it and then run this script again."
        fi

        if [ "$TS_OPTION" = "Enable" ]; then
          gnome-extensions enable tailscale@joaophi.github.com
        elif [ "$TS_OPTION" = "Disable" ]; then
          gnome-extensions disable tailscale@joaophi.github.com
        fi
      fi

      if [ "$TS_OPTION" = "Enable" ]; then
        systemctl enable --now tailscaled
        TAILSCALED_STATUS="$(systemctl is-enabled tailscaled || true )"
        if [ "$TAILSCALED_STATUS" == "enabled" ]; then
          echo "${b}${green}Tailscale is enabled.${n}"
          echo "If this is your first time using Tailscale, setup is necessary."
          echo "Refer to Tailscale's documentation at https://tailscale.com/kb/1346/start."
        fi
      elif [ "$TS_OPTION" = "Disable" ]; then
        systemctl disable --now tailscaled
        TAILSCALED_STATUS="$(systemctl is-enabled tailscaled || true )"
        if [ "$TAILSCALED_STATUS" == "disabled" ]; then
          echo "${b}${red}Tailscale is disabled.${n}"
        fi
      fi
    fi