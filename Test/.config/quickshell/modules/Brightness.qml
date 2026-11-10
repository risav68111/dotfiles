import Quickshell.Io
import QtQuick

HoverSliderChip {
    id: br

    property bool present: false
    visible: present

    value: 0
    accent: "#f7c948"
    icon: value < 0.25 ? "󰃞" : value < 0.5 ? "󰃟" : "󰃠"

    onValueRequested: v => {
        value = v;                          // optimistic update so dragging feels instant
        setTimer.restart();
    }

    // debounce so dragging doesn't spawn a process per pixel
    Timer {
        id: setTimer
        interval: 60
        onTriggered: {
            setProc.command = ["brightnessctl", "set", Math.max(1, Math.round(br.value * 100)) + "%"];
            setProc.running = true;
        }
    }
    Process { id: setProc }

    Process {
        id: readProc
        command: ["sh", "-c",
            "b=$(ls -d /sys/class/backlight/* 2>/dev/null | head -n1); " +
            "[ -n \"$b\" ] && echo \"$(cat $b/brightness) $(cat $b/max_brightness)\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const p = text.trim().split(" ");
                if (p.length < 2) { br.present = false; return; }
                br.present = true;
                if (!setTimer.running)      // don't fight the slider while dragging
                    br.value = parseFloat(p[0]) / parseFloat(p[1]);
            }
        }
    }
    Timer {
        interval: 1500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: readProc.running = true
    }
}
