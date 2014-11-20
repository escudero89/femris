import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import "../docs"
import "../screens"
import "../"
import "."

import "smallBoxes"

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

                    buttonLabel: "Matar"
                    buttonStatus: "danger"

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                    Layout.maximumWidth: parent.width / 4

                    enabled: false

                    onClicked: {
                        textAreaLoadingModal.text += "\n\nForzando cierre...";
                        ProcessHandler.kill();
                        textAreaLoadingModal.text += "\nEjecución finalizada (forzada).";
                        forceCloseLoadingModal.enabled = false;
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: closeLoadingModal.height
                    color: 'transparent'
                }

                PrimaryButton {
                    id: closeLoadingModal

                    buttonLabel: "Cerrar"
                    buttonStatus: "used"

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight
                    Layout.maximumWidth: parent.width / 4

                    enabled: false

                    onClicked: {
                        continueLoadingModal.enabled = false;
                        closeLoadingModal.enabled = false;

                        textAreaLoadingModal.text = "";
                        loadingModal.visible = 0;
                        progressBarModal.value = 0;
                    }
                }

                PrimaryButton {
                    id: continueLoadingModal

                    buttonLabel: "Continuar"
                    buttonStatus: "success"

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight
                    Layout.maximumWidth: parent.width / 4

                    enabled: false

                    onClicked: {
                        continueLoadingModal.enabled = false;
                        closeLoadingModal.enabled = false;

                        textAreaLoadingModal.text = "";
                        loadingModal.visible = 0;
                        progressBarModal.value = 0;
                        mainWindow.switchSection(StudyCaseHandler.saveAndContinue("CE_Domain"));
                    }
                }

            }
        }

    }

    Connections {
        target: ProcessHandler

        onProccessCalled: {
            loadingModal.visible = 1;
            console.log("Called...");
            progressBarModal.value = Math.floor(Math.random() * 100 % 40) + 10;
            forceCloseLoadingModal.enabled = true;

            var interpreter =
                    Configure.read("interpreter") === 'octave' ?
                   'GNU Octave' : Configure.read("interpreter") === 'matlab' ?
                   'MATLAB' : 'undefined';

            textAreaLoadingModal.text += "Comenzando la ejecución de MAT-fem. Llamando a " + interpreter + ".\n\n"
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
            console.log("Finished...");
            closeLoadingModal.enabled = true;
            continueLoadingModal.enabled = true;
        }
        onProcessWithError: {
            console.log("Error...");
            textAreaLoadingModal.text += "\n\n\nHubo un ERROR al ejecutar el proceso. Revise sí el binario es correcto."
            closeLoadingModal.enabled = true;
            forceCloseLoadingModal.enabled = false;
        }
    }
}
