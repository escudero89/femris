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

    Layout.minimumHeight: parent.height * 0.2

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

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        Configure.emitMainSignal("setInfoBox", "<em>Info:</em> " + mathInfo);

                        (unit) ? tooltTipText.show() : false;
                    }
                }

                RowLayout {

                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height
                    width: parent.width * .95

                    spacing: 0

                    Item {

                        Layout.preferredHeight: parent.height
                        Layout.fillWidth: true

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: math

                            textFormat: Text.RichText
                            color: Style.color.background
                        }

                        MyToolTip {
                            id: tooltTipText
                            text: (unit) ? unit : "";

                            anchors.fill: parent
                            autoHideDelay: 2000
                        }
                    }

                    TextField {
                        property bool isReady : false
                        property bool hasError : false

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

                        validator: RegExpValidator { regExp: /[+\-]?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?/ }

                        focus: true

                        onEditingFinished: {
                            if (variable) {
                                StudyCaseHandler.setSingleStudyCaseInformation(variable, text);
                            } else {
                                StudyCaseHandler.setSingleStudyCaseInformation(variableTemp, text, true);
                            }

                            var data = text * 1.0;

                            // If there is a minvalue, we check for it. Same with maxValue
                            if ( StudyCaseHandler.checkRule(variable, text) ) {
                                isReady = true;
                                hasError = false;

                            } else {
                                isReady = false;
                                hasError = true;

                                Configure.emitMainSignal(
                                            "setInfoBox",
                                            "<span style='color:" + Style.color.danger + "'>" +
                                            "<strong>" + math + " invalido:</strong> " +
                                            StudyCaseHandler.getRuleMessage(variable, text) + ".");
                            }

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
                                border.color: {
                                    if (variablesTextField.hasError) {
                                        return Style.color.danger;
                                    }
                                    return (variablesTextField.isReady) ? Style.color.success : Style.color.content
                                }
                                border.width: 1

                                color: Style.color.complement
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

            Component.onCompleted: model = StudyCaseHandler.isStudyType("heat") ?
                                       listModelVariablesSBoxHeat :
                                       listModelVariablesSBoxStructural;

        }

        ListModel {
            id: listModelVariablesSBoxStructural

            ListElement {
                math: 'Ancho'
                mathInfo: 'El dominio será escalado a este ancho'
                name: 'Ancho del dominio'
                variable: 'gridWidth'
                unit: "[m]"
            }

            ListElement {
                math: 'Alto'
                mathInfo: 'El dominio será escalado a este alto'
                name: 'Alto del dominio'
                variable: 'gridHeight'
                unit: "[m]"
            }

            ListElement {
                math: 'E'
                mathInfo: 'Caracteriza el comportamiento elástico del material'
                name: 'Módulo de Young'
                variable: 'youngModulus'
                unit: "[Pa]"
            }

            ListElement {
                math: "&nu;"
                mathInfo: 'El valor del Coeficiente de Poisson debe ser mayor o igual que 0, pero menor a 0.5'
                name: 'Coeficiente de Poisson'
                variable: 'poissonCoefficient'
                unit: "[&middot;]"
            }

            ListElement {
                math: "&rho;"
                mathInfo: "Densidad del dominio"
                name: 'Densidad'
                variable: 'densityOfDomain'
                unit: "[Kg/m<sup>3</sup>]"
            }

            ListElement {
                math: 't'
                mathInfo: "Espesor del dominio"
                name: 'Espesor'
                variable: 'thickOfDomain'
                unit: "[m]"
            }
        }

        ListModel {
            id: listModelVariablesSBoxHeat

            ListElement {
                math: 'Ancho'
                mathInfo: 'El dominio será escalado a este ancho'
                name: 'Ancho del dominio'
                variable: 'gridWidth'
                unit: "[m]"
            }

            ListElement {
                math: 'Alto'
                mathInfo: 'El dominio será escalado a este alto'
                name: 'Alto del dominio'
                variable: 'gridHeight'
                unit: "[m]"
            }

            ListElement {
                math: 'k<sub>x</sub>'
                mathInfo: 'Coeficiente difusivo aplicado sobre el eje-x'
                name: 'Coeficiente de difusividad'
                variable: 'kx'
                unit: "[W/ºC]"
            }

            ListElement {
                math: "k<sub>y</sub>"
                mathInfo: 'Coeficiente difusivo aplicado sobre el eje-y'
                name: 'Coeficiente de difusividad'
                variable: 'ky'
                unit: "[W/ºC]"
            }

            ListElement {
                math: "Q"
                mathInfo: "Aporte de calor distribuído uniformemente por todo el dominio"
                name: 'Calor distribuído'
                variable: 'heat'
                unit: "[W/m<sup>2</sup>]"
            }
        }
    }
}
