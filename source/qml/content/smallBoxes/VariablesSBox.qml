import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

Rectangle {

    Layout.fillHeight: true
    Layout.fillWidth: true

    border.color: Style.color.complement

    ColumnLayout {

        height: parent.height
        width: parent.width

        spacing: 0

        Rectangle {

            id: variablesRectangle

            Layout.preferredHeight: textCode.height * 1.5
            Layout.fillWidth: true

            color: Style.color.complement

            Text {
                id: textCode

                text: qsTr("Variables")
                font.italic: true

                color: Style.color.background_highlight
                font.pixelSize: 0

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ListView {

            id: variablesList

            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.width

            delegate: Rectangle {

                anchors.horizontalCenter: parent.horizontalCenter

                width: variablesRectangle.width - 2
                height: variablesTextField.height * 1.2
                color: (index % 2 === 0) ? Style.color.background :  Style.color.background_highlight;

                RowLayout {

                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height
                    width: parent.width * .95

                    spacing: 0

                    Text {
                        Layout.fillWidth: true
                        text: title
                    }

                    TextField {
                        id: variablesTextField

                        Layout.preferredWidth: parent.width / 3
                        text: author
                    }
                }
            }

            clip: true

            z: variablesRectangle.z - 1

            model: ListModel {
                ListElement{ title: "Ecuación de Transporte" ; author: "Gabriel" }
                ListElement{ title: "Brilliance"    ; author: "Jens" }
                ListElement{ title: "Outstanding"   ; author: "Frederik" }
                ListElement{ title: "Outstanding"   ; author: "Frederik" }
                ListElement{ title: "Outstanding"   ; author: "Frederik" }
                ListElement{ title: "Outstanding"   ; author: "Frederik" }
                ListElement{ title: "Outstanding"   ; author: "Frederik" }
                ListElement{ title: "Outstanding"   ; author: "Frederik" }
                ListElement{ title: "Outstanding"   ; author: "Frederik" }
                ListElement{ title: "Outstanding"   ; author: "Frederik" }
            }
        }
    }
}
