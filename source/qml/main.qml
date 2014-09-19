import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import QtQuick.Dialogs 1.2

import "."
import "content"
import "screens"

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
            objectName: "TextBar"
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
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        z: -1000
    }

    function doSomething () {
        console.log("does something")
    }

    Item  {

        anchors.fill: parent

        Loader  {
            anchors.fill: parent

            id: pageLoader
            onLoaded: {
//                console.log(pageLoader.item.peroqueboludo)
            }
        }

        // Esto activara el onLoaded cuando se complete
        Component.onCompleted: {
            pageLoader.setSource("test.qml")
        }

/*
        MouseArea  {
            anchors.fill: parent
            onClicked: pageLoader.source = "screens/Initial.qml"
        }*/
/*
        Connections {
            target : pageLoader.item
            onMessage : console.log(msg)
        }*/
    }
}
