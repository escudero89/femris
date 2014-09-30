import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

import "../"

Button {

    property alias buttonText : buttonText
    property alias buttonLabel : buttonText.text
    property string buttonStatus : "default"

    enabled: (buttonStatus !== 'disabled')

    implicitWidth: 100
    implicitHeight: 25

    Text {
        id: buttonText

        text: "text"

        font.family: "Tahoma"
        font.pixelSize: parent.height / 2.5
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
                id: buttonRectangle
                anchors.fill: parent

                border.width: control.activeFocus ? 3 : 2
                border.color: color

                color: {
                    var finalColor = Style.color.primary;

                    switch (buttonStatus) {
                        case "white":
                            finalColor = Style.color.background;
                            buttonText.color = Style.color.complement;
                            break;

                        case "black":
                            finalColor = Style.color.complement;
                            buttonRectangleHover.color = Style.color.primary;
                            break;

                        case "warning":  finalColor = Style.color.warning;             break;
                        case "danger":   finalColor = Style.color.danger;              break;
                        case "info":     finalColor = Style.color.info;                break;
                        case "success":  finalColor = Style.color.success;             break;
                        case "disabled": finalColor = Style.color.comment_emphasized;  break;
                        case "used":     finalColor = Style.color.content;             break;
                    }

                    return finalColor;
                }
            }

            Rectangle {

                id: buttonRectangleHover

                anchors.fill: parent

                border.width: control.activeFocus ? 3 : 2
                border.color: color

                color: Style.color.complement

                opacity: control.hovered ? 0.3 : 0
            }

            Rectangle {

                anchors.fill: parent

                border.width: control.activeFocus ? 3 : 2
                border.color: color

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Style.color.background }
                    GradientStop { position: 1.0; color: Style.color.complement }
                }

                opacity: 0.075
            }
        }



    }
}
