import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

import "."

Button {
    height: 40

    style: ButtonStyle {
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 25

            border.width: control.activeFocus ? 3 : 2
            border.color: control.hovered ? Style.color.blue : Style.color.base02

            radius: 0
            gradient: Gradient {
                GradientStop {
                    position: 0 ;
                    color: control.pressed ? Style.color.blue : Style.color.base2
                }

                GradientStop {
                    position: 1 ;
                    color: control.pressed ? Style.color.light_blue : Style.color.base3
                }
            }
        }

        label: Text {
            text: qsTr(buttonText)

            font.family: "Inconsolata"
            font.pointSize: 14

            color: control.hovered ? Style.color.blue : Style.color.base02

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
