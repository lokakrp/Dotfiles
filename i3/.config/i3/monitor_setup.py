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

monitors = []

def option_input(message):
    run = True
    while run:
        print(f"{message} 1.Yes, 2.No")
        userInput = input()
        match int(userInput):
            case 1:
                return True
            case 2:
                return False
            case _:
                continue

def multiple_options(message, options):
    run = True
    while run:
        print(f"{message}")
        for i, option in enumerate(options):
            print(f"{i}. {option}")
        choice = int(input())

        if choice < len(options):
            return option

def detect_names():
    result = subprocess.run("xrandr -q", shell=True, capture_output=True)
    if result.returncode == 0:
        linesSplit = result.stdout.splitlines()
        lines = []
        
        for line in linesSplit:
            if "connected" in str(line): lines.append(str(line))

        monitors = [line.split(" ")[0].split("b'")[-1] for line in lines]
        return monitors
    else:
        return None

def enter_names():
    monitors = []
    while True:
        print("Enter a monitor name")
        monitorName = input()
        monitors.append(monitorName)
        
        finished = option_input("Are you finished?")

        if finished:
            while True:
                for i, monitor in enumerate(monitors):
                    print(f"{i}. {monitor}")
                print("99. Exit")
                option = int(input())

                match option:
                    case 99:
                        return monitors
                    case _:
                        if option < len(monitors):
                            print("Enter a name")
                            name = input()
                            monitors[option] = name
                        else:
                            print("not an option")
        else:
            return monitors

def detect_monitors():
    while True:
        automatic_check = option_input("Do you want to automatically check for monitors?")
        
        if automatic_check:
            monitors = detect_names()
            if monitors:
                correct_monitors = option_input(f"Are these correct? {monitors}")
                if correct_monitors:
                    return monitors
                else:
                    print("Error occured when trying to detect monitors")
            else:
                print("Error occured when trying to detect monitors")
        else:
            monitors = enter_names()
            return monitors

def primary_monitor(monitors):
    while True:
        for i, monitor in enumerate(monitors):
            print(f"{i}. {monitor.name}")

        print("Which one is the primary monitor? ")
        option = int(input())

        if option < len(monitors):
            monitors[i].primary = True

            for monitor in monitors:
                if monitors[i] != monitor:
                    monitor.primary = False
            return monitors

def set_resolution(monitors):
    newMonitors = []
    for monitor in monitors:
        print(f"What is the resolution for: {monitor} in format widthxheight")
        resolution = input()
        newMonitors.append(Monitor(monitor, resolution))
    return newMonitors

def configure_monitors(monitors):
    while True:
        for monitor in monitors:
            print(monitor.name)

        option = input('Enter monitor name or type "exit": ')
        
        if option.lower() == "exit":
            return monitors

        currentIndex = None
        for i, monitor in enumerate(monitors):
            if option.lower() == monitor.name.lower():
                currentIndex = i

        monitor = monitors[currentIndex]

        while True:
            print(monitor)
            attribute = input('enter an attribute or type "exit" to quit')

            match attribute.lower():
                case "name":
                    name = input("Enter a name")
                    monitor.name = name
                case "resolution":
                    resolution = input("Enter a resolution in this format widthxheight: ")
                    monitor.resolution = resolution
                case "reference":
                    reference = multiple_options("What is the monitor referenced to?", [monitor.name for monitor in monitors])
                    monitor.reference = reference
                case "position":
                    position = multiple_options("What is the position out of these options?", ["--left-of", "--right-of", "--above", "--below", "--same-as"])
                    monitor.position = position
                case "refreshRate":
                    refreshRate = float("Enter the refresh rate: ")
                    monitor.refreshRate = refreshRate
                case "duplicate":
                    isDuplicate = option_input("Should this monitor be duplicated?")
                    monitor.isDuplicate = isDuplicate
                case "orientation":
                    orientation = multiple_options("What orientation out of these options?", ["normal", "left", "right", "inverted"])
                    monitor.orientation = orientation
                case "enabled":
                    enabled = option_input("Should this monitor be enabled?")
                    monitor.enabled = enabled
                case "exit":
                    break

def write_to_file(monitors, fileName):
    monitorDict = [monitor.to_dictionary() for monitor in monitors]

    with open(fileName, "w") as file:
        json.dump(monitorDict, file)

monitors = detect_monitors()
monitors = set_resolution(monitors)
monitors = primary_monitor(monitors)
monitors = configure_monitors(monitors)
write_to_file(monitors, "monitor_data.json")
