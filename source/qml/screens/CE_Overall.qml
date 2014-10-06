import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import QtQuick.Dialogs 1.2

import "../"
import "../content"

RowLayout {

    id: parentLayout
    objectName: "CE_Overall"

    property int stepOnStudyCase : {
        return parseInt(StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess"));
    }

    anchors.fill: globalLoader

    anchors.topMargin: globalLoader.width / 40 ; anchors.bottomMargin: globalLoader.width / 40
    anchors.leftMargin: globalLoader.width / 20 ; anchors.rightMargin: globalLoader.width / 20

    ColumnLayout {

        id: columnLayout

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Layout.maximumWidth: 1400
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 0

        RowLayout {

            spacing: 2

            ChoiceBlock {
                header.text: "MODELO FÍSICO"

                button.buttonLabel: "Elegir"
                button.onClicked : mainWindow.switchSection("CE_Model")

                blockStatus : (stepOnStudyCase > 1) ? "used" : "default";
            }

            ChoiceBlock {
                header.text: "DOMINIO"

                button.buttonLabel: "Crear"
                button.onClicked : mainWindow.switchSection("CE_Domain")

                blockStatus :
                    (stepOnStudyCase > 2) ? "used" :
                    (stepOnStudyCase == 2) ? "default" : "disabled";
            }

            ChoiceBlock {
                header.text: "PROPIEDADES"

                button.buttonLabel: "Asignar"
                button.onClicked : mainWindow.switchSection("tutorial")

                blockStatus :
                    (stepOnStudyCase > 3) ? "used" :
                    (stepOnStudyCase == 3) ? "default" : "disabled";
            }

            ChoiceBlock {
                header.text: "FUNC. DE FORMA"

                button.buttonLabel: "Fijar"
                button.onClicked : mainWindow.switchSection("tutorial")

                blockStatus :
                    (stepOnStudyCase > 4) ? "used" :
                    (stepOnStudyCase == 4) ? "default" : "disabled";
            }

            ChoiceBlock {
                header.text: "RESULTADOS"

                button.buttonLabel: "Ver"
                button.onClicked : mainWindow.switchSection("tutorial")

                blockStatus : (stepOnStudyCase == 5) ? "default" : "disabled";
            }

        }

    }
}
