import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import QtQuick.Dialogs 1.2

import "."
import "content"
import "screens"

ApplicationWindow {

    signal finishedLoading();

    id: mainWindow
    visible: true

    width: 800
    height: 600

    minimumWidth: 800
    minimumHeight: 600

    // visibility: "Maximized"

    title: qsTr("FEMRIS - Finite Element Method leaRnIng Software")

    property string initialScreen : "screens/Initial.qml"

    menuBar: TopMenuBar {
        onWhichMenu: {

            switch (menuItem) {
            case "preferences":
                modals.preferences.visible = true;
                break;

            case "about":
                //modals.alert.visible = true;

                modals.alert.contentTitle = "Acerca de...";
                modals.alert.contentName = "about";
                break;

            case "close":
                mainWindow.doOnClose();
                break;
            }
        }
    }

    statusBar: StatusBar {
        Text {
            property string baseValue : qsTr("")

            id: globalInfoBox
            horizontalAlignment: Text.AlignRight

            text: baseValue
            textFormat: Text.RichText

            Timer {
                id: resetGlobalInfoBox
                interval: 5000; running: false;
                onTriggered: globalInfoBox.text = globalInfoBox.baseValue
            }

            function setInfoBox (msg, reset) {
                text = (reset) ? baseValue : msg;
                resetGlobalInfoBox.start();
            }

            function loadUrlInBrowser (url, internal) {
                // If the url has a relative url (like "temp/index.html") we use
                // one method [internal = true], otherwise the other
                if (internal) {
                    StudyCaseHandler.loadUrlInBrowser(url);
                    setInfoBox("Se ha abierto <strong>" + url + "</strong> en tu navegador por defecto.");

                } else {
                    Qt.openUrlExternally(url);
                    setInfoBox("<a href=" + url + ">" + url + "</a> se ha abierto en tu navegador por defecto.");
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

        AnimatedImage {

            property double originalOpacity : 0.8

            id: loadingImage

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/resources/images/loader.gif"

            height: parent.height / 5
            width: height
            opacity: originalOpacity

            Connections {
                target: Configure

                onMainSignalEmitted: {
                    if (signalName === "loadingImage.show()") {
                        loadingImage.opacity = loadingImage.originalOpacity;
                    } else if (signalName === "loadingImage.close()") {
                        loadingImage.opacity = 0;
                    }
                }
            }
        }
    }

    // Current Screen Info
    CurrentScreenInfo {
        id: csiModal
        visible: false

        z: globalLoader.z + 10000;
    }

    Loader  {
        anchors.fill: parent

        id: globalLoader

        // We wait until the children are loaded to start
        asynchronous: true
        visible: false

        onLoaded: {
            visible = true;
            globalInfoBox.setInfoBox(null, true);
            console.debug("Loaded: " + globalLoader.source)

            loadingImage.opacity = 0
        }

        Component.onCompleted: {
            globalLoader.setSource(initialScreen);
        }
    }

    onFinishedLoading: {
        if (Configure.check("crashed", "true")) {
            dialogs.crashed.open();
        }

        Configure.initApp();
    }

    Modals {
        id : modals
    }

    Dialogs {
        id : dialogs
    }

    Connections {
        target: Configure

        onMainSignalEmitted: {
            if (signalName === "dialogs.load.open()") {
                dialogs.load.folder = '';
                dialogs.load.open();
            } else if (signalName === "setInfoBox") {
                globalInfoBox.setInfoBox(args);
            }
        }
    }

    onClosing: {
        close.accepted = false;
        doOnClose();
    }

    function saveAndContinue(parentStage) {

        var parentStageStep = {
            'CE_Overall'       : 0,
            'CE_Model'         : 1,
            'CE_Domain'        : 2,
            'CE_ShapeFunction' : 3,
            'CE_Results'       : 4
        }

        var stepOfProcess = parentStageStep[parentStage];

        if (StudyCaseHandler.exists() &&
            stepOfProcess < parseInt(StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess")) &&
            !StudyCaseHandler.getSavedStatus()) {
            dialogs.anotherFileAlreadyOpened.parentStage = parentStage;
            dialogs.anotherFileAlreadyOpened.open();
            return;
        }

        switch (stepOfProcess) {
        case 0: StudyCaseHandler.start();              break;
        case 1: StudyCaseHandler.createNewStudyCase(); break;
        }

        mainWindow.switchSection(StudyCaseHandler.saveAndContinue(parentStage));

    }

    function doOnClose() {
        Configure.exitApp();

        if (StudyCaseHandler.getSavedStatus()) {
            Qt.quit();
        } else {
            dialogs.beforeClosing.open();
        }
    }

    // This function manages the switch between screens
    function switchSection(section) {
        switch (section) {
        case "Tutorial":
            break;

        default :
            StudyCaseHandler.setSingleStudyCaseInformation("tutorialReturnTo", section, true);
            break;
        }

        globalInfoBox.setInfoBox("Cargando...");

        loadingImage.opacity = 0.8;

        globalLoader.visible = false;
        globalLoader.setSource("screens/" + section + ".qml");

        csiModal.open(section);
    }
}
