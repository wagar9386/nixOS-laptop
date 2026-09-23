#!/usr/bin/env bash

city=$(cat /run/user/1000/secrets/weather_city)
raw=$(curl -s "wttr.in/$city?format=%C|%t&m" 2>/dev/null)
cond=$(echo "$raw" | cut -d'|' -f1 | tr '[:upper:]' '[:lower:]')
temp=$(echo "$raw" | cut -d'|' -f2)

# Get current hour to determine day/night
hour=$(date +%H)
is_night=false
if [ "$hour" -lt 6 ] || [ "$hour" -ge 21 ]; then
    is_night=true
fi

if echo "$cond" | grep -qE "thunder|lightning"; then
    icon="󰙾"  # nf-weather-thunderstorm
elif echo "$cond" | grep -qE "sleet|hail|freezing rain"; then
    icon="󰙿"  # nf-weather-sleet
elif echo "$cond" | grep -qE "blizzard|snow"; then
    icon="󰜗"  # nf-weather-snow
elif echo "$cond" | grep -qE "shower|drizzle"; then
    icon="󰖗"  # nf-weather-showers
elif echo "$cond" | grep -qE "rain"; then
    icon="󰖖"  # nf-weather-rain
elif echo "$cond" | grep -qE "fog|mist|haze"; then
    icon="󰖑"  # nf-weather-fog
elif echo "$cond" | grep -qE "overcast"; then
    icon="󰖐"  # nf-weather-cloudy
elif echo "$cond" | grep -qE "cloud|partly"; then
    if $is_night; then
        icon="󰖔"  # nf-weather-night_alt_partly_cloudy
    else
        icon="󰖕"  # nf-weather-day_cloudy
    fi
elif echo "$cond" | grep -qE "clear|sunny"; then
    if $is_night; then
        icon="󰖔"  # nf-weather-night_clear
    else
        icon="󰖙"  # nf-weather-day_sunny
    fi
else
    if $is_night; then
        icon="󰖔"
    else
        icon="󰖙"
    fi
fi

echo "$icon $temp"
