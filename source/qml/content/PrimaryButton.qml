import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

import "../"

Button {
    height: 40

    style: ButtonStyle {
        background: Rectangle {
            id: rectangle

            implicitWidth: 100
            implicitHeight: 25

            Rectangle {
                z: 3

                implicitHeight: parent.height
                implicitWidth: parent.width

                border.width: control.activeFocus ? 3 : 2
                border.color: control.hovered ? Style.color.primary : Style.color.primary

                radius: 0

                color: Style.color.grey_darker

                opacity: control.hovered? 0.3 : 0
            }

            Rectangle {
                z: 2

                implicitHeight: parent.height
                implicitWidth: parent.width

                border.width: control.activeFocus ? 3 : 2
                border.color: control.hovered ? Style.color.primary : Style.color.primary

                radius: 0

                color: Style.color.primary
            }
        }

        label: Text {
            z: 4

            text: qsTr(buttonText)

            font.family: "Tahoma"
            font.pointSize: parent.height / 2

            color: control.hovered ? Style.color.grey_lighter : Style.color.grey_lighter

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

    }
}
