import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

ColumnLayout {

    property alias objectRepeater: repeater
    property alias objectHeader: textHeader

    property string textRow : "Lado #"

    property string textInformation : "sideload"

    Layout.fillHeight: true
    Layout.fillWidth: true

    Text {
        id: textHeader

        text: qsTr("Condiciones de borde")

        font.pointSize: Style.fontSize.h5
    }

    Flickable {

        id: flickable

        clip: true

        Layout.fillHeight: true
        Layout.fillWidth: true

        contentWidth: flickable.width
        contentHeight: 40 * repeater.model

        onMovementStarted: Style.color.complement
        onMovementEnded: Style.color.background

        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {

            height: flickable.contentHeight
            width: flickable.contentWidth

            spacing: 0

            Repeater {

                id: repeater

                model: 0

                delegate: Rectangle {

                    Layout.preferredHeight: 40
                    Layout.preferredWidth: flickable.contentWidth

                    color: (index % 2 === 0) ? Style.color.background_highlight :  Style.color.background;

                    RowLayout {

                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height
                        width: parent.width * .95

                        spacing: 0

                        Text {
                            Layout.fillWidth: true
                            text: qsTr(textRow + (index + 1))
                        }

                        TextField {
                            Layout.preferredWidth: parent.width / 3
                            placeholderText: "x_" + ( index + 1 )

                            onEditingFinished: {
                                StudyCaseHandler.setSingleStudyCaseInformation(textInformation + "x" + (index + 1), text, true);
                            }
                        }

                        TextField {
                            Layout.preferredWidth: parent.width / 3
                            placeholderText: "y_" + ( index + 1 )

                            onEditingFinished: {
                                StudyCaseHandler.setSingleStudyCaseInformation(textInformation + "y" + (index + 1), text, true);
                            }
                        }
                    }
                }
            }
        }
    }
}
