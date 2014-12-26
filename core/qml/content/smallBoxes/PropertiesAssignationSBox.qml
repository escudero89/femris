import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

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

    border.color: Style.color.complement
    color: Style.color.complement_highlight

    ColumnLayout {
        height: parent.height
        width: parent.width

        spacing: 0

        Rectangle {

            id: variablesRectangle

            Layout.preferredHeight: textCode.height * 1.4
            Layout.fillWidth: true

            color: Style.color.complement

            Text {
                id: textCode

                text: qsTr("Propiedades")

                font.pixelSize: Style.fontSize.h5
                font.italic: true
                font.bold: true
                color: Style.color.background

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
                color: (index % 2 === 0) ? Style.color.complement :  Style.color.complement_highlight;

                RowLayout {

                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height
                    width: parent.width * .95

                    spacing: 0

                    Text {
                        Layout.fillWidth: true
                        text: math

                        textFormat: Text.RichText
                        color: Style.color.background

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: {
                                Configure.emitMainSignal("setInfoBox", "<em>Info:</em> " + mathInfo);
                            }
                        }
                    }

                    TextField {
                        property bool isReady : false

                        id: variablesTextField

                        Layout.preferredWidth: parent.width / 1.5
                        placeholderText: name

                        text: {
                            if (!variable || !StudyCaseHandler.exists()) {
                                return '';
                            }

                            var variableGetted = StudyCaseHandler.getSingleStudyCaseInformation(variable);
                            if (variableGetted === "false") {
                                variableGetted = '';
                            } else {
                                isReady = true;
                            }

                            return variableGetted;
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

                            isReady = true;
                        }

                        onTextChanged: isReady = false;

                        onFocusChanged: {
                            if (!variablesTextField.text && propertiesAssignationSBox.visible) {
                                editingFinished();
                                textChanged();
                            }
                        }

                        style: TextFieldStyle {
                            textColor: Style.color.background_highlight
                            placeholderTextColor: Style.color.comment_emphasized
                            background: Rectangle {
                                radius: 2
                                implicitWidth: 100
                                implicitHeight: 24
                                border.color: (variablesTextField.isReady) ? Style.color.success : Style.color.content
                                border.width: 1

                                color: "black"//Style.color.complement
                            }
                        }

                        Component.onCompleted: {
                            if (text.length) {
                                isReady = true;
                            }
                        }
                    }
                }
            }

            clip: true

            z: variablesRectangle.z - 1

            model: StudyCaseHandler.isStudyType("heat") ?
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
                mathInfo: 'Coeficiente difusivo aplicado sobre el eje-x'
                name: 'Coeficiente de difusividad'
                variable: 'kx'
            }

            ListElement {
                math: "k<sub>y</sub>"
                mathInfo: 'Coeficiente difusivo aplicado sobre el eje-y'
                name: 'Coeficiente de difusividad'
                variable: 'ky'
            }

            ListElement {
                math: "Q"
                mathInfo: "Aporte de calor distribuído uniformemente por todo el dominio"
                name: 'Calor distribuído'
                variable: 'heat'
            }
        }
    }
}
