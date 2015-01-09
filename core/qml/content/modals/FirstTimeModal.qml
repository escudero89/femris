import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

import "../smallBoxes"

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

    function open() {
        firstTimeModal.visible = true;
    }

    function close() {
        firstTimeModal.visible = false;
    }

    Rectangle {
        anchors.fill: parent
        color: Style.color.complement

        opacity: 0.8

        MouseArea {
            anchors.fill: parent
            onClicked: firstTimeModal.close()
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

        MouseArea {
            // This prevent the previous mouse area to exit the modal
            anchors.fill: parent
        }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Style.color.background_highlight }
                GradientStop { position: 1.0; color: Style.color.comment }
            }

            opacity: 0.25
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
        }

        Rectangle {
            id: headerAlertModal

            anchors.right: parent.right
            anchors.rightMargin: 3
            anchors.left: parent.left
            anchors.leftMargin: 3
            anchors.top: parent.top
            anchors.topMargin: 3

            height: textAlertModal.height * 2

            color: Style.color.femris

            opacity: 0.8
        }

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: headerAlertModal.top
            anchors.topMargin: textAlertModal.height

            height: textAlertModal.height
            opacity: 0.1
        }

        ColumnLayout {
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            spacing: 20

            Rectangle {

                Layout.fillWidth: true
                Layout.preferredHeight: headerAlertModal.height - 20
                Layout.alignment: Qt.AlignCenter
                color: "transparent"

                Text {
                    id: textAlertModal

                    text: {
                        if (firstTime) {
                            return qsTr("¡Bienvenido a <strong>FEMRIS</strong>!");
                        } else {
                            return qsTr("Preferencias");
                        }
                    }

                    font.pointSize: Style.fontSize.h4

                    textFormat: Text.RichText
                    horizontalAlignment: Text.AlignHCenter

                    width: parent.width

                    color: Style.color.background
                }

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
                        text: (Configure.read("interpreterPath") !== "null") ? Configure.read("interpreterPath") : ""

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

                        checked: ( Configure.read("interpreter") === "matlab" )
                    }
                    RadioButton {
                        id: radioOctave
                        text: "GNU Octave"
                        exclusiveGroup: radioGroup

                        checked: ( Configure.read("interpreter") === "octave" )
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
                        } else if (radioOctave.checked) {
                            Configure.write("interpreter", "octave");
                        }

                        Configure.write("interpreterPath", searchResult.text);
                        Configure.write("firstTime", "true");
                    }
                }
            }
        }
    }
}
