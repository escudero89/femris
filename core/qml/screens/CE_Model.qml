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

        id: rlModel

        Layout.maximumWidth: globalLoader.width - 2 * spacing - leftContentRectangle.width;
        Layout.maximumHeight: globalLoader.height - 2 * spacing - fbOverall.height;

        Layout.alignment: Qt.AlignCenter;

        spacing: 5

        Repeater {

            id: rModel

            signal anotherOneChosed()

            model: ListModel {
                id: listModelProblem
                ListElement{
                    title: "Transp. de Calor";
                    content: "heat";
                    soCalled: "heat"
                }

                ListElement{ title: "Tensión plana"        ; content: "stress"; soCalled: "plane-stress" }
                ListElement{ title: "Deformación plana"    ; content: "strain"; soCalled: "plane-strain" }
            }

            ChoiceBlock {

                id: cbModel

                Layout.maximumWidth: rlModel.width / listModelProblem.count

                header.text: title
                textArea.text: Content.model[content]

                button.iconSource: "qrc:/resources/icons/keyboard50.png"

                image.visible: false;

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

                Component.onCompleted: {
                    if (StudyCaseHandler.checkSingleStudyCaseInformation("typeOfStudyCase") &&
                        StudyCaseHandler.checkSingleStudyCaseInformation("typeOfStudyCase", soCalled)) {

                        state = "selected";
                    }
                }

            }
        }
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
