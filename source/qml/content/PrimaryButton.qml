import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

import "../"

Button {

    property alias buttonLabel : buttonText.text

    implicitWidth: 100
    implicitHeight: 25

    Text {
        id: buttonText
        z: 4

        text: "text"

        font.family: "Tahoma"
        font.pixelSize: parent.height / 2
        wrapMode: Text.WordWrap

        color: Style.color.background_highlight

        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    style: ButtonStyle {
        background: Rectangle {
            id: rectangle

            Rectangle {
                z: 3

                anchors.fill: parent

                border.width: control.activeFocus ? 3 : 2
                border.color: control.hovered ? Style.color.primary : Style.color.primary

                radius: 0

                color: Style.color.complement

                opacity: control.hovered? 0.3 : 0
            }

            Rectangle {
                z: 2

                anchors.fill: parent

                border.width: control.activeFocus ? 3 : 2
                border.color: control.hovered ? Style.color.primary : Style.color.primary

                radius: 0

                color: Style.color.primary
            }
        }



    }
}
