import QtQuick 2.4
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.3

import "."

Item {

    property alias crashed                   : crashedDialog
    property alias beforeClosing             : beforeClosingDialog
    property alias load                      : femrisLoader
    property alias save                      : femrisSaver
    property alias exportAs                  : femrisExporter
    property alias anotherFileAlreadyOpened  : anotherFileAlreadyOpenedDialog
    property alias anotherFileBeforeLoader   : anotherFileAlreadyOpenedBeforeLoader

    anchors.fill: parent

    MessageDialog {
        id: crashedDialog
        visible: false

        title: qsTr("FEMRIS sufrió un fallo")
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

    }

    MessageDialog {
        id: beforeClosingDialog
        title: qsTr("¿Guardar Caso de Estudio?")
        text: qsTr("Sí no guarda, los cambios efectuados desde el último punto de guardado se perderán para siempre.")

        icon: StandardIcon.Warning
        standardButtons : StandardButton.Save | StandardButton.Cancel | StandardButton.Discard

        onRejected: beforeClosingDialog.close();
        onDiscard: Qt.quit()
        onAccepted: femrisSaverAndExit.open();

        visible: false
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

    MessageDialog {

        property string parentStage : ""

        id: anotherFileAlreadyOpenedDialog
        title: qsTr("Ya hay un Caso de Estudio abierto")
        text: qsTr("Puede guardar los cambios de su Caso de Estudio actual antes de continuar con uno nuevo. Sí no guarda, los cambios efectuados desde el último punto de guardado se perderán para siempre.")

        icon: StandardIcon.Warning
        standardButtons : StandardButton.Save | StandardButton.Cancel | StandardButton.Discard

        onRejected: anotherFileAlreadyOpenedDialog.close();
        onDiscard: {
            // If we are calling from the NEW button (in Initial)
            if (parentStage === "") {
                StudyCaseHandler.start();
                mainWindow.switchSection("CE_Overall");

            // Or in another section
            } else {
                if (parentStage === "CE_Model") {
                    StudyCaseHandler.adoptNewTypeStudyCaseIfNecessary();
                }
                mainWindow.switchSection(StudyCaseHandler.saveAndContinue(parentStage));
            }
        }
        onAccepted: {
            femrisSaver.parentStage = parentStage;
            femrisSaver.open();
            anotherFileAlreadyOpenedDialog.close();
        }

        visible: false
    }

    MessageDialog {

        property string parentStage : ""

        id: anotherFileAlreadyOpenedBeforeLoader
        title: anotherFileAlreadyOpenedDialog.title
        text: anotherFileAlreadyOpenedDialog.text

        icon: StandardIcon.Warning
        standardButtons : StandardButton.Save | StandardButton.Cancel | StandardButton.Discard

        onRejected: anotherFileAlreadyOpenedDialog.close()
        onDiscard: femrisLoader.open()
        onAccepted: femrisSaver.open()

        visible: false
    }

    FileDialog {
        id: femrisLoader
        title: "Por favor seleccione un archivo de FEMRIS"
        folder: Qt.resolvedUrl(Configure.read("lastVisitedPath"))

        property bool markAsSaved : true;

        nameFilters: [ "Archivos de FEMRIS (*.femris *.femris.old)", "Todos los archivos (*)" ]

        onAccepted: {
            StudyCaseHandler.loadStudyCase(femrisLoader.fileUrl);
            mainWindow.switchSection("CE_Overall");

            if (StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess") > 3) {
                ProcessHandler. executeInterpreter(StudyCaseHandler.getSingleStudyCaseInformation("typeOfStudyCase"));
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
        folder: Qt.resolvedUrl(Configure.read("lastVisitedPath"))

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
        property string parentStage : ""

        id: femrisExporter
        title: "Exportar Caso de Estudio como..."
        folder: Qt.resolvedUrl(Configure.read("lastVisitedPath"))

        nameFilters: [ "Archivos de resultados de MATfem (*.m)", "Todos los archivos (*)" ]

        selectExisting: false

        modality: "ApplicationModal"

        onAccepted: {
            console.log("You chose: " + fileUrl);
            var success = StudyCaseHandler.exportCurrentStudyCase(fileUrl);

            if (success) {
                globalInfoBox.setInfoBox(qsTr("Archivo exportado con éxito."));
            } else {
                globalInfoBox.setInfoBox(qsTr("Error al exportar el archivo."));
                return;
            }

            if (parentStage.length) {
                mainWindow.switchSection(StudyCaseHandler.saveAndContinue(parentStage));
            }
        }
        onRejected: {
            console.log("Canceled");
        }
    }

    Dialog {id: dDialog; visible: false; title: { Qt.atob("Um9sRmUgT3JpZ2luYWwgVGVhbSAtIGFpb3JvcyAtIGVzY3VkZXJvODkgLSBmZXJkaW5hbmRvIC0gbGlubm9kIC0gbG9yZGRyYWNvIC0gbWF4b3J6IC0gc2hhbXJpZWwgLSBUaUJpWCE="); }
        contentItem: Rectangle { z: 1000000;color: "#000000";implicitWidth: 800;implicitHeight: 566;Image{fillMode: Image.PreserveAspectFit;source: "qrc:/resources/images/rolfe.txt";anchors.centerIn: parent;anchors.fill: parent;}}}
    Action { shortcut: StandardKey.Underline; onTriggered: if (!StudyCaseHandler.exists() && Math.ceil(Math.random() * 20) === 20) { dDialog.open(); } }
}
