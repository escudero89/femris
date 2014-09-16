import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

import "."

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 600
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

    Column {
        id: column1

        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Text {
            text: "EPA EPA"
            z: 1
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            x : parent.width / 2
        }

        Rectangle {
            color: Style.color.base3;

            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0

            ListView {
                id: listView1

                x: parent.width / 2
                y: parent.height / 2

                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                width: parent.width / 2;
                height: 160
                interactive: false

                spacing: 50

                delegate: Item {
                    //Column {
                    //  spacing: 20

                    PrimaryButton {
                        id: buttonId

                        width: listView1.width
                    }
                    //}
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
