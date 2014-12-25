import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

Row {

    id: rowLayout

    property string parentStage : ""

    property int stepOnStudyCase : {
        return parseInt(StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess"));
    }

    MiniChoiceBlock {
        height: width * 1.5
        width: rowLayout.width / 4

        image.source : "qrc:/resources/images/overall/model.png"
        blockStatus : (stepOnStudyCase > 1) ? "used" : "default";

        currentStepName : "Elegir Modelo Físico"
        isCurrent: parentStage === "CE_Model"

        Component.onCompleted: console.log(parentStage)
    }
    MiniChoiceBlock {
        height: width * 1.5
        width: rowLayout.width / 4

        image.source : "qrc:/resources/images/overall/domain.png"
        blockStatus :
            (stepOnStudyCase > 2) ? "used" :
            (stepOnStudyCase == 2) ? "default" : "disabled";

        currentStepName : "Crear Dominio"
        isCurrent: parentStage === "CE_Domain"
    }
    MiniChoiceBlock {
        height: width * 1.5
        width: rowLayout.width / 4

        image.source : "qrc:/resources/images/overall/shape_function.png"
        blockStatus :
            (stepOnStudyCase > 3) ? "used" :
            (stepOnStudyCase == 3) ? "default" : "disabled";

        currentStepName : "Repasar Funciones de Forma"
        isCurrent: parentStage === "CE_ShapeFunction"
    }
    MiniChoiceBlock {
        height: width * 1.5
        width: rowLayout.width / 4

        image.source : "qrc:/resources/images/overall/results.png"
        blockStatus : (stepOnStudyCase == 4) ? "default" : "disabled";

        currentStepName : "Ver Resultados"
        isCurrent: parentStage === "CE_Results"
    }
}
