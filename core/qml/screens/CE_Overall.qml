import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import QtQuick.Dialogs 1.2

import "../"
import "../content"

RowLayout {

    id: parentLayout
    objectName: "CE_Overall"

    property int stepOnStudyCase : {
        console.log(StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess"));
        return parseInt(StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess"));
    }

    anchors.fill: globalLoader

    anchors.topMargin: globalLoader.width / 40 ; anchors.bottomMargin: globalLoader.width / 40
    anchors.leftMargin: globalLoader.width / 20 ; anchors.rightMargin: globalLoader.width / 20

    RowLayout {

        Layout.maximumWidth: 1400

        spacing: 2

        ChoiceBlock {
            header.text: "MODELO FÍSICO"
            textArea.text: Content.overall.model

            image.source : "qrc:/resources/images/overall/model.png"

            button.buttonLabel: "Elegir"
            button.onClicked : mainWindow.switchSection("CE_Model")
            button.iconSource: "qrc:/resources/icons/function.png"

            blockStatus : (stepOnStudyCase > 1) ? "used" : "default";
        }

        ChoiceBlock {
            header.text: "DOMINIO"
            textArea.text: Content.overall.domain

            image.source : "qrc:/resources/images/overall/domain.png"

            button.buttonLabel: "Crear"
            button.onClicked : mainWindow.switchSection("CE_Domain")
            button.iconSource: "qrc:/resources/icons/keyboard50.png"

            blockStatus :
                (stepOnStudyCase > 2) ? "used" :
                                        (stepOnStudyCase == 2) ? "default" : "disabled";
        }

        ChoiceBlock {
            header.text: "FUNC. DE FORMA"
            textArea.text: Content.overall.shape_functions

            image.source : "qrc:/resources/images/overall/shape_function.png"

            button.buttonLabel: "Repasar"
            button.onClicked : mainWindow.switchSection("CE_ShapeFunction")
            button.iconSource: "qrc:/resources/icons/stats1.png"

            blockStatus :
                (stepOnStudyCase > 3) ? "used" :
                                        (stepOnStudyCase == 3) ? "default" : "disabled";
        }

        ChoiceBlock {
            header.text: "RESULTADOS"
            textArea.text: Content.overall.results

            image.source : "qrc:/resources/images/overall/results.png"

            button.buttonLabel: "Ver"
            button.onClicked : mainWindow.switchSection("CE_Results")
            button.iconSource: "qrc:/resources/icons/calculator70.png"

            blockStatus : (stepOnStudyCase == 4) ? "default" : "disabled";
        }
    }
}
