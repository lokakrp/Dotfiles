#!/usr/bin/env python3

from datetime import datetime

# Get the current time
now = datetime.now()

# Convert to the desired format
formatted_time = now.strftime("%a, %b %d %H:%M")

print(formatted_time)
