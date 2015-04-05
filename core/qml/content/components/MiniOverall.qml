import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

RowLayout {

    signal mouseEntered()
    signal mouseExited()

    property int originalHeight

    property string parentStage : ""
    property int stepOnStudyCase : parseInt(StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess"));

    id: rlMiniOverall

    spacing: 0

    visible: (parentStage !== "") ? true : false

    onStepOnStudyCaseChanged: rMiniChoiceBlock.stepOnStudyCaseChanged()

    onMouseEntered : {
        rlMiniOverall.state = "hovered";
        rMiniChoiceBlock.setInfoBox();
    }

    onMouseExited: {
        rlMiniOverall.state = "normal";
    }

    state: "normal"

    states: [
        State {
            name: "normal"

            PropertyChanges {
                target: rlMiniOverall

                height: originalHeight
                opacity: 0.2
            }
        },
        State {
            name: "hovered"

            PropertyChanges {
                target: rlMiniOverall

                height: originalHeight * 5
                opacity: 1.0
            }
        }
    ]

    Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad; } }
    Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad; } }

    Repeater {

        signal setInfoBox()
        signal stepOnStudyCaseChanged()

        id: rMiniChoiceBlock

        model: ListModel {

            id: lmMiniChoiceBlock

            ListElement {
                stage: "CE_Model"

                stepName: "Elegir Modelo Físico"
                imageSource: "model"

                thisBlockStatus: 1
            }
            ListElement {
                stage: "CE_Domain"

                stepName: "Crear Dominio"
                imageSource: "domain"

                thisBlockStatus: 2

            }
            ListElement {
                stage: "CE_ShapeFunction"

                stepName: "Repasar Funciones de Forma"
                imageSource: "shape_function"

                thisBlockStatus: 3
            }
            ListElement {
                stage: "CE_Results"

                stepName: "Ver Resultados"
                imageSource: "results"

                thisBlockStatus: 4
            }
        }


        delegate: MiniChoiceBlock {

            id: mcbThis

            Layout.preferredHeight: width
            Layout.preferredWidth: rlMiniOverall.width / 4

            image.source : "qrc:/resources/images/overall/" + imageSource + ".png"

            blockStatus:
                (stepOnStudyCase > thisBlockStatus) ? "used" :
                (stepOnStudyCase == thisBlockStatus) ? "default" : "disabled";

            currentStepName : stepName
            isCurrent: parentStage === stage

            Connections {
                target: rMiniChoiceBlock
                onSetInfoBox: {
                    if (isCurrent) {
                        Configure.emitMainSignal("setInfoBox", qsTr("<em>Etapa Actual:</em> ") +  stepName)
                    }
                }
                onStepOnStudyCaseChanged: {
                    /*blockStatus =
                        (stepOnStudyCase > thisBlockStatus) ? "used" :
                        (stepOnStudyCase == thisBlockStatus) ? "default" : "disabled";*/
                }
            }
        }

    }
}
