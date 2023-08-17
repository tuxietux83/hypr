#!/usr/bin/bash

# Session check for xdg-desktop-portals and session.target
DESKTOP_SESSION=$(echo $DESKTOP_SESSION | tr '[:upper:]' '[:lower:]')
case $DESKTOP_SESSION in
	hyprland)
		pkill -f xdg-desktop-portal*
		systemctl --user stop session-*.target && systemctl --user start session-hyprland.target
		echo "session-hyprland: => $(systemctl --user is-active session-hyprland.target)"
		echo "hypr: Killing portals"
		sleep 2
		systemctl --user start xdg-desktop-portal-hyprland.service
		echo "portal: hyprland => $(systemctl --user is-active xdg-desktop-portal-hyprland.service)"
		systemctl --user start xdg-desktop-portal.service
		echo "portal: portal => $(systemctl --user is-active xdg-desktop-portal.service)"
		sleep 2
		dbus-update-activation-environment --systemd --all
		hyprctl notify -1 10000 "rgb(ff1ea3)" "xdg-desktop-portal-hyprland --> $(systemctl --user is-active xdg-desktop-portal-hyprland.service)"
		hyprctl notify -1 10000 "rgb(ff1ea3)" "xdg-desktop-portal-portal --> $(systemctl --user is-active xdg-desktop-portal.service)"
		;;
	sway)
		pkill -f xdg-desktop-portal*
		systemctl --user stop session-*.target && systemctl --user start session-sway.target
		echo "session-sway: => $(systemctl --user is-active session-sway.target)"
		echo "sway: Killing portals"
		sleep 2
		systemctl --user start xdg-desktop-portal-wlr.service
		echo "portal: wlr => $(systemctl --user is-active xdg-desktop-portal-wlr.service)"
		systemctl --user start xdg-desktop-portal.service
		echo "portal: portal => $(systemctl --user is-active xdg-desktop-portal.service)"
		sleep 2
		dbus-update-activation-environment --systemd --all
		notify-send -u low -t 10000 "xdg-desktop-portal-wlr --> $(systemctl --user is-active xdg-desktop-portal-wlr.service)"
		notify-send -u low -t 10000 "xdg-desktop-portal-portal --> $(systemctl --user is-active xdg-desktop-portal.service)"
		;;
	*)
		echo "Unknow session"
		;;
esac

# Polkit check and restart
polkit_kde="/usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1"
polkit_gnome="/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"
if [ -f "$polkit_kde" ]; then 
	pkill -f polkit-kde-auth
	sleep 2
	systemctl --user start plasma-polkit-agent.service
	echo "polkit-kde: => $(systemctl --user is-active plasma-polkit-agent.service)"
		if [ "$DESKTOP_SESSION" = hyprland ]; then
			hyprctl notify -1 10000 "rgb(ff1ea3)" "polkid-kde => $(systemctl --user is-active plasma-polkit-agent.service)"
		elif [ "$DESKTOP_SESSION" = sway ]; then
			notify-send -u low -t 10000 "polkid-kde => $(systemctl --user is-active plasma-polkit-agent.service)"
		fi
fi
if [ -f "$polkit_gnome" ];then
	pkill -f polkit-gnome-au
	"$polkit_gnome"
fi

# Audio restart for integration
pipewire=( "wireplumber.service" "pipewire.service" "pipewire.socket" )
for service in "${pipewire[@]}"; do
	if systemctl is-active --quiet --user "$service"; then
		if [ "$DESKTOP_SESSION" = hyprland ]; then
			hyprctl notify -1 10000 "rgb(ff1ea3)" "$service --> $(systemctl --user is-active $service)"
		elif [ "$DESKTOP_SESSION" = sway ]; then
			notify-send -u low -t 10000 "$service --> $(systemctl --user is-active $service)"
		fi
	else
		if [ "$DESKTOP_SESSION" = hyprland ]; then
			hyprctl notify -0 10000 "rgb(ff1ea3)" "$service --> $(systemctl --user is-active $service)"
		elif [ "$DESKTOP_SESSION" = sway ]; then
			notify-send -u critical -t 10000 "$service --> $(systemctl --user is-active $service)"
		fi
	fi
done

# Start waybar if session is sway
[ "$DESKTOP_SESSION" = sway ] && waybar -c $HOME/.config/waybar/config-sway &

##notify-send -u critical "$service --> $(systemctl --user is-active $service)"
