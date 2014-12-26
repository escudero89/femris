import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

//import QtWebEngine 1.0
import QtWebKit 3.0

import "../docs"
import "../content"
import "../content/components"
import "../"


ColumnLayout {

    id: mainItem

    anchors.fill: parent

    spacing: 20

    Rectangle {

        id: chooseYourModel

        Layout.fillWidth: true
        Layout.preferredHeight: parent.height * 0.2

        RowLayout {
            PrimaryButton {

            }
            PrimaryButton {

            }
            PrimaryButton {

            }
        }

    }

    ListView {

        property string parentStage : objectName

        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.9
        Layout.alignment: Qt.AlignCenter

        id: rowParent
        objectName: "CE_Model"

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        spacing: 20

        model: listModelVariablesSBoxStructural

        delegate: Item {

            height: mainItem.height * 0.3
            width: parent.width

            ColumnLayout {

                anchors.fill: parent
                spacing: 0

                Rectangle {
                    color: Style.color.info

                    Layout.preferredHeight: parent.height * 0.2
                    Layout.fillWidth: true

                    RowLayout {

                        anchors.fill: parent

                        Text {
                            text: "<h1>" + math + "<small>" + name + "</small></h1>";

                            textFormat: Text.RichText
                        }
                    }
                }

                Rectangle {
                    color: Style.color.content_emphasized

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    TextArea {
                        anchors.fill: parent

                        text: qsTr(mathInfo)

                        enabled: false

                        backgroundVisible: false
                        frameVisible: false

                        textColor: Style.color.background
                    }
                }

                Rectangle {
                    color: Style.color.complement_highlight

                    Layout.preferredHeight: parent.height * 0.3
                    Layout.fillWidth: true

                    RowLayout {

                        anchors.fill: parent

                        TextField {
                            Layout.alignment: Qt.AlignLeft
                        }

                        PrimaryButton {

                            Layout.alignment: Qt.AlignLeft

                        }

                        Text {
                            Layout.fillWidth: true
                        }

                    }
                }

            }

            Rectangle {
                anchors.fill: parent

                border.color: Style.color.complement
                border.width: 2

                color: "transparent"
            }

        }

        footer: Item {

            height: mainItem.height * 0.15
            width: parent.width

            FooterButtons {
                anchors.fill: parent
            }
        }
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


}

