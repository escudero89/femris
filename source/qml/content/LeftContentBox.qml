import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

Rectangle {

    ColumnLayout {

        id: columnLayout1

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        height : parent.height * 0.97
        width : parent.width * 0.9

        spacing: 0
/*
        Component {
            id: contactDelegate

            Rectangle {

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
        }

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

                    delegate: contactDelegate

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
*/


        TableView {

            Layout.fillHeight: true
            Layout.fillWidth: true

            TableViewColumn {
                role: "title"
                title: qsTr("Modelo Físico")
                resizable: false
            }

            model: ListModel {
                id: listModelProblem
                ListElement{ title: "Ecuación de Transporte" ; author: "Gabriel" }
                ListElement{ title: "Brilliance"    ; author: "Jens" }
                ListElement{ title: "Outstanding"   ; author: "Frederik" }
            }

            onClicked: {
                console.log(listModelProblem.get(row).author);
            }
        }
/*
        PrimaryButton {
            buttonLabel: "Nuevo Modelo"
            buttonStatus: "white"
            buttonText.font.pixelSize: height / 2

            Layout.fillWidth: true
        }
*/
        Rectangle {
            color: "transparent"
            Layout.preferredHeight: columnLayout1.height * 0.02
            Layout.fillWidth: true
        }

        FirstTimeBox {
        }
    }
}
