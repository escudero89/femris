import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebKit 3.0

import "smallBoxes"
import "../docs"
import "../screens"
import "../"
import "."

Column {

    property string parentStage : parent.objectName

    TutorialSBox {
        visible: parentStage === 'CE_Model'
    }

    CodeSBox {
        visible: parentStage === 'CE_Domain'
    }

    RowLayout {

        spacing: 0
        width: parent.width

        PrimaryButton {
            buttonLabel: "Vista General"
            buttonStatus: "primary"
            //buttonText.font.pixelSize: height / 2

            onClicked : mainWindow.switchSection("CE_Overall")

            Layout.fillWidth: true
        }

        PrimaryButton {
            id: continueButton

            buttonLabel: "Guardar y Continuar"
            buttonStatus: "disabled"
            //buttonText.font.pixelSize: height / 2

            Layout.preferredWidth: 0.6 * parent.width

            Connections {
                target: StudyCaseHandler

                onNewStudyCaseChose: {
                    continueButton.buttonStatus = "success";
                }
            }

            onClicked: {
                StudyCaseHandler.createNewStudyCase();
                mainWindow.switchSection(StudyCaseHandler.saveAndContinue(parentStage));
            }
        }
    }
}
