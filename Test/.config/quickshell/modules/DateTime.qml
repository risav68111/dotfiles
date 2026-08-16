import QtQuick
import QtQuick.Layouts

Rectangle {
    id: dateTime
    property var color_on_hover: "#1a3b30"
    // anchors.centerIn: parent
    height: 32
    width: 110
    color: color_on_hover
    radius: 30

    RowLayout {
        id: subDateTime
        anchors.centerIn: parent
        // Layout.alignment: Qt.AlignHCenter
        spacing: 2
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        property int fontPixelSize: 9
        height: parent.height

        function pad(n) {
            return String(n).padStart(2, '0');
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            color: "#0db947"
            font {
                pixelSize: parent.fontPixelSize + 3
                bold: true
            }
            text: subDateTime.pad(new Date().getHours()) + ":" + subDateTime.pad(new Date().getMinutes())
            horizontalAlignment: Text.AlignHCenter
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: parent.text = subDateTime.pad(new Date().getHours()) + " : " + subDateTime.pad(new Date().getMinutes())
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            padding: 0
            color: "#a49f99"
            font {
                pixelSize: parent.fontPixelSize + 10
                // bold: true
            }
            text: "⟠"
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            color: "#7aa2f7"
            font {
                pixelSize: parent.fontPixelSize + 2
                bold: true
            }
            text: subDateTime.pad(new Date().getDate())
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: parent.text = subDateTime.pad(new Date().getDate())
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            color: "#7aa2f7"
            font {
                pixelSize: parent.fontPixelSize + 2
            }
            text: "-"
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            color: "#7aa2f7"
            font {
                pixelSize: parent.fontPixelSize + 2
                bold: true
            }

            text: subDateTime.pad(new Date().getMonth() + 1)
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: parent.text = subDateTime.pad(new Date().getMonth() + 1)
            }
        }
    }

    // ColumnLayout {
    //     id: subDateTime
    //     anchors.fill: parent
    //     spacing: 2
    //     anchors.topMargin: 12
    //     anchors.bottomMargin: 22
    //     property int fontPixelSize: 8
    //     height: parent.height
    //
    //
    //     Text {
    //         Layout.alignment: Qt.AlignHCenter
    //         color: "#7aa2f7"
    //         font {
    //             pixelSize: parent.fontPixelSize + 2
    //             bold: true
    //         }
    //         function pad(n) {
    //             return String(n).padStart(2, '0');
    //         }
    //         text: pad(new Date().getDate())
    //         Timer {
    //           interval: 1000
    //             running: true
    //             repeat: true
    //             onTriggered: parent.text = parent.pad(new Date().getDate())
    //         }
    //     }
    //
    //     // Text {
    //     //   Layout.alignment: Qt.AlignHCenter
    //     //   padding: -3
    //     //   color: "#444b6a"
    //     //   font { pixelSize: parent.fontPixelSize }
    //     //   text: "·"
    //     // }
    //
    //     Text {
    //         Layout.alignment: Qt.AlignHCenter
    //         color: "#7aa2f7"
    //         font {
    //             pixelSize: parent.fontPixelSize + 2
    //             bold: true
    //         }
    //         function pad(n) {
    //             return String(n).padStart(2, '0');
    //         }
    //         text: pad(new Date().getMonth() + 1)
    //         Timer {
    //             interval: 1000
    //             running: true
    //             repeat: true
    //             onTriggered: parent.text = parent.pad(new Date().getMonth() + 1)
    //         }
    //     }
    //
    //     // Text {
    //     //   Layout.alignment: Qt.AlignHCenter
    //     //   color: "#444b6a"
    //     //   font { pixelSize: parent.fontPixelSize }
    //     //   text: "·"
    //     // }
    //     //
    //     // Text {
    //     //   Layout.alignment: Qt.AlignHCenter
    //     //   color: "#7aa2f7"
    //     //   font { pixelSize: parent.fontPixelSize + 2; bold: true }
    //     //   text: new Date().getFullYear()
    //     //   Timer { interval: 60000; running: true; repeat: true; onTriggered: parent.text = new Date().getFullYear() }
    //     // }
    //
    //     Text {
    //         Layout.alignment: Qt.AlignHCenter
    //         padding: -8
    //         color: "#444b6a"
    //         font {
    //             pixelSize: parent.fontPixelSize + 12
    //         }
    //         text: "┉┉"
    //     }
    //
    //     Text {
    //         Layout.alignment: Qt.AlignHCenter
    //         color: "#0db947"
    //         font {
    //             pixelSize: parent.fontPixelSize + 3
    //             bold: true
    //         }
    //         function pad(n) {
    //             return String(n).padStart(2, '0');
    //         }
    //         text: pad(new Date().getHours()) + "\n" + pad(new Date().getMinutes())
    //         horizontalAlignment: Text.AlignHCenter
    //         Timer {
    //             interval: 1000
    //             running: true
    //             repeat: true
    //             onTriggered: parent.text = parent.pad(new Date().getHours()) + "\n" + parent.pad(new Date().getMinutes())
    //         }
    //     }
    // }
}
