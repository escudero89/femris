import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtQuick.Dialogs 1.2
import QtWebKit 3.0

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

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

                text: qsTr("Script ha utilizar (sólo lectura)")
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

            Component.onCompleted: {
                CurrentFileIO.setSource("temp/domain.m");
                codeArea.text = CurrentFileIO.read();
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


    FileDialog {
        id: scriptDialog
        title: "Por favor seleccione un script de MATLAB"

        nameFilters: [ "Archivos de MATLAB (*.m *.matlab *.octave)", "Todos los archivos (*)" ]

        onAccepted: {
            console.log("You chose: " + scriptDialog.fileUrl)
            CurrentFileIO.setSource(scriptDialog.fileUrl);

            codeArea.text = CurrentFileIO.read();
        }
        onRejected: {
            console.log("Canceled")
        }
    }
}
