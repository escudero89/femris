import QtQuick 2.2
import QtQuick.Controls 1.1

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 960
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

    Grid {
        id: grid1
        x: 280
        width: 400
        spacing: 10
        flow: Qt.TopToBottom
        rows: 3
        columns: 1
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100

        TextArea {
            id: textArea1
            text: "Bienvenido a FEMRIS."
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 10
            font.family: "Arial"
            readOnly: true
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
        }

        Column {
            id: column1
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0

            spacing: 10

            Button {
                id: buttonTutorial
                text: qsTr("Realizar Tutorial Introductorio")
                isDefault: true
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
            }

            Button {
                id: buttonCreateStudyCase
                text: qsTr("Crear Caso de Estudio")
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
            }

            Button {
                id: buttonModifyStudyCase
                text: qsTr("Cargar Caso de Estudio")
                activeFocusOnPress: false
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
            }
        }

    }
}
