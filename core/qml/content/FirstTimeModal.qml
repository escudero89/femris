import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

import "../docs"
import "../screens"
import "../"
import "."

import "smallBoxes"

Item {
    id: firstTimeModal
    visible: false

    property bool firstTime : true

    anchors.fill: parent
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0

    z: 1000

    Rectangle {
        anchors.fill: parent
        color: Style.color.complement

        opacity: 0.8

        MouseArea {
            anchors.fill: parent
        }
    }

    Rectangle {
        id: rectangle1
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        height: 400
        width: 600

        color: Style.color.comment

        border.width: 3
        border.color: Style.color.background_highlight

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 1.0; color: "black" }
            }

            opacity: 0.25
            z: parent.z + 1
        }

        Rectangle {
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            opacity: 0.2

            z: parent.z + 2
        }

        ColumnLayout {
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            z: parent.z + 3

            Text {
                text: qsTr("¡Bienvenido a ") + Content.femris + "!"
                font.pointSize: Style.fontSize.h3

                Layout.alignment: Qt.AlignHCenter

                textFormat: Text.RichText

                visible: firstTime
            }

            TextArea {
                text: qsTr(Content.firstTime.welcome)

                Layout.maximumHeight: 120
                Layout.fillWidth: true

                backgroundVisible: false
                frameVisible: false

                readOnly: true

                textFormat: TextEdit.RichText

                visible: firstTime
            }

            ColumnLayout {

                id: columnFirstTime

                Layout.fillHeight: true
                Layout.fillWidth: true

                //--------------------------------------------------------------
                Text {
                    Layout.fillWidth: true
                    Layout.columnSpan: 2

                    text: qsTr("Ubicación del intérprete para la ejecución de MAT-fem:")
                }
                //--------------------------------------------------------------
                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    TextField {
                        id: searchResult
                        Layout.preferredHeight: searchButton.height
                        Layout.fillWidth: true

                        placeholderText: "Ingresa la ubicación de MATLAB o GNU Octave"

                        states: State {
                            name: "danger"
                            PropertyChanges {
                                target: searchResult
                                textColor: Style.color.danger
                            }
                            PropertyChanges {
                                target: tooltipSearchResult
                                visible: true
                            }
                        }

                        onTextChanged: {
                            if (text.length > 0) {
                                radioGroupLayout.enabled = true;
                            } else {
                                radioGroupLayout.enabled = false;
                            }
                        }

                        MyToolTip {
                            id: tooltipSearchResult
                            text: qsTr("¿Seguro que es un archivo válido?")
                            visible: false
                        }
                    }

                    PrimaryButton {
                        id: searchButton
                        Layout.preferredWidth: parent.width / 3

                        buttonLabel: "Buscar"
                        buttonStatus: "white"
                        iconSource: "qrc:/resources/icons/black/search19.png"

                        onClicked: {
                            searchDialog.open();
                        }
                    }

                    FileDialog {
                        id: searchDialog

                        title: qsTr("Selecciona un archivo binario de MATLAB o GNU Octave")

                        onAccepted: {
                            var fullPath = "" + searchDialog.fileUrl;
                            searchResult.text = Configure.getPathWithoutPrefix(fullPath);

                            var filename = fullPath.replace(/^.*[\\\/]/, '');

                            searchResult.state = "";

                            if (filename.search("matlab") !== -1) {
                                radioMatlab.checked = true;
                            } else if (filename.search("octave") !== -1) {
                                radioOctave.checked = true;
                            } else {
                                searchResult.state = "danger";
                                tooltipSearchResult.show();
                            }
                        }
                    }
                }
                //--------------------------------------------------------------
                RowLayout {
                    id: radioGroupLayout

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    enabled: false

                    ExclusiveGroup { id: radioGroup; onCurrentChanged: saveInterpreter.enabled = true; }

                    RadioButton {
                        id: radioMatlab
                        text: "MATLAB"
                        exclusiveGroup: radioGroup
                    }
                    RadioButton {
                        id: radioOctave
                        text: "GNU Octave"
                        exclusiveGroup: radioGroup
                    }
                }
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "transparent"
            }

            RowLayout {

                Layout.fillHeight: true
                Layout.fillWidth: true

                Layout.alignment: Qt.AlignRight

                PrimaryButton {
                    buttonLabel: "Cerrar"
                    iconSource: "qrc:/resources/icons/black/cross41.png"

                    buttonStatus: "white"

                    onClicked: {
                        firstTimeModal.visible = false;
                    }
                }

                PrimaryButton {
                    id: saveInterpreter

                    buttonLabel: "Guardar"
                    iconSource: "qrc:/resources/icons/save8.png"
                    enabled: false

                    onClicked: {
                        firstTimeModal.visible = false;

                        if (radioMatlab.checked) {
                            Configure.write("interpreter", "matlab");
                            Configure.write("matlab", searchResult.text);
                        } else if (radioOctave.checked) {
                            Configure.write("interpreter", "octave");
                            Configure.write("octave", searchResult.text);
                        }

                        Configure.write("firstTime", "true");
                    }
                }
            }
        }
    }
}
