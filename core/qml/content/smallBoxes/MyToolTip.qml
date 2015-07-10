import QtQuick 2.4

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

Rectangle {
    id: tooltip

    property alias text: tooltipText.text
    property alias textItem: tooltipText
    property int fadeInDelay: 250
    property int fadeOutDelay: 250
    property bool autoHide: true
    property alias autoHideDelay: hideTimer.interval
    property bool destroyOnHide: false

    function show() {
        state = "showing"
        if (hideTimer.running) {
            hideTimer.restart()
        }
    }

    function hide() {
        if (hideTimer.running) {
            hideTimer.stop()
        }
        state = "hidden"
    }

    width: tooltipText.width + 20
    height: tooltipText.height + 10
    color: "#dd000000"
    radius: 6
    opacity: 0

    Text {
        id: tooltipText
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        color: "white"
        font.pointSize: 10
        font.bold: true

        textFormat: Text.RichText
    }

    MouseArea {
        anchors.fill: parent
        onClicked: hide()
    }

    Timer {
        id: hideTimer
        interval: 5000
        onTriggered: hide()
    }

    states: [
        State {
            name: "showing"
            PropertyChanges { target: tooltip; opacity: 1 }
            onCompleted: {
                if (autoHide) {
                    hideTimer.start()
                }
            }
        },
        State {
            name: "hidden"
            PropertyChanges { target: tooltip; opacity: 0 }
            onCompleted: {
                if (destroyOnHide) {
                    tooltip.destroy()
                }
            }
        }
    ]

    transitions: [
        Transition {
            to: "showing"
            NumberAnimation { target: tooltip; property: "opacity"; duration: fadeInDelay }
        },
        Transition {
            to: "hidden"
            NumberAnimation { target: tooltip; property: "opacity"; duration: fadeOutDelay }
        }
    ]
}
