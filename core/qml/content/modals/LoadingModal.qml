import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

import "../smallBoxes"

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

        MouseArea {
            anchors.fill: parent
        }
    }

    Rectangle {
        id: rectangle1
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        height: parent.height * 0.7
        width: parent.width * 0.7

        color: Style.color.comment

        border.width: 3
        border.color: Style.color.background_highlight

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 1.0; color: "black" }
            }

            opacity: 0.25
            z: parent.z + 1
        }

        ColumnLayout {
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            z: parent.z + 2

            TextArea {
                id: textAreaLoadingModal
                font.family: "Courier"

                Layout.alignment: Qt.AlignCenter

                Layout.fillHeight: true
                Layout.fillWidth: true

                backgroundVisible: false
                textColor: Style.color.background

                Connections {
                    target: ProcessHandler
                    onResultMessage: {
                        textAreaLoadingModal.text += msg;
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    z: parent.z - 1

                    color: Style.color.complement
                    opacity: 0.6

                    Image {
                        anchors.bottomMargin: parent.height * 0.1
                        anchors.topMargin: parent.height * 0.1
                        anchors.fill: parent
                        source: "qrc:/resources/images/square_shadow.png"

                        fillMode: Image.PreserveAspectFit
                        opacity: 0.5
                    }
                }
            }

            ProgressBar {
                id: progressBarModal
                Layout.alignment: Qt.AlignCenter

                Layout.fillWidth: true

                value: 0
                minimumValue: 0
                maximumValue: 100

                style: ProgressBarStyle {
                    background: Rectangle {
                        color: Style.color.background
                        border.color: Style.color.background_highlight
                        border.width: 2
                        implicitWidth: 200
                        implicitHeight: 24
                    }
                    progress: Rectangle {
                        border.color: Style.color.background
                        color: Style.color.primary
                    }

                }

                Behavior on value {
                    NumberAnimation { duration: 500 }
                }
            }

            RowLayout {

                Layout.fillHeight: true
                Layout.preferredWidth: parent.width

                //Layout.maximumWidth: parent.width / 2

                PrimaryButton {
                    id: forceCloseLoadingModal

                    tooltip: qsTr("Forzar el cierre del proceso actual")

                    buttonLabel: ""
                    buttonStatus: "danger"
                    iconSource: "qrc:/resources/icons/ban.png"

                    Layout.preferredWidth: 30
                    Layout.alignment: Qt.AlignLeft

                    enabled: false

                    onClicked: {
                        textAreaLoadingModal.append("##################################################################\n");
                        textAreaLoadingModal.append("Forzando cierre...\n");

                        ProcessHandler.kill();
                        forceCloseLoadingModal.enabled = false;

                        timerMatlabOnWindows.stop();
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: closeLoadingModal.height
                    color: 'transparent'
                }

                PrimaryButton {
                    id: closeLoadingModal

                    tooltip: qsTr("Cerrar ésta ventana")

                    buttonLabel: "Cerrar"
                    buttonStatus: "used"
                    iconSource: "qrc:/resources/icons/cross41.png"

                    Layout.alignment: Qt.AlignRight

                    enabled: false

                    onClicked: {
                        parent.resetModal();
                    }
                }

                PrimaryButton {
                    id: exportStudyCaseLoadingModal

                    tooltip: qsTr("Exportar Caso de Estudio para GiD")

                    buttonLabel: ""
                    buttonStatus: "warning"
                    iconSource: "qrc:/resources/icons/GiD.png"

                    Layout.preferredWidth: 30
                    Layout.alignment: Qt.AlignRight

                    enabled: false

                    onClicked: dialogs.exportAs.open();

                }

                PrimaryButton {
                    id: goToShapeFunctionLoadingModal

                    tooltip: qsTr("Repasar funciones de forma")

                    buttonLabel: ""
                    buttonStatus: "info"
                    iconSource: "qrc:/resources/icons/stats1.png"

                    Layout.preferredWidth: 30
                    Layout.alignment: Qt.AlignRight

                    enabled: false

                    onClicked: {
                        parent.resetModal();
                        mainWindow.saveAndContinue("CE_Domain");
                    }

                }

                PrimaryButton {
                    id: continueLoadingModal

                    tooltip: qsTr("Ver los resultados")

                    buttonLabel: "Resultados"
                    buttonStatus: "success"
                    iconSource: "qrc:/resources/icons/calculator70.png"

                    Layout.alignment: Qt.AlignRight

                    enabled: false

                    onClicked: {
                        parent.resetModal();

                        mainWindow.saveAndContinue("CE_Domain");
                        mainWindow.saveAndContinue("CE_ShapeFunction");
                    }

                }

                function resetModal() {
                    goToShapeFunctionLoadingModal.enabled = false;
                    continueLoadingModal.enabled = false;
                    exportStudyCaseLoadingModal.enabled = false;
                    closeLoadingModal.enabled = false;

                    textAreaLoadingModal.text = "";
                    loadingModal.visible = 0;
                    progressBarModal.value = 0;
                }

            }
        }

    }

    Connections {
        target: ProcessHandler

        onProccessCalled: {
            progressBarModal.value = 0;
            textAreaLoadingModal.text = "";

            loadingModal.visible = 1;
            console.log("Called...");
            progressBarModal.value = Math.floor(Math.random() * 100 % 40) + 10;
            forceCloseLoadingModal.enabled = true;

            var interpreter =
                Configure.read("interpreter") === 'octave' ?
                    'GNU Octave' : Configure.read("interpreter") === 'matlab' ?
                        'MATLAB' : 'undefined';

            textAreaLoadingModal.append("Comenzando la ejecución de MAT-fem. Llamando a " + interpreter + ".\n");
            textAreaLoadingModal.append("------------------------------------------------------------------\n");
        }

        onProcessWrote: {
            console.log("Wrote...");
            progressBarModal.value += Math.floor(Math.random() * 100 % 25) + 25;
        }

        onProcessRead: {
            console.log("Read...");
            progressBarModal.value = 100;
        }

        onProcessFinished: {
            processFinishedSuccessfully();
        }

        onProcessWithError: {
            processFinishedWithErrors();
        }

        onProcessMatlabInWindows: {
            textAreaLoadingModal.append("Al parecer estás ejecutando MATLAB en Windows.\n");
            textAreaLoadingModal.append("Por lo tanto, los resultados de MATfem aparecerán en MATLAB y no aquí.\n\n");
            textAreaLoadingModal.append("Espere por favor, programa en ejecución...\n");

            timerMatlabOnWindows.start();
        }
    }

    function processFinishedSuccessfully() {
        console.log("Finished...");

        progressBarModal.value = 100;
        textAreaLoadingModal.append("------------------------------------------------------------------\n");
        textAreaLoadingModal.append("Ejecución con éxito. Ya puedes proseguir con los resultados.\n");
        textAreaLoadingModal.append("------------------------------------------------------------------");

        forceCloseLoadingModal.enabled = false;

        closeLoadingModal.enabled = true;
        goToShapeFunctionLoadingModal.enabled = true;
        continueLoadingModal.enabled = true;
        exportStudyCaseLoadingModal.enabled = true;
    }

    function processFinishedWithErrors() {
        console.log("Error...");

        progressBarModal.value = 100;
        textAreaLoadingModal.append("##################################################################\n");
        textAreaLoadingModal.append("Hubo un ERROR al ejecutar el proceso. Ejecución finalizada.\n");
        textAreaLoadingModal.append("##################################################################\n");
        closeLoadingModal.enabled = true;
        forceCloseLoadingModal.enabled = false;
    }

    /// MATLAB IN WINDOWS NEEDS THE FOLLOWING COMPONENTS
    Timer {
        property int triedCounter : 0

        id: timerMatlabOnWindows

        interval: 500; running: false; repeat: true
        onTriggered: {
            // If the file exists
            if (CurrentFileIO.setSource(fileApplicationDirPath + "/temp/currentMatFemFile.femris.js")) {
                stop();
                processFinishedSuccessfully();
            }
            triedCounter++;

            // After long time has passed since the execution of MATLAB, we end the timer
            // because there must have been a problem of some sort.
            var secondsToWaitForSuccess = 180;
            var maxTries = Math.round(secondsToWaitForSuccess / (timerMatlabOnWindows.interval / 1000));

            if (triedCounter > maxTries) {
                stop();
                triedCounter = 0;
                processFinishedWithErrors();
            }

        }

    }
}
