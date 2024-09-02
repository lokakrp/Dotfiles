import subprocess
import json

class Monitor:
    def __init__(self, name, resolution):
        self.name = name
        self.resolution = resolution
        self.reference = None
        self.position = None
        self.refreshRate = 60
        self.duplicate = False
        self.orientation = "normal"
        self.enabled = True
        self.primary = False

    def __str__(self):
        return f"Name: {self.name}\nResolution: {self.resolution}\nReference: {self.reference}\nPosition: {self.position}\nRefreshRate: {self.refreshRate}\nDuplicate: {self.duplicate}\nOrientation: {self.orientation}\nEnabled: {self.enabled}"

    def to_dictionary(self):
        return {
            "name": self.name,
            "resolution": self.resolution,
            "reference": self.reference,
            "position": self.position,
            "refreshRate": self.refreshRate,
            "duplicate": self.duplicate,
            "orientation": self.orientation,
            "enabled": self.enabled
        }

    def generate_command(self):
        if not self.enabled:
            return f"xrandr --output {self.name} --off"

        command = f"xrandr --output {self.name} --mode {self.resolution} --rate {self.refreshRate} --rotate {self.orientation}"

        if self.primary:
            command += " --primary"

        if self.position:
            positionCommand = f" {self.position} {self.reference}"
            command += positionCommand

        if self.duplicate:
            command += f" --same-as {self.reference}"

        return command


def create_monitor(data):
    monitor = Monitor(data["name"], data["resolution"])
    monitor.primary = data.get("primary")
    monitor.reference = data.get("reference")
    monitor.position = data.get("position")
    monitor.refreshRate = data.get("refreshRate")
    monitor.duplicate = data.get("duplicate")
    monitor.orientation = data.get("orientation")
    monitor.enabled = data.get("enabled")
    return monitor

def monitors_from_file(path):
    with open(path, "r") as file:
        data = json.load(file)
    return data

def main():
    data = monitors_from_file("monitor_data.json")
    
    monitors = []
    for monitorData in data:
        monitor = create_monitor(monitorData)
        monitors.append(monitor)
    
    #for monitor in monitors:
     #   command = f"xrandr --output {monitor.name} --off"
      #  result = subprocess.run(command, shell=True, capture_output=True, text=True)

    for monitor in monitors:
        command = monitor.generate_command()
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        print(command)

main()
