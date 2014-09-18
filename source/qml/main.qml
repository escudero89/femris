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

    statusBar: StatusBar {
        Text {
            text: "Femris Version 1.0"
        }
    }

/*
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
*/

    // Para el fondo
    Rectangle {
        anchors.fill: parent
        color: Style.color.complement_highlight
        z: -1000
    }

    RowLayout {

        id: parentLayout

        anchors.fill: parent

        anchors.topMargin: parent.width / 40 ; anchors.bottomMargin: parent.width / 40
        anchors.leftMargin: parent.width / 20 ; anchors.rightMargin: parent.width / 20

        ColumnLayout {

            id: columnLayout

            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Layout.maximumWidth: 900
            anchors.horizontalCenter: parent.horizontalCenter

            spacing: 0

            Rectangle {
                id: header_main

                Layout.preferredHeight: parent.height / 10
                Layout.fillWidth: true

                color: Style.color.complement_highlight
                anchors.top: parent.top
                anchors.topMargin: 0

            }

            RowLayout {

                spacing: 10

                ChoiceBlock {
                    header: "TUTORIAL"
                    buttonLabel: "Iniciar"
                }

                ChoiceBlock {
                    header: "NUEVO"
                    buttonLabel: "Crear"
                }

                ChoiceBlock {
                    header: "ABRIR"
                    buttonLabel: "Cargar"
                }

            }

        }
    }
}
