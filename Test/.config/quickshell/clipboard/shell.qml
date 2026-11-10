import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

ShellRoot {
    id: root
    property bool shown: false
    property var entries: []
    property string query: ""
    property var filtered: entries.filter(e => e.toLowerCase().includes(query.toLowerCase()))

    function isImage(line) {
        return /\[\[ binary data .*(png|jpg|jpeg|bmp|gif|webp)/i.test(line);
    }

    IpcHandler {
        target: "clipboard"
        function toggle(): void {
            root.shown = !root.shown;
            if (root.shown)
                lister.running = true;
        }
    }

    // lists entries, and first decodes any images to /tmp/qs-clip/<id>.img
    Process {
        id: lister
        command: ["sh", "-c", `
            d=/tmp/qs-clip
            mkdir -p $d
            cliphist list > $d/list.txt
            grep -F '[[ binary data' $d/list.txt | grep -E 'png|jpg|jpeg|bmp|gif|webp' | while IFS= read -r l; do
                id=$(echo "$l" | cut -f1)
                [ -f $d/$id.img ] || echo "$l" | cliphist decode > $d/$id.img
            done
            cat $d/list.txt
        `]
        stdout: StdioCollector {
            onStreamFinished: root.entries = text.split("\n").filter(l => l.length > 0)
        }
    }

    Process {
        id: copier
    }

    Process {
        id: deleter
        onExited: lister.running = true
    }

    function pick(line) {
        copier.command = ["sh", "-c", "printf '%s' \"$1\" | cliphist decode | wl-copy", "sh", line];
        copier.running = true;
        root.shown = false;
    }

    function remove(line) {
        deleter.command = ["sh", "-c", "printf '%s' \"$1\" | cliphist delete", "sh", line];
        deleter.running = true;
    }

    PanelWindow {
        visible: root.shown
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        // click outside the box closes
        MouseArea {
            anchors.fill: parent
            onClicked: root.shown = false
        }

        onVisibleChanged: {
            if (visible) {
                searchInput.text = "";
                list.currentIndex = 0;
                searchInput.forceActiveFocus();
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: 800
            height: 500
            radius: 12
            color: "#1e1e2e"
            border.color: "#45475a"
            border.width: 2

            // stops clicks on the box from closing the window
            MouseArea {
                anchors.fill: parent
            }

            // search box
            Rectangle {
                id: searchBox
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 12
                height: 40
                radius: 8
                color: "#313244"
                border.color: "#89b4fa"
                border.width: 1

                TextInput {
                    id: searchInput
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    verticalAlignment: TextInput.AlignVCenter
                    color: "#cdd6f4"
                    selectionColor: "#89b4fa"
                    font.pixelSize: 15
                    clip: true
                    focus: true

                    onTextChanged: {
                        root.query = text;
                        list.currentIndex = 0;
                    }

                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Escape) {
                            root.shown = false;
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Down) {
                            list.incrementCurrentIndex();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Up) {
                            list.decrementCurrentIndex();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            if (root.filtered.length > 0)
                                root.pick(root.filtered[list.currentIndex]);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_D && (event.modifiers & Qt.ControlModifier)) {
                            if (root.filtered.length > 0)
                                root.remove(root.filtered[list.currentIndex]);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Delete && searchInput.cursorPosition === searchInput.text.length) {
                            if (root.filtered.length > 0)
                                root.remove(root.filtered[list.currentIndex]);
                            event.accepted = true;
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Search clipboard…"
                        color: "#6c7086"
                        font.pixelSize: 15
                        visible: searchInput.text.length === 0
                    }
                }
            }

            ListView {
                id: list
                anchors.top: searchBox.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 12
                clip: true
                spacing: 4
                model: root.filtered
                currentIndex: 0
                highlightMoveDuration: 0

                delegate: Rectangle {
                    id: row
                    required property string modelData
                    required property int index
                    property bool img: root.isImage(modelData)
                    property string entryId: modelData.split("\t")[0]

                    width: ListView.view.width
                    height: img ? 130 : 36
                    radius: 6
                    color: ListView.isCurrentItem ? "#585b70" : "#313244"

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: list.currentIndex = row.index
                        onClicked: root.pick(row.modelData)
                    }

                    // text entries
                    Text {
                        visible: !row.img
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: delBtn.left
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        text: row.modelData.replace(/^\d+\t/, "")
                        color: "#cdd6f4"
                        elide: Text.ElideRight
                    }

                    // image entries
                    Image {
                        visible: row.img
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 8
                        width: 200
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignLeft
                        asynchronous: true
                        sourceSize.height: 240
                        source: row.img ? "file:///tmp/qs-clip/" + row.entryId + ".img" : ""
                    }

                    Text {
                        visible: row.img
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 224
                        text: row.modelData.replace(/^\d+\t/, "")
                        color: "#a6adc8"
                    }

                    // delete button, always visible on the right
                    Rectangle {
                        id: delBtn
                        anchors.right: parent.right
                        anchors.rightMargin: 6
                        anchors.verticalCenter: parent.verticalCenter
                        width: 28
                        height: 28
                        radius: 6
                        color: delArea.containsMouse ? "#f38ba8" : "#45475a"

                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            color: delArea.containsMouse ? "#1e1e2e" : "#f38ba8"
                        }

                        MouseArea {
                            id: delArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.remove(row.modelData)
                        }
                    }
                }
            }
        }
    }
}
