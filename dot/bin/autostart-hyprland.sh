#!/usr/bin/bash
pkill -f xdg-desktop-portal*
pkill -f polkit-kde-auth
sleep 2
systemctl --user start xdg-desktop-portal-hyprland
systemctl --user start xdg-desktop-portal
systemctl --user start plasma-polkit-agent.service
sleep 2
dbus-update-activation-environment --systemd --all

services=("pipewire.service" "pipewire.socket" "wireplumber.service")
for service in "${services[@]}"; do
    # Chesc status
    if systemctl is-active --quiet --user "$service"; then
        echo "$service Service is active, Restaring..."
        systemctl --user restart "$service"
    else
        echo "$service Service is not active, Starting..."
        systemctl --user start "$service"
    fi
done

all_services=( "xdg-desktop-portal.service" "xdg-desktop-portal-wlr.service" "xdg-desktop-portal-hyprland"\
               "pipewire.service" "pipewire.socket" "wireplumber.service"\
	       "plasma-polkit-agent.service"\
               "sway-session.target" )
for service in "${all_services[@]}"; do
	if systemctl is-active --quiet --user "$service"; then
		notify-send -u low -t 5000 "$service --> $(systemctl --user is-active $service)"
	else
		notify-send -u critical "$service --> $(systemctl --user is-active $service)"
	fi
done

#exec_always systemctl --user start sway-session.target
#exec $HOME/bin/autostart-sway.sh
#exec dbus-update-activation-environment --systemd --all
#exec /usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1 &
