#!/usr/bin/env bash

[ "$(acpi --ac-adapter | tr -d '[[:blank:]]' | cut -d ':' -f 2)" = 'power_supply' ] && is_power_supply=true

if ! ${is_power_supply}; then
	echo "Battery: $(acpi | tr -d '[[:blank:]]' | cut -d ',' -f 2) |"
fi
