#!/usr/bin/bash
pkill -f xdg-desktop-portal*
sleep 2
systemctl --user start xdg-desktop-portal-wlr
systemctl --user start xdg-desktop-portal

sleep 2

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

all_services=( "xdg-desktop-portal.service" "xdg-desktop-portal-wlr.service"\
               "pipewire.service" "pipewire.socket" "wireplumber.service"\
                "sway-session.target" )
for service in "${all_services[@]}"; do
	if systemctl is-active --quiet --user "$service"; then
		notify-send -u low -t 5000 "$service --> $(systemctl --user is-active $service)"
	else
		notify-send -u critical "$service --> $(systemctl --user is-active $service)"
	fi
done

