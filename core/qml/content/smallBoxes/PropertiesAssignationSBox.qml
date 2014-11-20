import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

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

            Layout.minimumHeight: 30 * listModelVariablesSBox.count

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
                    }

                    TextField {
                        id: variablesTextField

                        Layout.preferredWidth: parent.width / 1.5
                        placeholderText: name

                        text: {
                            if (StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess") > 2) {
                                return (variable) ?
                                            StudyCaseHandler.getSingleStudyCaseInformation(variable) :
                                            StudyCaseHandler.getSingleStudyCaseInformation(variableTemp, true)
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

            model: ListModel {
                id: listModelVariablesSBox

                ListElement {
                    math: 'Ancho'
                    name: 'Ancho del dominio'
                    variable: 'gridWidth'
                }

                ListElement {
                    math: 'Alto'
                    name: 'Alto del dominio'
                    variable: 'gridHeight'
                }

                ListElement {
                    math: 'E'
                    name: 'Módulo de Young'
                    variable: 'youngModulus'
                }

                ListElement {
                    math: "ν"
                    name: 'Coeficiente de Poisson'
                    variable: 'poissonCoefficient'
                }

                ListElement {
                    math: "ρ"
                    name: 'Densidad'
                    variable: 'densityOfDomain'
                }

                ListElement {
                    math: 't'
                    name: 'Espesor'
                    variable: 'thickOfDomain'
                }
            }
        }
    }
}
