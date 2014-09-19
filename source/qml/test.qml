import QtQuick 2.2

Rectangle {
    id: rect
    color: "red"
    width: 10
    height: 10

    signal message (string msg)

    Behavior on color {
        NumberAnimation {
            target: rect
            property: "width"
            to: (rect.width + 20)
            duration: 2000
        }
    }
}
