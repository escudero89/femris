import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "smallBoxes"
import "../docs"
import "../screens"
import "../"
import "."

Column {

    property string parentStage : parent.objectName

    //CodeSBox { }
    TutorialSBox { }

    RowLayout {

        spacing: 0
        width: parent.width

        PrimaryButton {
            buttonLabel: "Vista General"
            buttonStatus: "primary"
            buttonText.font.pixelSize: height / 2

            onClicked : mainWindow.switchSection("CE_Overall")

            Layout.fillWidth: true
        }

        PrimaryButton {
            id: continueButton

            buttonLabel: "Guardar y Continuar"
            buttonStatus: "success"
            buttonText.font.pixelSize: height / 2

            Layout.preferredWidth: 0.6 * parent.width

            onClicked: {
                mainWindow.switchSection(StudyCaseHandler.saveAndContinue(parentStage));
            }
        }
    }
}
