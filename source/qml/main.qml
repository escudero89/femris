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

    menuBar: TopMenuBar {}

    statusBar: StatusBar {
        Text {
            id: globalInfoBox
            horizontalAlignment: Text.AlignRight

            property string baseValue : qsTr("InfoBox")
            text: baseValue

            function setInfoBox (msg, reset) {
                if (reset) {
                    text = baseValue
                } else {
                    text = msg
                }
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

        visible: false
    }

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

        Rectangle {
            anchors.fill: parent
            color: "transparent"

            AnimatedImage {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/resources/images/loader.gif"

                height: parent.height / 5
                width: height
                opacity: 0.8
            }

        }

        Loader  {
            anchors.fill: parent

            id: globalLoader

            // Esperamos a que se cargen los hijos antes de cargar el resto
            asynchronous: true
            visible: false

            onLoaded: {
                visible = true;
                globalInfoBox.setInfoBox(null, true);
                console.debug("Loaded: " + globalLoader.source)
            }

        }

        // Esto activara el onLoaded cuando se complete
        Component.onCompleted: {
            globalLoader.setSource("screens/CE_Domain.qml");
        }

    }

    // Esta funcion contra el cambio entre secciones
    function switchSection(section) {
        var redirection = null;
        switch (section) {
            case "tutorial" :
                redirection = "BaseFrame";
                break;
            default :
                redirection = section;
                break;
        }

        globalInfoBox.setInfoBox("Cargando...");
        globalLoader.visible = false;
        globalLoader.setSource("screens/" + redirection + ".qml");
    }

    Item {
        id: loadingModal
        visible: false

        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        z: 1000

        Rectangle {
            anchors.fill: parent
            color: Style.color.complement

            opacity: 0.8

        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            height: parent.height * 0.7
            width: parent.width * 0.7

            color: Style.color.info

            border.width: 3
            border.color: Style.color.background

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    GradientStop { position: 1.0; color: "black" }
                }

                opacity: 0.2
                z: parent.z + 1
            }

            RowLayout {

                anchors.fill: parent
                z: parent.z + 2

                ProgressBar {
                    Layout.alignment: Qt.AlignCenter

                    indeterminate: true
                }
            }

        }


        Connections {
            target: ProcessHandler

            onProccessCalled: {
                loadingModal.visible = 1;
                console.log("Called...");
            }

            onProcessWrote: {
                console.log("Wrote...");
            }

            onProcessRead: {
                console.log("Read...");
            }

            onProcessFinished: {
                loadingModal.visible = 0;
                console.log("Finished...");
            }

        }
    }
}
