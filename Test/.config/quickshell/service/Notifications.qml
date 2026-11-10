pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root
    property bool dnd: false
    readonly property alias server: srv
    readonly property int count: srv.trackedNotifications.values.length

    NotificationServer {
        id: srv
        keepOnReload: true
        bodySupported: true
        actionsSupported: true
        imageSupported: true
        onNotification: n => { n.tracked = true; }   // keep it in the list
    }
}
