import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Scope {
  id: root
  property bool shouldShowOsd: false
  property real brightness: 0

  // read brightness on start
  Process {
    id: getBrightness
    command: ["bash", "-c", "cat /sys/class/backlight/*/brightness"]
    running: true
    stdout: SplitParser {
      onRead: data => root.brightness = parseFloat(data.trim())
    }
  }

  Process {
    id: getMaxBrightness
    property real maxBrightness: 100
    command: ["bash", "-c", "cat /sys/class/backlight/*/max_brightness"]
    running: true
    stdout: SplitParser {
      onRead: data => getMaxBrightness.maxBrightness = parseFloat(data.trim())
    }
  }

  // watch for brightness changes
  Timer {
    interval: 500
    running: true
    repeat: true
    onTriggered: getBrightness.running = true
  }

  // detect change and show OSD
  property real lastBrightness: 0
  onBrightnessChanged: {
    if (lastBrightness !== brightness) {
      lastBrightness = brightness
      shouldShowOsd = true
      hideTimer.restart()
    }
  }

  Timer {
    id: hideTimer
    interval: 1500
    onTriggered: root.shouldShowOsd = false
  }

  LazyLoader {
    active: root.shouldShowOsd

    PanelWindow {
      anchors.top: true
      // anchors.bottom: true
      // margins.bottom: screen.height / 5
      exclusiveZone: 0
      implicitWidth: 400
      implicitHeight: 50
      color: "transparent"
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
          spacing: 10

          // brightness icon
          Text {
            font.pixelSize: 20
            font.family: "JetBrainsMono Nerd Font"
            property real pct: root.brightness / getMaxBrightness.maxBrightness
            text: pct < 0.25 ? "󰃞" : pct < 0.5 ? "󰃟" : pct < 0.75 ? "󰃠" : "󰃠"
            color: "#ffffff"
          }

          // track
          Rectangle {
            Layout.fillWidth: true
            implicitHeight: 10
            radius: 20
            color: "#50ffffff"

            // fill
            Rectangle {
              anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
              }
              implicitWidth: parent.width * (root.brightness / getMaxBrightness.maxBrightness)
              radius: parent.radius
              color: "#f7c948"

              Behavior on implicitWidth {
                NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
              }
            }
          }

          // percentage text
          Text {
            text: Math.round((root.brightness / getMaxBrightness.maxBrightness) * 100) + "%"
            color: "#ffffff"
            font.pixelSize: 13
          }
        }
      }
    }
  }
}
