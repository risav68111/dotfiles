import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: chip

    property string icon: ""
    property real value: 0                  // 0..1
    property color accent: "#7aa2f7"
    property color textColor: "#c6d0f5"
    property real step: 0.05

    signal valueRequested(real v)           // user wants a new value
    signal iconClicked()

    property bool open: false
    readonly property bool hovering: mouse.containsMouse || popHover.hovered

    onHoveringChanged: {
        if (hovering) {
            closeTimer.stop();
            open = true;
        } else {
            closeTimer.restart();           // small grace period so the popup doesn't flicker
        }
    }
    Timer {
        id: closeTimer
        interval: 200
        onTriggered: chip.open = false
    }

    implicitWidth: Math.max(28, label.implicitWidth + 20)
    implicitHeight: 28
    radius: 6
    color: "#1a1b26"
    opacity: hovering ? 0.95 : 0.75
    Behavior on opacity { NumberAnimation { duration: 200 } }

    Text {
        id: label
        anchors.centerIn: parent
        text: chip.icon + " " + Math.round(chip.value * 100) + "%"
        color: chip.textColor
        font { pixelSize: 12; bold: true; family: "JetBrainsMono Nerd Font" }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: chip.iconClicked()
        onWheel: wheel => {
            const d = wheel.angleDelta.y > 0 ? chip.step : -chip.step;
            chip.valueRequested(Math.max(0, Math.min(1, chip.value + d)));
        }
    }

    PopupWindow {
        id: popup
        anchor.item: chip
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        visible: chip.open
        implicitWidth: 200
        implicitHeight: 48
        color: "transparent"

        Item {
            anchors.fill: parent

            HoverHandler { id: popHover }

            // 6px of transparent padding on top keeps hover continuous between chip and popup
            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 6
                radius: 10
                color: "#e61a1b26"
                border.width: 1
                border.color: "#33c6d0f5"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    Text {
                        text: chip.icon
                        color: chip.textColor
                        font { pixelSize: 16; family: "JetBrainsMono Nerd Font" }
                    }

                    Item {
                        id: sliderArea
                        Layout.fillWidth: true
                        Layout.preferredHeight: 24

                        Rectangle {
                            id: track
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 8
                            radius: 4
                            color: "#2a2b3a"

                            Rectangle {
                                width: parent.width * chip.value
                                height: parent.height
                                radius: 4
                                color: chip.accent
                            }
                        }

                        Rectangle {                       // knob
                            x: track.width * chip.value - width / 2
                            anchors.verticalCenter: parent.verticalCenter
                            width: 14; height: 14; radius: 7
                            color: "#c6d0f5"
                        }

                        MouseArea {
                            anchors.fill: parent
                            function setFrom(x) {
                                chip.valueRequested(Math.max(0, Math.min(1, x / width)));
                            }
                            onPressed: m => setFrom(m.x)
                            onPositionChanged: m => { if (pressed) setFrom(m.x); }
                            onWheel: w => {
                                const d = w.angleDelta.y > 0 ? chip.step : -chip.step;
                                chip.valueRequested(Math.max(0, Math.min(1, chip.value + d)));
                            }
                        }
                    }

                    Text {
                        text: Math.round(chip.value * 100) + "%"
                        color: chip.textColor
                        font { pixelSize: 12; bold: true }
                        Layout.preferredWidth: 32
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
        }
    }
}
