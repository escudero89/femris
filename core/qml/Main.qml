import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import QtQuick.Dialogs 1.2

import "."
import "content"
import "content/components"
import "screens"

ApplicationWindow {

    signal finishedLoading();

    id: mainWindow

    width: 800
    height: 600

    minimumWidth: 800
    minimumHeight: 600

    onVisibilityChanged: Configure.write("lastWindowsSize", visibility)

    title: qsTr("FEMRIS - Finite Element Method leaRnIng Software")

    property string initialScreen : "screens/Initial.qml"

    menuBar: TopMenuBar {
        onWhichMenu: {

            switch (menuItem) {
            case "preferences":
                modals.preferences.visible = true;
                break;

            case "about":
                modals.alert.visible = true;

                modals.alert.contentTitle = "Acerca de...";
                modals.alert.contentName = "about";
                break;

            case "close":
                mainWindow.doOnClose();
                break;
            }
        }
    }

    statusBar: Item {

        id: iStatusBar

        height: sbStatusBar.height
        width: mainWindow.width

        StatusBar {

            id: sbStatusBar

            Text {
                property string baseValue : qsTr("")

                id: globalInfoBox
                horizontalAlignment: Text.AlignLeft

                text: baseValue
                textFormat: Text.RichText

                Layout.fillWidth: true

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

            MiniOverall {

                id: moStatus

                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0

                originalHeight: iStatusBar.height - 5
                width: height * 4

                z: 9500

                parentStage: ""

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: moStatus.mouseEntered();
                    onExited: moStatus.mouseExited();
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

        id: globalLoader

        anchors.fill: parent

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

            switch (signalName) {

                case "dialogs.anotherFileBeforeLoader.open()":
                    if (StudyCaseHandler.exists() && !StudyCaseHandler.getSavedStatus()) {
                        dialogs.anotherFileAlreadyOpened.parentStage = "";
                        dialogs.anotherFileAlreadyOpened.open();
                    } else {
                        StudyCaseHandler.start();
                        mainWindow.switchSection("CE_Overall");
                    }
                    break;

                case "dialogs.load.open()":

                    // Check first if another file is already open
                    if (StudyCaseHandler.exists() && !StudyCaseHandler.getSavedStatus()) {
                        dialogs.anotherFileBeforeLoader.open();
                    } else {
                        dialogs.load.folder = '';
                        dialogs.load.open();
                    }

                    break;

                case "setInfoBox":
                    globalInfoBox.setInfoBox(args);
                    break;
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
        moStatus.stepOnStudyCase = parseInt(StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess"));

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

        moStatus.parentStage = "";

        switch (section) {
        case "Tutorial":
            break;

        case "CE_Model":
        case "CE_Domain":
        case "CE_ShapeFunction":
        case "CE_Results":
            moStatus.parentStage = section;
            StudyCaseHandler.setSingleStudyCaseInformation("tutorialReturnTo", section, true);
            break;

        default :
            StudyCaseHandler.setSingleStudyCaseInformation("tutorialReturnTo", section, true);
        }

        globalInfoBox.setInfoBox("Cargando...");

        loadingImage.opacity = 0.8;

        globalLoader.visible = false;
        globalLoader.setSource("screens/" + section + ".qml");

        csiModal.open(section);
    }
}
