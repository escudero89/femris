import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebEngine 1.0

import "../docs"
import "../content"
import "../content/modals"
import "../"

import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import QtQuick.Dialogs 1.2

import "../"
import "../content"
import "../content/components"

GridLayout {

    id: parentLayout
    objectName: "CE_Model"

    anchors.fill: globalLoader

    columns: 2
    rows: 2

    columnSpacing: 0
    rowSpacing: 0

    LeftContentBox {
        id: leftContentRectangle

        color: Style.color.content_emphasized
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.20

        parentStage : "CE_Model"


        Layout.rowSpan: 2
    }

    RowLayout {

        Layout.maximumWidth: {
            var scaledWidth = globalLoader.width - globalLoader.width / 20 - leftContentRectangle.width;
            return Math.min(900, scaledWidth);
        }

        Layout.maximumHeight: globalLoader.height - globalLoader.height / 20 - fbOverall.height;

        Layout.alignment: Qt.AlignCenter;

        spacing: 2

        Repeater {

            id: rModel

            signal anotherOneChosed()

            model: ListModel {
                id: listModelProblem
                ListElement{
                    title: "Transp. de Calor";
                    content: "model";
                    soCalled: "heat"
                }

                ListElement{ title: "Tensión plana"        ; content: "domain"; soCalled: "plane-stress" }
                ListElement{ title: "Deformación plana"    ; content: "shape_functions"; soCalled: "plane-strain" }
            }

            ChoiceBlock {

                id: cbModel

                header.text: title
                textArea.text: Content.overall[content]

                image.source : "qrc:/resources/images/overall/domain.png"

                button.iconSource: "qrc:/resources/icons/keyboard50.png"

                button.onClicked : {
                    rModel.anotherOneChosed();
                    state = "selected";
                    StudyCaseHandler.selectNewTypeStudyCase(soCalled);
                }

                state: "default"
                states: [
                    State {
                        name: "default"

                        PropertyChanges {
                            target: cbModel
                            button.buttonLabel: "Elegir"
                            button.buttonStatus: "info";
                        }
                    },
                    State {
                        name: "selected"

                        PropertyChanges {
                            target: cbModel
                            button.buttonLabel: "Elegido"
                            button.buttonStatus: "femris";
                        }

                    }
                ]

                Connections {
                    target: rModel

                    onAnotherOneChosed: state = "default";
                }

            }
        }
/*
        ChoiceBlock {
            header.text: "CALOR"
            textArea.text: Content.overall.model

            image.source : "qrc:/resources/images/overall/model.png"

            button.buttonLabel: "Elegir"
            button.onClicked : {
                StudyCaseHandler.selectNewTypeStudyCase("heat");
                button.buttonStatus =  "femris";
            }
            button.iconSource: "qrc:/resources/icons/function.png"

        }

        ChoiceBlock {
            header.text: "TENSIÓN"
            textArea.text: Content.overall.domain

            image.source : "qrc:/resources/images/overall/domain.png"

            button.buttonLabel: "Elegir"
            button.onClicked : mainWindow.switchSection("CE_Domain")
            button.iconSource: "qrc:/resources/icons/keyboard50.png"

        }

        ChoiceBlock {
            header.text: "DEFORMACIÓN"
            textArea.text: Content.overall.shape_functions

            image.source : "qrc:/resources/images/overall/shape_function.png"

            button.buttonLabel: "Elegir"
            button.onClicked : mainWindow.switchSection("CE_ShapeFunction")
            button.iconSource: "qrc:/resources/icons/stats1.png"

        }
*/
    }

    FooterButtons {
        id: fbOverall
        fromWhere: parentLayout.objectName

        enableContinue: false

        Connections {
            target: StudyCaseHandler

            onNewStudyCaseChose: {
                fbOverall.enableContinue = true;
            }
        }
    }
}


/*
RowLayout {

    property string parentStage : objectName

    id: rowParent
    objectName: "CE_Model"

    spacing: 0

    LeftContentBox {
        id: leftContentRectangle

        color: Style.color.content_emphasized
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.20

        parentStage : "CE_Model"
    }

    GridLayout {

        Layout.fillHeight: true
        Layout.fillWidth: true

        columnSpacing: 0
        rowSpacing: 0

        rows: 2
        columns: 3

        Item {

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 3


            WebEngineView {

                signal newUrlBase(string newUrl)
                property string urlBase : "docs/ce_model/index.html"

                id: modelWebView
                visible: false

                anchors.fill: parent

                url: fileApplicationDirPath + "/" + urlBase

                onNewUrlBase: {
                    urlBase = newUrl;
                    url = fileApplicationDirPath + "/" + urlBase;
                }

                onLoadingChanged: visible = (!loading && loadProgress === 100) ? true : false;

            }

            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.bottomMargin: 10

                text: (modelWebView.loading) ? qsTr("Cargando (" + modelWebView.loadProgress + "%)...") : ""
                color:  Style.color.background;
            }

        }

        PrimaryButton {

            tooltip: qsTr("Abrir esta página en tu navegador por defecto")

            buttonStatus: "femris"
            buttonLabel: ""
            iconSource: "qrc:/resources/icons/external2.png"

            onClicked: globalInfoBox.loadUrlInBrowser(modelWebView.urlBase, true);

        }

        PrimaryButton {
            buttonLabel: "Vista General"
            buttonStatus: "primary"
            iconSource: "qrc:/resources/icons/four29.png"

            onClicked : mainWindow.switchSection("CE_Overall")

            Layout.fillWidth: true
        }

        PrimaryButton {

            signal continueStep();

            id: continueButton

            buttonLabel: "Guardar y Continuar"
            buttonStatus: "disabled"
            iconSource: "qrc:/resources/icons/save8.png"

            Layout.fillWidth: true

            Connections {
                target: StudyCaseHandler

                onNewStudyCaseChose: {
                    modelWebView.newUrlBase("docs/ce_model/" + studyCaseType + ".html");
                    continueButton.buttonStatus = "success";
                }
            }

            Connections {
                target: Configure

                onMainSignalEmitted: {
                    if (signalName === "continueStep()") {
                        continueButton.continueStep();
                    }
                }
            }

            onClicked: continueStep();

            onContinueStep: {
                mainWindow.saveAndContinue(parentStage);
            }
        }
    }
}
*/
