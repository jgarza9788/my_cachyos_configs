import QtQuick
import Quickshell

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 32

    Rectangle {
        anchors.fill: parent
        color: "#222222"

        Text {
            anchors.centerIn: parent
            text: "Hello from Quickshell"
            color: "white"
        }
    }
}

