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
            Layout.preferredWidth: variablesList.width

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

            Layout.preferredHeight: parent.height - buttonSaveVariables.height - variablesRectangle.height
            Layout.preferredWidth: parent.width

            delegate: Rectangle {

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

                        inputMethodHints: Qt.ImhFormattedNumbersOnly

                        validator: DoubleValidator { bottom: 0;}
                        focus: true

                        onEditingFinished: {
                            if (variable) {
                                StudyCaseHandler.setSingleStudyCaseInformation(variable, text);
                                console.log(variable);
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
                    variableTemp: 'width'
                }

                ListElement {
                    math: 'Alto'
                    name: 'Alto del dominio'
                    variableTemp: 'height'
                }

                ListElement {
                    math: 'E'
                    name: 'Módulo de Young'
                    variable: 'youngModulus'
                }

                ListElement {
                    math: '𝜈'
                    name: 'Coeficiente de Poisson'
                    variable: 'poissonCoefficient'
                }

                ListElement {
                    math: 'ρ'
                    name: 'Densidad'
                    variable: 'densityOfDomain'
                }

                ListElement {
                    math: 't'
                    name: 'Espesor'
                    variable: 'thickOfDomain'
                }
            }
/*
            Connections {
                target: CurrentFileIO

                onPerformedRead: {
                    var dynamicVariables = getArgsFromScriptFile(content);
                    var dynamicVariablesKeys = Object.keys(dynamicVariables);
                    var k;

                    listModelVariablesSBox.clear();

                    for ( k = 0 ; k < dynamicVariablesKeys.length ; k++ ) {
                        listModelVariablesSBox.append({
                            'title': dynamicVariablesKeys[k],
                            'author' : dynamicVariables[dynamicVariablesKeys[k]]
                        });
                    }
                }
            }*/
        }

        PrimaryButton {
            id: buttonSaveVariables
            Layout.fillWidth: true

            buttonText.font.pixelSize: height / 2
            buttonLabel: qsTr('Cargar desde archivo')

            buttonStatus: 'white'

            onClicked: {
                //StudyCaseHandler.createDomainFromScriptFile(CurrentFileIO.read());
            }
        }
    }
}
