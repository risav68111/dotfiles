pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int cpuUsage: 0
    property real memoryUsage: 0
    property real totalMemory: 0
    property real cpuTemp: 0
    property real gpuTemp: 0

    property list<var> topProcesses: []

    property int coreCount: 0
    property list<real> coreUsages: []
    property var previousCoreStats: []
    property real lastIdle: 0
    property real lastTotal: 0

    // Overall CPU usage
    Process {
        id: cpuProc
        command: ["sh", "-c", "head -n1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                const fields = data.trim().split(/\s+/);
                if (fields.length < 8)
                    return;

                const idle = parseFloat(fields[4]) + parseFloat(fields[5]);
                const total = fields.slice(1, 8).reduce((a, b) => a + parseFloat(b), 0);

                if (root.lastTotal > 0) {
                    const idleDelta = idle - root.lastIdle;
                    const totalDelta = total - root.lastTotal;
                    root.cpuUsage = Math.max(0, Math.round(100 * (totalDelta - idleDelta) / totalDelta));
                }

                root.lastIdle = idle;
                root.lastTotal = total;
            }
        }
    }

    Timer {
        interval: 1200
        running: true
        repeat: true
        onTriggered: cpuProc.running = true
    }

    // Per-core CPU usage
    Process {
        id: coreStatProc
        command: ["sh", "-c", "grep '^cpu[0-9]' /proc/stat"]
        stdout: StdioCollector {
            onStreamFinished: {
                const coreLines = this.text.trim().split('\n');
                const newCoreStats = [];
                const usages = [];

                for (let i = 0; i < coreLines.length; i++) {
                    const fields = coreLines[i].trim().split(/\s+/).slice(1).map(Number);
                    const total = fields.reduce((a, b) => a + b, 0);
                    const idle = fields[3];

                    if (root.previousCoreStats[i]) {
                        const totalDiff = total - root.previousCoreStats[i].total;
                        const idleDiff = idle - root.previousCoreStats[i].idle;
                        usages.push(totalDiff > 0 ? Math.floor(parseFloat(Math.max(0, (1 - idleDiff / totalDiff)) * 100)) : 0);
                    } else {
                        usages.push(0);
                    }
                    newCoreStats.push({
                        total,
                        idle
                    });
                }

                root.previousCoreStats = newCoreStats;
                root.coreCount = coreLines.length;
                root.coreUsages = usages;
                // Math.floor(parseFloat(usages) * 100)
            }
        }
    }

    Timer {
        interval: 1200
        running: true
        repeat: true
        onTriggered: coreStatProc.running = true
    }

    // Top processes
    Process {
        id: topProc
        command: ["sh", "-c", "ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                const lines = data.trim().split('\n');
                let processes = [];
                for (let i = 1; i < lines.length && i < 6; i++) {
                    const parts = lines[i].trim().split(/\s+/);
                    if (parts.length >= 3) {
                        processes.push({
                            pid: parseInt(parts[0]),
                            name: parts[1],
                            cpu: parseFloat(parts[2])
                        });
                    }
                }
                root.topProcesses = processes;
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: topProc.running = true
    }

    // total memory
    Process {
        id: totalMemory
        command: ["sh", "-c", "free | awk '/Mem:/ {print int($2)}'"]
        stdout: SplitParser {
            onRead: data => root.totalMemory = parseFloat(parseFloat(data.trim()) / 1024 / 1024).toFixed(1) || 0
        }
    }
    Timer {
        interval: 3000
        running: true
        repeat: false
        onTriggered: totalMemory.running = true
    }

    // Memory usage
    Process {
        id: memProc
        command: ["sh", "-c", "free | awk '/Mem:/ {print int($3)}'"]
        stdout: SplitParser {
            onRead: data => root.memoryUsage = parseFloat(parseFloat(data.trim()) / 1024 / 1024).toFixed(1) || 0
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: memProc.running = true
    }
    // CPU temp
    Process {
        id: cpuTempProc
        command: ["sh", "-c", "cat /sys/class/thermal/thermal_zone0/temp"]
        stdout: SplitParser {
            onRead: data => root.cpuTemp = parseFloat(data.trim()) / 1000 || 0
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: cpuTempProc.running = true
    }

    // GPU temp (NVIDIA)
    Process {
        id: gpuTempProc
        command: ["sh", "-c", "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader"]
        stdout: SplitParser {
            onRead: data => root.gpuTemp = parseFloat(data.trim()) || 0
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: gpuTempProc.running = true
    }
}
