import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Hyprland

Rectangle {
    id: shellAppList
    anchors.fill: parent
    implicitWidth: appsRow.implicitWidth + 12
    implicitHeight: 28
    radius: 10
    color: "#b31a1b26"
    clip: true

    Item {
        id: appContainer
        anchors.fill: parent
        property var apps: []

        function resolveIcon(cls) {
            if (!cls)
                return "";
            let entry = DesktopEntries.heuristicLookup(cls) ?? DesktopEntries.heuristicLookup(cls.toLowerCase());
            let name = entry?.icon ?? cls.toLowerCase();
            if (name.startsWith("/"))
                return "file://" + name;
            return Quickshell.iconPath(name, true) || Quickshell.iconPath("application-x-executable", true);
        }

        function focusClient(addr) {
            const norm = a => String(a).replace(/^0x/, "").toLowerCase();
            const tl = Hyprland.toplevels.values.find(t => norm(t.address) === norm(addr));
            if (tl && tl.wayland)
                tl.wayland.activate();
        }

        Process {
            id: clientsProc
            command: ["hyprctl", "clients", "-j"]
            stdout: StdioCollector {
                onStreamFinished: {
                    try {
                        appContainer.apps = JSON.parse(text).filter(c => c.mapped);
                    } catch (e) {
                        console.log("JSON error:", e);
                    }
                }
            }
        }

        Timer {
            id: refreshTimer
            interval: 80
            onTriggered: clientsProc.running = true
        }
        Connections {
            target: Hyprland
            function onRawEvent(event) {
                refreshTimer.restart();
            }
        }
        Component.onCompleted: clientsProc.running = true

        RowLayout {
            id: appsRow
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            Repeater {
                model: appContainer.apps

                Rectangle {
                    id: chip
                    required property var modelData
                    property bool hovered: false

                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 22
                    radius: 7
                    color: hovered ? "#2a2b3a" : "transparent"

                    Image {
                        anchors.centerIn: parent
                        width: 18
                        height: 18
                        sourceSize: Qt.size(32, 32)
                        fillMode: Image.PreserveAspectFit
                        source: appContainer.resolveIcon(chip.modelData.class)
                    }

                    HoverHandler {
                        onHoveredChanged: chip.hovered = hovered
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: appContainer.focusClient(chip.modelData.address)
                    }
                }
            }
        }
    }
}
