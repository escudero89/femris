import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import QtQuick.Dialogs 1.2

import "../"
import "../content"

Item {

    anchors.fill: parent

    PrimaryButton {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 0

        buttonLabel: ""
        buttonStatus: "white"
        iconSource: "qrc:/resources/icons/black/eye50.png"

        width: Math.max(parent.width / 40, 30)

        buttonText.onClicked: mainWindow.switchSection("Initial")
        buttonText.tooltip: qsTr("Ir a Menu Principal")
     }

    RowLayout {

        id: rlOverall
        objectName: "CE_Overall"

        property int stepOnStudyCase : parseInt(StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess"));

        anchors.fill: parent

        anchors.topMargin: parent.width / 40 ; anchors.bottomMargin: parent.width / 40
        anchors.leftMargin: parent.width / 20 ; anchors.rightMargin: parent.width / 20

        spacing: 2

        Repeater {

            id: rChoiceBlock

            model: ListModel {

                id: lmChoiceBlock

                ListElement {
                    stage: "CE_Model"

                    header: "MODELO FÍSICO"
                    imageSource: "model"
                    iconSource: "qrc:/resources/icons/function.png"

                    thisBlockStatus: 1
                }
                ListElement {
                    stage: "CE_Domain"

                    header: "DOMINIO"
                    imageSource: "domain"
                    iconSource: "qrc:/resources/icons/keyboard50.png"

                    thisBlockStatus: 2

                }
                ListElement {
                    stage: "CE_ShapeFunction"

                    header: "FUNC. DE FORMA"
                    imageSource: "shape_function"
                    iconSource: "qrc:/resources/icons/stats1.png"

                    thisBlockStatus: 3
                }
                ListElement {
                    stage: "CE_Results"

                    header: "RESULTADOS"
                    imageSource: "results"
                    iconSource: "qrc:/resources/icons/calculator70.png"

                    thisBlockStatus: 4
                }
            }

            delegate: ChoiceBlock {

                id: mcbThis

                Layout.preferredWidth: ( rlOverall.width - (lmChoiceBlock.count - 1) * rlOverall.spacing ) / lmChoiceBlock.count

                header.text: "MODELO FÍSICO"
                textArea.text: Content.overall[imageSource]

                image.source : "qrc:/resources/images/overall/" + imageSource + ".png"

                button.buttonLabel: "Elegir"
                button.onClicked : mainWindow.switchSection(stage)
                button.iconSource: iconSource

                blockStatus:
                    (rlOverall.stepOnStudyCase > thisBlockStatus) ? "used" :
                    (rlOverall.stepOnStudyCase == thisBlockStatus) ? "default" : "disabled";

            }
        }
    }

}

