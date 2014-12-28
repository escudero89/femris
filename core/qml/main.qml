import QtQuick 2.4
import QtQuick.Controls 1.3
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

    property string initialScreen : "screens/Initial.qml"

    menuBar: TopMenuBar {
        onWhichMenu: {

            switch (menuItem) {
            case "preferences":
                preferencesModal.visible = true;
                break;

            case "about":
                alertModal.visible = true;

                alertModal.contentTitle = "Acerca de...";
                alertModal.contentName = "about";
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
                if (reset) {
                    text = baseValue
                } else {
                    text = msg
                }

                resetGlobalInfoBox.start();
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

    AlertModal { id: alertModal }
    LoadingModal {}
    FirstTimeModal { visible: !Configure.check("firstTime", "true") }
    FirstTimeModal { id: preferencesModal; firstTime: false }

    MessageDialog {
        id: crashedDialog
        visible: false

        title: qsTr("Al parecer FEMRIS sufrió un fallo")
        text: {
            var msg =
                "Al parecer, la última vez que iniciaste FEMRIS éste no se cerró correctamente." +
                "\n\nSin embargo, puedes intentar recuperar tu Caso de Estudio revisando los archivos temporales.";

            return qsTr(msg);
        }

        detailedText: "La última vez que iniciaste FEMRIS, según nuestros registros, fue el "  + Configure.read("lastAccessDate") + ".";

        icon: StandardIcon.Warning

        standardButtons: StandardButton.Open | StandardButton.Cancel

        onAccepted: {
            femrisLoader.folder = fileApplicationDirPath + "/temp/";
            femrisLoader.markAsSaved = false;
            femrisLoader.open();
        }

        Component.onCompleted: {
            if (Configure.check("crashed", "true")) {
                crashedDialog.open();
            }
            Configure.initApp();
        }
    }

    MessageDialog {
        id: beforeClosingDialog
        title: qsTr("¿Guardar Caso de Estudio?")
        text: qsTr("Sí no guarda, los cambios efectuados desde el último punto de guardado se perderán para siempre.")

        icon: StandardIcon.Warning
        standardButtons : StandardButton.Save | StandardButton.Cancel | StandardButton.Discard

        onRejected: {
            beforeClosingDialog.close();
        }

        onDiscard: {
            Qt.quit()
        }

        onAccepted: {
            femrisSaverAndExit.open();
        }

        visible: false
    }

    MessageDialog {

        property string parentStage : ""

        id: anotherFileAlreadyOpenedDialog
        title: qsTr("Ya hay un Caso de Estudio abierto")
        text: qsTr("Puede guardar los cambios de su Caso de Estudio actual antes de continuar con uno nuevo. Sí no guarda, los cambios efectuados desde el último punto de guardado se perderán para siempre.")

        icon: StandardIcon.Warning
        standardButtons : StandardButton.Save | StandardButton.Cancel | StandardButton.Discard

        onRejected: {
            anotherFileAlreadyOpenedDialog.close();
        }

        onDiscard: {
            mainWindow.switchSection(StudyCaseHandler.saveAndContinue(parentStage));
        }

        onAccepted: {
            femrisSaver.parentStage = parentStage;
            femrisSaver.open();
            anotherFileAlreadyOpenedDialog.close();
        }

        visible: false
    }

    FileDialog {
        id: femrisLoader
        title: "Por favor seleccione un archivo de FEMRIS"

        property bool markAsSaved : true;

        nameFilters: [ "Archivos de FEMRIS (*.femris *.femris.old)", "Todos los archivos (*)" ]

        onAccepted: {
            StudyCaseHandler.loadStudyCase(femrisLoader.fileUrl);
            mainWindow.switchSection("CE_Overall");

            if (StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess") > 3) {
                ProcessHandler.executeInterpreter(StudyCaseHandler.getSingleStudyCaseInformation("typeOfStudyCase"));
            }

            if (!markAsSaved) {
                StudyCaseHandler.markAsNotSaved();
                femrisLoader.markAsSaved = true;
            }
        }

    }

    FileDialog {
        property string parentStage : ""

        id: femrisSaver
        title: "Guardar Caso de Estudio como..."

        nameFilters: [ "Archivos de FEMRIS (*.femris)", "Todos los archivos (*)" ]

        selectExisting: false

        modality: "ApplicationModal"

        onAccepted: {
            console.log("You chose: " + fileUrl);
            StudyCaseHandler.saveCurrentStudyCase(fileUrl);

            if (parentStage.length) {
                mainWindow.switchSection(StudyCaseHandler.saveAndContinue(parentStage));
            }
        }
        onRejected: {
            console.log("Canceled");
        }
    }

    FileDialog {
        id: femrisSaverAndExit
        title: "Guardar Caso de Estudio como..."
        nameFilters: [ "Archivos de FEMRIS (*.femris)", "Todos los archivos (*)" ]
        selectExisting: false
        modality: "ApplicationModal"
        onAccepted: {
            StudyCaseHandler.saveCurrentStudyCase(fileUrl);
            Qt.quit();
        }
    }

    Connections {
        target: Configure

        onMainSignalEmitted: {
            if (signalName === "femrisLoader.open()") {
                femrisLoader.folder = '';
                femrisLoader.open();
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
            parseInt(StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess")) > stepOfProcess) {
            anotherFileAlreadyOpenedDialog.parentStage = parentStage;
            anotherFileAlreadyOpenedDialog.open();
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

        if (!StudyCaseHandler.getSavedStatus()) {
            beforeClosingDialog.open();
        } else {
            Qt.quit();
        }
    }

    // This function manages the switch between screens
    function switchSection(section) {
        var redirection = section;

        switch (section) {
        case "Tutorial":
            StudyCaseHandler.setSingleStudyCaseInformation("tutorialReturnTo", "Initial", true);
            break;

        default :
            break;
        }

        globalInfoBox.setInfoBox("Cargando...");

        loadingImage.opacity = 0.8;

        globalLoader.visible = false;
        globalLoader.setSource("screens/" + redirection + ".qml");
    }
}
