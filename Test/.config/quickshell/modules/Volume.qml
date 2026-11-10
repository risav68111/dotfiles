import Quickshell.Services.Pipewire
import QtQuick

HoverSliderChip {
    id: vol

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false

    PwObjectTracker { objects: [vol.sink] }

    value: sink?.audio?.volume ?? 0
    icon: (muted || value === 0) ? "󰝟" : value < 0.33 ? "󰕿" : value < 0.66 ? "󰖀" : "󰕾"
    textColor: muted ? "#565f89" : "#c6d0f5"

    onValueRequested: v => {
        if (!sink?.audio) return;
        sink.audio.volume = v;
        if (v > 0) sink.audio.muted = false;
    }
    onIconClicked: if (sink?.audio) sink.audio.muted = !sink.audio.muted
}
