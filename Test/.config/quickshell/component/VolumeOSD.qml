import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
    id: volumeRoot

    // Bind the pipewire node so its volume will be tracked
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() {
            volumeRoot.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    property bool shouldShowOsd: false

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: volumeRoot.shouldShowOsd = false
    }

    // The OSD window will be created and destroyed based on shouldShowOsd.
    // PanelWindow.visible could be set instead of using a loader, but using
    // a loader will reduce the memory overhead when the window isn't open.
    LazyLoader {
        active: volumeRoot.shouldShowOsd

        PanelWindow {
            // Since the panel's screen is unset, it will be picked by the compositor
            // when the window is created. Most compositors pick the current active monitor.

            anchors.top: true
            // margins.top: root.height + 10
            // anchors.bottom: true
            // margins.bottom: screen.height / 5
            exclusiveZone: 0

            implicitWidth: 300
            implicitHeight: 50
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: "#80000000"

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 15
                    }

                    IconImage {
                        implicitSize: 30
                        source: {
                            const vol = Pipewire.defaultAudioSink?.audio.volume ?? 0;
                            const muted = Pipewire.defaultAudioSink?.audio.muted ?? false;
                            if (muted || vol === 0)
                                return "file:///usr/share/icons/breeze-dark/status/22/audio-volume-muted-symbolic.svg";
                            else if (vol < 0.33)
                                return "file:///usr/share/icons/breeze-dark/status/22/audio-volume-low-symbolic.svg";
                            else if (vol < 0.66)
                                return "file:///usr/share/icons/breeze-dark/status/22/audio-volume-medium-symbolic.svg";
                            else
                                return "file:///usr/share/icons/breeze-dark/status/22/audio-volume-high-symbolic.svg";
                        }
                    }

                    Rectangle {
                        // Stretches to fill all left-over space
                        Layout.fillWidth: true

                        implicitHeight: 10
                        radius: 20
                        color: "#50ffffff"

                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }

                            implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
                            radius: parent.radius
                        }
                    }
                }
            }
        }
    }
}
