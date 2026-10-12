# adapted from https://github.com/weirane/dotfiles/blob/macos/dotconfig/sketchybar/plugins/weather.sh

get_icon() {
if [[ $is_day == 1 ]]; then
    case $code in
        1000) icon= ;; # Sunny, Clear/113
        1003) icon= ;; # Partly cloudy/116
        1006) icon= ;; # Cloudy/119
        1009) icon= ;; # Overcast/122
        1030) icon= ;; # Mist/143
        1063) icon= ;; # Patchy rain possible/176
        1066) icon= ;; # Patchy snow possible/179
        1069) icon= ;; # Patchy sleet possible/182
        1072) icon= ;; # Patchy freezing drizzle possible/185
        1087) icon= ;; # Thundery outbreaks possible/200
        1114) icon= ;; # Blowing snow/227
        1117) icon= ;; # Blizzard/230
        1135) icon= ;; # Fog/248
        1147) icon= ;; # Freezing fog/260
        1150) icon= ;; # Patchy light drizzle/263
        1153) icon= ;; # Light drizzle/266
        1168) icon= ;; # Freezing drizzle/281
        1171) icon= ;; # Heavy freezing drizzle/284
        1180) icon= ;; # Patchy light rain/293
        1183) icon= ;; # Light rain/296
        1186) icon= ;; # Moderate rain at times/299
        1189) icon= ;; # Moderate rain/302
        1192) icon= ;; # Heavy rain at times/305
        1195) icon= ;; # Heavy rain/308
        1198) icon= ;; # Light freezing rain/311
        1201) icon= ;; # Moderate or heavy freezing rain/314
        1204) icon= ;; # Light sleet/317
        1207) icon= ;; # Moderate or heavy sleet/320
        1210) icon= ;; # Patchy light snow/323
        1213) icon= ;; # Light snow/326
        1216) icon= ;; # Patchy moderate snow/329
        1219) icon= ;; # Moderate snow/332
        1222) icon= ;; # Patchy heavy snow/335
        1225) icon= ;; # Heavy snow/338
        1237) icon= ;; # Ice pellets/350
        1240) icon= ;; # Light rain shower/353
        1243) icon= ;; # Moderate or heavy rain shower/356
        1246) icon= ;; # Torrential rain shower/359
        1249) icon= ;; # Light sleet showers/362
        1252) icon= ;; # Moderate or heavy sleet showers/365
        1255) icon= ;; # Light snow showers/368
        1258) icon= ;; # Moderate or heavy snow showers/371
        1261) icon= ;; # Light showers of ice pellets/374
        1264) icon= ;; # Moderate or heavy showers of ice pellets/377
        1273) icon= ;; # Patchy light rain with thunder/386
        1276) icon= ;; # Moderate or heavy rain with thunder/389
        1279) icon= ;; # Patchy light snow with thunder/392
        1282) icon= ;; # Moderate or heavy snow with thunder/395
    esac
else
    case $code in
        1000) icon= ;; # Sunny, Clear/113
        1003) icon= ;; # Partly cloudy/116
        1006) icon= ;; # Cloudy/119
        1009) icon= ;; # Overcast/122
        1030) icon= ;; # Mist/143
        1063) icon= ;; # Patchy rain possible/176
        1066) icon= ;; # Patchy snow possible/179
        1069) icon= ;; # Patchy sleet possible/182
        1072) icon= ;; # Patchy freezing drizzle possible/185
        1087) icon= ;; # Thundery outbreaks possible/200
        1114) icon= ;; # Blowing snow/227
        1117) icon= ;; # Blizzard/230
        1135) icon= ;; # Fog/248
        1147) icon= ;; # Freezing fog/260
        1150) icon= ;; # Patchy light drizzle/263
        1153) icon= ;; # Light drizzle/266
        1168) icon= ;; # Freezing drizzle/281
        1171) icon= ;; # Heavy freezing drizzle/284
        1180) icon= ;; # Patchy light rain/293
        1183) icon= ;; # Light rain/296
        1186) icon= ;; # Moderate rain at times/299
        1189) icon= ;; # Moderate rain/302
        1192) icon= ;; # Heavy rain at times/305
        1195) icon= ;; # Heavy rain/308
        1198) icon= ;; # Light freezing rain/311
        1201) icon= ;; # Moderate or heavy freezing rain/314
        1204) icon= ;; # Light sleet/317
        1207) icon= ;; # Moderate or heavy sleet/320
        1210) icon= ;; # Patchy light snow/323
        1213) icon= ;; # Light snow/326
        1216) icon= ;; # Patchy moderate snow/329
        1219) icon= ;; # Moderate snow/332
        1222) icon= ;; # Patchy heavy snow/335
        1225) icon= ;; # Heavy snow/338
        1237) icon= ;; # Ice pellets/350
        1240) icon= ;; # Light rain shower/353
        1243) icon= ;; # Moderate or heavy rain shower/356
        1246) icon= ;; # Torrential rain shower/359
        1249) icon= ;; # Light sleet showers/362
        1252) icon= ;; # Moderate or heavy sleet showers/365
        1255) icon= ;; # Light snow showers/368
        1258) icon= ;; # Moderate or heavy snow showers/371
        1261) icon= ;; # Light showers of ice pellets/374
        1264) icon= ;; # Moderate or heavy showers of ice pellets/377
        1273) icon= ;; # Patchy light rain with thunder/386
        1276) icon= ;; # Moderate or heavy rain with thunder/389
        1279) icon= ;; # Patchy light snow with thunder/392
        1282) icon= ;; # Moderate or heavy snow with thunder/395
    esac
fi
}

wmo_to_code() {
    case $1 in
        0) code=1000 ;;
        1) code=1003 ;;
        2) code=1006 ;;
        3) code=1009 ;;
        45) code=1135 ;;
        48) code=1147 ;;
        51) code=1150 ;;
        53) code=1153 ;;
        55) code=1153 ;;
        56) code=1168 ;;
        57) code=1171 ;;
        61) code=1183 ;;
        63) code=1189 ;;
        65) code=1195 ;;
        66) code=1198 ;;
        67) code=1201 ;;
        71) code=1213 ;;
        73) code=1219 ;;
        75) code=1225 ;;
        77) code=1237 ;;
        80) code=1240 ;;
        81) code=1243 ;;
        82) code=1246 ;;
        85) code=1255 ;;
        86) code=1258 ;;
        95) code=1276 ;;
        96) code=1276 ;;
        99) code=1282 ;;
        *) code=1000 ;;
    esac
}

CACHE="$HOME/.cache/sketchybar"
mkdir -p "$CACHE"

[[ -f "$(dirname "$0")/weather.env.sh" ]] && source "$(dirname "$0")/weather.env.sh"

if [[ -z $LAT || -z $LON ]]; then
    if [[ -f "$CACHE/location" ]]; then
        source "$CACHE/location"
    else
        loc=$(curl -sf --max-time 5 "https://ipinfo.io/json")
        LAT=$(echo "$loc" | jq -r '.loc | split(",")[0]')
        LON=$(echo "$loc" | jq -r '.loc | split(",")[1]')
        if [[ -n $LAT && $LAT != null ]]; then
            printf 'LAT=%s\nLON=%s\n' "$LAT" "$LON" > "$CACHE/location"
        fi
    fi
fi

if [[ -z $LAT || $LAT == null ]]; then
    echo "[ERROR] [$(date --iso-8601=seconds 2>/dev/null || date -Iseconds)] could not determine location" >&2
    exit 0
fi

API="https://api.open-meteo.com/v1/forecast"
QUERY="latitude=$LAT&longitude=$LON&current=temperature_2m,weather_code,is_day&temperature_unit=fahrenheit"

for i in {1..4}; do
    weather=$(curl -sf --retry 2 --max-time 10 "$API?$QUERY")
    if [[ -z $weather || $(echo "$weather" | jq -r ".current // empty") == "" ]]; then
        echo "[WARNING] [$(date -Iseconds)] Weather API request failed" >&2
        if ((i == 4)); then
            echo "[ERROR] [$(date -Iseconds)] Weather API request failed 4 times" >&2
            exit 0
        fi
        sleep 10
    else
        break
    fi
done

temp=$(echo "$weather" | jq -r ".current.temperature_2m")
is_day=$(echo "$weather" | jq -r ".current.is_day")
wmo=$(echo "$weather" | jq -r ".current.weather_code")
wmo_to_code "$wmo"
get_icon

sketchybar --set "$NAME" drawing=on icon="$icon" label="${temp%%.*}°F"
