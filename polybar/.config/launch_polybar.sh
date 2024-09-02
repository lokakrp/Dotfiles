if type "xrandr"; then
  declare -A unique_monitors

  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    info=$(xrandr --verbose | grep -A 5 "^$m" | grep -E '^[[:space:]]+')
    width=$(echo "$info" | grep -Eo '^[[:space:]]+[0-9]+x[0-9]+' | cut -d'x' -f1)
    height=$(echo "$info" | grep -Eo '^[[:space:]]+[0-9]+x[0-9]+' | cut -d'x' -f2)
    position=$(echo "$info" | grep -Eo '^[[:space:]]+[0-9]+x[0-9]+\+[0-9]+\+[0-9]+' | cut -d'+' -f2-)

    unique_key="${width}x${height}+${position}"
    unique_monitors[$unique_key]=$m
  done

  for key in "${!unique_monitors[@]}"; do
    MONITOR=${unique_monitors[$key]} polybar --reload toph &
  done
else
  polybar --reload toph &
fi

