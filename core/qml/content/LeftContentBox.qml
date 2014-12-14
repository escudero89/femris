import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

import "smallBoxes"

Rectangle {

    id: leftContentBox

    property int stepOfProcess : parseInt(StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess"));

    property string parentStage : parent.objectName

    property bool firstTimeOnly : false

    signal blockHiding(bool isHiding)

    ColumnLayout {

        id: columnLayout1

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        height : parent.height * 0.97
        width : parent.width * 0.9

        spacing: 0

        ModelElectionSBox { visible : { return parentStage === 'CE_Model' } }

        PropertiesAssignationSBox { visible : { return parentStage === 'CE_Domain'; } }

        Rectangle {
            color: "transparent"
            Layout.preferredHeight: columnLayout1.height * 0.02
            Layout.fillWidth: true
        }

        Rectangle {

            id: rectanglePrimeraVezAqui

            Layout.preferredHeight: textPrimeraVezAqui.height * 1.5
            Layout.fillWidth: true

            color: Style.color.complement
            border.color: Style.color.complement

            Text {
                id: textPrimeraVezAqui
                text: qsTr("¿Primera vez aquí?")
                font.italic: true

                color: Style.color.background_highlight
                font.pixelSize: Style.fontSize.h5

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {

            id: textAreaPrimeraVezAqui
            color: Style.color.complement_highlight

            border.color: Style.color.complement

            Layout.fillHeight: true
            Layout.fillWidth: true

            Layout.minimumHeight: textAreaFirstTime.height

            states: [
                State {
                    name: "NORMAL"
                    PropertyChanges { target: textAreaPrimeraVezAqui; visible: true }
                    PropertyChanges { target: hideButton; buttonLabel: "Ocultar" }
                },
                State {
                    name: "OCULTO"
                    PropertyChanges { target: textAreaPrimeraVezAqui; visible: false }
                    PropertyChanges { target: hideButton; buttonLabel: "Mostrar" }
                }
            ]

            TextArea {

                id: textAreaFirstTime

                text : "<p>Li Europan lingues es membres del sam familie. Lor separat existentie es un myth.</p><p> Por <em>scientie, musica, sport etc</em>, litot Europa usa li sam <b>vocabular</b>. Li lingues differe solmen in li grammatica, li pronunciation e li plu commun vocabules. Omnicos directe al desirabilite de un nov lingua franca: On refusa continuar payar custosi traductores. At solmen va esser necessi far uniform grammatica, pronunciation e plu sommun paroles. Ma quande lingues coalesce, li grammatica del resultant lingue es plu simplic e regulari quam ti del coalescent lingues. Li nov lingua franca va esser plu simplic e regulari quam li existent Europan lingues.</p>"
                textColor: Style.color.background

                textFormat: TextEdit.RichText
                backgroundVisible: false
                frameVisible: false

                height: parent.height
                width : parent.width

            }

        }

        PrimaryButton {
            id: hideButton

            buttonLabel: "Ocultar"
            buttonStatus: "black"
            //buttonText.font.pixelSize: height / 2

            Layout.fillWidth: parent.width

            onClicked: {
                if (firstTimeOnly) {
                    blockHiding(textAreaPrimeraVezAqui.state !== 'OCULTO');
                }

                textAreaPrimeraVezAqui.state =
                        (textAreaPrimeraVezAqui.state !== 'OCULTO') ? 'OCULTO' : 'NORMAL';
            }
        }
    }
}
