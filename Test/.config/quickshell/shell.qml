import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow  {
  anchors.top: true
  anchors.left: true
  anchors.bottom: true
  implicitWidth: 32
  // anchors.right: true
  // implicitHeight: 34
  color: "#1a1b26"

  ColumnLayout {
    anchors.fill:parent
    anchors.margins: 8
    Repeater {
      model: 9
      Text {
        property var ws: Hyprland.workspaces.values. find(w => w.id == index + 1)
        property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
        text: isActive ? "" : "" 
        color: isActive ? "#0db947" : (ws ? "#7aa2f7" : "#444b6a")
        font { pixelSize: 20; bold: true}

        MouseArea {
          anchors.fill: parent
          onClicked: Hyprland.dispatch("workspace " + (index + 1))
        }
      }
    }
    Item {Layout.fillHeight: true}
  }

  // Text {
  //   anchors.centerIn: parent
  //   text: "text Here Hello there"
  //   color: "#a9b1d6"
  //   font.pixelSize: 14
  // }

}

//FloatingWindow {
//  visible: true
//  width: 200
//  height: 100
//  Text {
//    anchors.centerIn: parent
//    text: "Hello, Quickshell!!"
//    color: "#0db947"
//    font.pixelSize: 18
//  }
//}
