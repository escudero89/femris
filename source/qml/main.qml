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
        color: Style.color.background
        z: -1000
    }

    RowLayout {

        id: parentLayout

        anchors.fill: parent
        anchors.margins: 50

        ColumnLayout {

            id: columnLayout

            //anchors.fill: parent
            //anchors.margins: 50

            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Layout.maximumWidth: 900
            anchors.horizontalCenter: parent.horizontalCenter

            spacing: 0

            Rectangle {
                z: -900

                color: Style.color.complement_highlight
                anchors.fill: parent
            }

            Rectangle {
                id: header_main


                height: 40
                color: Style.color.complement
                anchors.top: parent.top
                anchors.topMargin: 0
                width: parent.width
            }

            ListView {
                id: blocksView

                anchors.margins: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: header_main.bottom
                anchors.bottom: parent.bottom

                orientation: ListView.Horizontal
                flickableDirection: Flickable.HorizontalFlick
                interactive: false

                spacing: 6

                delegate: Item {

                    width: blocksView.width / blocksModel.count - blocksView.spacing / (blocksModel.count - 1)

                    ChoiceBlock {
                        height: blocksView.height
                        width: parent.width
                    }
                }

                model: ListModel {
                    id: blocksModel

                    ListElement {
                        header: "TUTORIAL"
                        buttonId: "buttonTutorial"
                        buttonText: "Iniciar"
                    }
                    ListElement {
                        header: "NUEVO"
                        buttonId: "buttonCreateStudyCase"
                        buttonText: "Crear"
                    }
                    ListElement {
                        header: "ABRIR"
                        buttonId: "buttonModifyStudyCase"
                        buttonText: "Cargar"
                    }
                }

            }
        }
    }
}
