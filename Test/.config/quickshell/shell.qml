import Quickshell
import Quickshell.Hyprland
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

  Connections {
    target: Hyprland
    function onFocusedWorkspaceChanged() {
      console.log("workspace changed to:", Hyprland.focusedWorkspace?.id)
    }
  }

  ColumnLayout {
    anchors.fill:parent
    anchors.margins: 9
    Repeater {
      model: 10
      Text {
        required property int index
        property int wsIndex: index + 1
        property var ws: Hyprland.workspaces.values. find(w => w.id == index + 1)
        property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
        text: isActive ? "" : "" 
        color: isActive ? "#0db947" : (ws ? "#7aa2f7" : "#444b6a")
        font { pixelSize: 20; bold: true}


        MouseArea {
          anchors.fill: parent
          onClicked: Hyprland.dispatch("workspace " + (parent.wsIndex))        
        }
      }
    }
    Item {Layout.fillHeight: true}
  }
}
