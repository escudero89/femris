import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import QtQuick.Dialogs 1.2

import "."
import "content"

ApplicationWindow {
    id: mainWindow
    visible: true

    width: 800
    height: 600

    minimumWidth: 800
    minimumHeight: 600

    title: qsTr("FEMRIS - Finite Element Method leaRnIng Software")

    menuBar: MenuBar {
        Menu {
            title: qsTr("Archivo")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("Edición")
            MenuItem {
                text: qsTr("Preferencias")
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("Ayuda")
            MenuItem {
                text: qsTr("Acerca de...")
                onTriggered: Qt.quit();
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: "May I have your attention please"
        text: "It's so cool that you are using Qt Quick."
        onAccepted: {
            console.log("And of course you could only agree.")
            Qt.quit()
        }
        Component.onCompleted: visible = true
    }

    ColumnLayout {

        id: columnLayout
        anchors.fill: parent

        Text {
            text : qsTr("Femris version 0.1")
            font.italic: true
            font.pointSize: 6

            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
        }

        Text {
            text: qsTr("Bienvenido a FEMRIS")
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            x : parent.width / 2
        }

        Rectangle {
            z : -700
            color: Style.color.background;

            anchors.fill: parent

            ListView {
                id: listView1

                x: parent.width / 2
                y: parent.height / 2

                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                width: 400;

                height: 160
                interactive: false

                spacing: 50

                delegate: Item {
                    PrimaryButton {
                        id: buttonId

                        width: listView1.width
                    }
                }

                model: ListModel {
                    ListElement {
                        buttonId: "buttonTutorial"
                        buttonText: "Realizar Tutorial Introductorio"
                    }
                    ListElement {
                        buttonId: "buttonCreateStudyCase"
                        buttonText: "Nuevo Caso de Estudio"
                    }
                    ListElement {
                        buttonId: "buttonModifyStudyCase"
                        buttonText: "Cargar Caso de Estudio"
                    }
                }

            }
        }
    }
}
