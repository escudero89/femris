import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

import "../"

Button {

    id: button

    property alias buttonText : button
    property alias buttonLabel : button.text
    property string buttonStatus : "default"

    enabled: (buttonStatus !== 'disabled')

    implicitHeight: 30
    implicitWidth: 140

    style: ButtonStyle {
        label: Item{}

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
                            text.color = Style.color.complement;
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

            Row {
                id: row
                anchors.centerIn: parent
                spacing: 4
                Image {
                    visible: iconSource === "" ? false : true

                    source: iconSource
                    anchors.verticalCenter: parent.verticalCenter
                    height: button.height * .5
                    fillMode: Image.PreserveAspectFit //mm Image should shrink if button is too small, depends on QTBUG-14957
                }
                Text {
                    id:text
                    anchors.verticalCenter: parent.verticalCenter
                    text: button.text
                    horizontalAlignment: Text.Center

                    font.family: "Tahoma"
                    font.pixelSize: button.height * .4
                    wrapMode: Text.WordWrap

                    color: Style.color.background_highlight

                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
