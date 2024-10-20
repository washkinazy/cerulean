DOTS/Ansible:
- Cleanup 'Desktop' Entries
https://wiki.archlinux.org/title/Desktop_entries#Hide_desktop_entries
    do not modify within image, copy specific apps desktop entries to the user home and append 'hidden' as part of dots config.
        gnome-software
        gnome-extensions (classic)
- "user" Mounts
- GSCHEMA for user preferences
- rpm-ostree kargs --append= (only laptop, power and boot update)
- Themes for all, download and prep in universal location in home. 
- foot custom theming
- 

IMAGE:
- Flatpak document scanner
- flush out hyprland packages
- Memory, ZRAM, etc -> --- validate
- start adding nwg (other) apps that work with both gnome/hyprland

Where does the gaming software live?

- https://github.com/ublue-os/bluefin/blob/main/aurora_flatpaks/flatpaks
- https://github.com/ublue-os/bluefin/blob/main/packages.json
- https://codeberg.org/dnkl/foot
- https://codeberg.org/dnkl/fuzzel



