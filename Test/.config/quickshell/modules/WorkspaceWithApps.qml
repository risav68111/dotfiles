import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: workspaceWithApps
    anchors.centerIn: parent
    Layout.alignment: Qt.AlignVCenter
    height: parent.height - 4
    width: parent.width
    color: "#666666"
    radius: 5

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        spacing: 4

        Repeater {
            model: Hyprland.toplevels

            delegate: Item {
                width: 28
                height: 28

                required property HyprlandToplevel modelData

                property string appClass: modelData.lastIpcObject?.class ?? ""
                property var desktopEntry: appClass ? DesktopEntries.byId(appClass) : null
                property string localIcon: {
                    const home = StandardPaths.writableLocation(StandardPaths.HomeLocation);
                    return `file:///${home}/.local/share/icons/hicolor/128x128/apps/${appClass}.png`;
                }

                // IconImage {
                //     // anchors.centerIn: parent
                //     implicitSize: 24
                //     source: {
                //         if (!appClass)
                //             return "";
                //         if (desktopEntry?.icon)
                //             return Quickshell.iconPath(desktopEntry.icon, true) || localIcon;
                //         return Quickshell.iconPath(appClass.toLowerCase(), true) || localIcon;
                //     }
                // }

                Component.onCompleted: Qt.callLater(() => {
                    console.log("=== APP ===");
                    console.log("appClass:", appClass);
                    console.log("desktopEntry:", desktopEntry);
                    console.log("desktopEntry.icon:", desktopEntry?.icon);
                    console.log("iconPath result:", Quickshell.iconPath(appClass.toLowerCase(), true));
                    console.log("localIcon:", localIcon);
                })
            }
        }
    }

    // Repeater {
    //     model: Hyprland.toplevels
    //     delegate: Item {
    //         required property HyprlandToplevel modelData
    // Component.onCompleted: {
    //     const obj = modelData.lastIpcObject
    //     console.log("keys:", JSON.stringify(Object.keys(obj)))
    //     console.log("full object:", JSON.stringify(obj))
    // }
    //
    //         // Component.onCompleted: {
    //         //     // print every property available
    //         //     for (var key in modelData) {
    //         //         console.log(key, ":", modelData[key])
    //         //     }
    //         // }
    //     }
    // }

    // Repeater {
    //     model: Hyprland.toplevels
    //
    //     delegate: Item {
    //         required property HyprlandToplevel modelData
    //
    //         // Look up the desktop entry by class name
    //         property var entry: DesktopEntries.byId(modelData.lastJson ? modelData.lastJson.class ?? "" : "")
    //
    //         Component.onCompleted: {
    //             console.log("class:", modelData.lastJson ? modelData.lastJson.class : "no json");
    //             console.log("entry:", entry ? entry.icon : "no entry found");
    //         }
    //         IconImage {
    //             anchors.centerIn: parent
    //             // Layout.alignment: Qt.AlignVCenter
    //             implicitSize: 24
    //             // entry.icon is the icon name, pass it to Quickshell.iconPath()
    //             source: entry ? Quickshell.iconPath(entry.icon, "application-x-executable") : Quickshell.iconPath("application-x-executable")
    //         }
    //     }
    // }
    // Repeater {
    //     model: Hyprland.toplevels   // ← NOT Hyprland.windows
    //
    //     delegate: Row {
    //         required property HyprlandToplevel modelData
    //         spacing: 8
    //
    //         Rectangle {
    //             Layout.alignment: Qt.AlignVCenter
    //             height: parent.height - 4
    //             width: 32
    //             // Text {
    //             //     text: "[ws " + (modelData.workspace ? modelData.workspace.id : "?") + "]"
    //             // }
    //             Text {
    //                 anchors.centerIn: parent
    //                 text: modelData.title.substring(0, 10) + (modelData.title.length > 10 ? "..." : "")
    //                 font {
    //                     pixelSize: 15
    //                     bold: true
    //                 }
    //             }
    //         }
    //     }
    // }
}
