import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtQuick.Dialogs 1.2
import QtWebKit 3.0

import FileIO 1.0

import "../docs"
import "../screens"
import "../"
import "."

Column {

    Rectangle {

        color: Style.color.content_emphasized

        width: parent.width
        height: parent.height - continueButton.height

        GridLayout {

            id: codeLayout

            height: parent.height * 0.95
            width: parent.width * 0.9

            rowSpacing: 0
            columnSpacing: 0

            columns: 2
            rows: 2

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {

                Layout.preferredHeight: textCode.height * 1.5
                Layout.fillWidth: true

                Layout.columnSpan: 2

                color: Style.color.complement

                Text {

                    id: textCode

                    text: qsTr("Script de GNU Octave (sólo lectura)")
                    font.italic: true

                    color: Style.color.background_highlight
                    font.pixelSize: Style.fontSize.h5

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            TextArea {
                id: codeArea

                Layout.columnSpan: 2

                Layout.fillWidth: true
                Layout.fillHeight: true

                textColor: Style.color.background_highlight
                font.family: "Inconsolata"

                backgroundVisible: false
                frameVisible: false

                readOnly: true
                textMargin: 5

                wrapMode: Text.NoWrap

                FileIO {
                    id: io_code
                    source: "scripts/domain.m"
                    onError: console.log(msg)

                    onSourceChanged: {
                        console.log(source);
                        console.log("asd");
                        console.debug("hola");
                    }
                }
//^\s*function.+domain\((.*)\)$
                Component.onCompleted: {
                    codeArea.text = io_code.read();
                }

                Rectangle {
                    height: parent.height
                    width: parent.width

                    color: Style.color.complement_highlight
                    border.color: Style.color.complement
                    z: parent.z - 1
                }
            }

            PrimaryButton {
                buttonLabel: "Editar"
                buttonStatus: "white"
                buttonText.font.pixelSize: height / 2

                Layout.preferredWidth: parent.width / 2


            }

            PrimaryButton {
                buttonLabel: "Abrir"
                buttonStatus: "white"
                buttonText.font.pixelSize: height / 2

                Layout.preferredWidth: parent.width / 2

                onClicked: scriptDialog.open()
            }

        }
    }

    RowLayout {

        spacing: 0
        width: parent.width

        PrimaryButton {
            buttonLabel: "Vista General"
            buttonStatus: "primary"
            buttonText.font.pixelSize: height / 2

            onClicked : mainWindow.switchSection("CE_Overall")

            Layout.fillWidth: true
        }

        PrimaryButton {
            id: continueButton

            buttonLabel: "Guardar y Continuar"
            buttonStatus: "success"
            buttonText.font.pixelSize: height / 2

            Layout.preferredWidth: 0.6 * parent.width
        }
    }

    FileDialog {
        id: scriptDialog
        title: "Por favor seleccione un script de GNU Octave"

        nameFilters: [ "Archivos de GNU Octave (*.m *.octave)", "Todos los archivos (*)" ]

        onAccepted: {
            console.log("You chose: " + scriptDialog.fileUrl)
            io_code.setSource(scriptDialog.fileUrl);

            codeArea.text = io_code.read();
        }
        onRejected: {
            console.log("Canceled")
        }
    }
}
