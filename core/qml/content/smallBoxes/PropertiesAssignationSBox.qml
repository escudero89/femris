import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtQuick.Dialogs 1.2

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

Rectangle {

    id: propertiesAssignationSBox

    Layout.minimumHeight: parent.height / 3

    Layout.fillHeight: true
    Layout.fillWidth: true

    border.color: Style.color.background_highlight

    ColumnLayout {
        height: parent.height
        width: parent.width

        spacing: 0

        Rectangle {

            id: variablesRectangle

            Layout.preferredHeight: textCode.height * 1.5
            Layout.fillWidth: true

            color: Style.color.background_highlight

            Text {
                id: textCode

                text: qsTr("Propiedades")
                font.italic: true

                color: Style.color.complement
                font.pixelSize: Style.fontSize.h5
                font.bold: true

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ListView {

            id: variablesList

            boundsBehavior: Flickable.StopAtBounds

            Layout.minimumHeight: 30 * variablesList.model.count

            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: Rectangle {

                id: delegateVariableList

                anchors.horizontalCenter: parent.horizontalCenter

                width: variablesRectangle.width - 2
                height: variablesTextField.height * 1.2
                color: (index % 2 === 0) ? Style.color.background :  Style.color.background_highlight;

                RowLayout {

                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height
                    width: parent.width * .95

                    spacing: 0

                    Text {
                        Layout.fillWidth: true
                        text: math

                        textFormat: Text.RichText

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: {
                                Configure.emitMainSignal("setInfoBox " + "<em>Info:</em> " + mathInfo);
                            }
                        }
                    }

                    TextField {
                        id: variablesTextField

                        Layout.preferredWidth: parent.width / 1.5
                        placeholderText: name

                        text: {
                            if (variable && StudyCaseHandler.exists()) {
                                var variableGetted = StudyCaseHandler.getSingleStudyCaseInformation(variable);
                                if (variableGetted !== "false") {
                                    return variableGetted;
                                }
                            }

                            return '';
                        }

                        inputMethodHints: Qt.ImhFormattedNumbersOnly

                        validator: DoubleValidator { bottom: 0;}
                        focus: true

                        onEditingFinished: {
                            if (variable) {
                                StudyCaseHandler.setSingleStudyCaseInformation(variable, text);
                            } else {
                                StudyCaseHandler.setSingleStudyCaseInformation(variableTemp, text, true);
                            }
                        }
                    }
                }
            }

            clip: true

            z: variablesRectangle.z - 1

            model: StudyCaseHandler.checkSingleStudyCaseInformation("typeOfStudyCase") && StudyCaseHandler.getSingleStudyCaseInformation("typeOfStudyCase") === 'heat' ?
                listModelVariablesSBoxHeat : listModelVariablesSBoxStructural
        }

        ListModel {
            id: listModelVariablesSBoxStructural

            ListElement {
                math: 'Ancho'
                mathInfo: 'El dominio será escalado a este ancho'
                name: 'Ancho del dominio'
                variable: 'gridWidth'
            }

            ListElement {
                math: 'Alto'
                mathInfo: 'El dominio será escalado a este alto'
                name: 'Alto del dominio'
                variable: 'gridHeight'
            }

            ListElement {
                math: 'E'
                mathInfo: 'Caracteriza el comportamiento elástico del material'
                name: 'Módulo de Young'
                variable: 'youngModulus'
            }

            ListElement {
                math: "&nu;"
                mathInfo: 'El valor del Coeficiente de Poisson debe ser mayor o igual que 0, pero menor a 0.5'
                name: 'Coeficiente de Poisson'
                variable: 'poissonCoefficient'
            }

            ListElement {
                math: "&rho;"
                mathInfo: "Densidad del dominio"
                name: 'Densidad'
                variable: 'densityOfDomain'
            }

            ListElement {
                math: 't'
                mathInfo: "Espesor del dominio"
                name: 'Espesor'
                variable: 'thickOfDomain'
            }
        }

        ListModel {
            id: listModelVariablesSBoxHeat

            ListElement {
                math: 'Ancho'
                mathInfo: 'El dominio será escalado a este ancho'
                name: 'Ancho del dominio'
                variable: 'gridWidth'
            }

            ListElement {
                math: 'Alto'
                mathInfo: 'El dominio será escalado a este alto'
                name: 'Alto del dominio'
                variable: 'gridHeight'
            }

            ListElement {
                math: 'k<sub>x</sub>'
                mathInfo: 'Caracteriza el comportamiento elástico del material'
                name: 'Módulo de Young'
                variable: 'kx'
            }

            ListElement {
                math: "k<sub>y</sub>"
                mathInfo: 'El valor del Coeficiente de Poisson debe ser mayor o igual que 0, pero menor a 0.5'
                name: 'Coeficiente de Poisson'
                variable: 'ky'
            }

            ListElement {
                math: "heat"
                mathInfo: "Densidad del dominio"
                name: 'Densidad'
                variable: 'heat'
            }
        }
    }
}
