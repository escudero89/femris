import QtQuick 2.3
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

   // visibility: "Maximized"

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
                id: loadingImage

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

                loadingImage.opacity = 0
            }

            PrimaryButton {

                id: buttonLoadUrlInBrowser

                property string loadUrlBase : "docs/ce_results.html"
                tooltip: qsTr("Abrir esta página en tu navegador por defecto")

                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                buttonStatus: "success"
                buttonLabel: "BROWSER"

                visible: false
                z: 1000

                onClicked: {
                    StudyCaseHandler.loadUrlInBrowser(loadUrlBase);
                }

                iconSource: "qrc:/resources/icons/external2.png"
            }

        }

        // Esto activara el onLoaded cuando se complete
        Component.onCompleted: {
            globalLoader.setSource("screens/Initial.qml");
        }

    }

    // Esta funcion contra el cambio entre secciones
    function switchSection(section) {
        var redirection = null;

        buttonLoadUrlInBrowser.visible = false;
        redirection = section;

        switch (section) {
            case "CE_ShapeFunction":
                buttonLoadUrlInBrowser.loadUrlBase = "docs/ce_shapefunction.html";
                buttonLoadUrlInBrowser.visible = true;
                break;
            case "CE_Results":
                buttonLoadUrlInBrowser.loadUrlBase = "docs/ce_results.html";
                buttonLoadUrlInBrowser.visible = true;
                break;
            case "tutorial" :
                redirection = "BaseFrame";
                buttonLoadUrlInBrowser.loadUrlBase = "docs/current.html";
                buttonLoadUrlInBrowser.visible = true;
                break;

            default :
                break;
        }

        globalInfoBox.setInfoBox("Cargando...");
        loadingImage.opacity = 0.8;
        globalLoader.visible = false;
        globalLoader.setSource("screens/" + redirection + ".qml");
    }

    LoadingModal {}

}
