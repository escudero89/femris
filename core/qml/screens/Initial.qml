import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import QtQuick.Dialogs 1.2

import "../"
import "../content"

RowLayout {

    id: parentLayout

    anchors.fill: globalLoader

    anchors.topMargin: globalLoader.width / 40 ; anchors.bottomMargin: globalLoader.width / 40
    anchors.leftMargin: globalLoader.width / 20 ; anchors.rightMargin: globalLoader.width / 20

    ColumnLayout {

        id: columnLayout

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Layout.maximumWidth: 900
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 0

        RowLayout {

            spacing: 10

            ChoiceBlock {
                header.text: "TUTORIAL"

                textArea.text : qsTr(Content.initial.tutorial);

                button.buttonLabel: "Iniciar"
                button.buttonStatus: "info"
                button.iconSource: "qrc:/resources/icons/book95.png"

                button.onClicked : mainWindow.switchSection("tutorial")

                image.source: "qrc:/resources/images/femris_tutorial2.png"
            }

            ChoiceBlock {
                header.text: "NUEVO"

                textArea.text : qsTr(Content.initial.initiate);

                button.buttonLabel: "Crear"
                button.buttonStatus: "femris"
                button.iconSource: "qrc:/resources/icons/file27.png"

                button.onClicked : mainWindow.switchSection("CE_Overall");

                image.source: "qrc:/resources/images/femris_new.png"
            }

            ChoiceBlock {
                header.text: "ABRIR"

                textArea.text : qsTr(Content.initial.load);

                button.buttonLabel: "Cargar"
                button.buttonStatus: "primary"
                button.iconSource: "qrc:/resources/icons/open96.png"

                button.onClicked : femrisLoader.open();

                image.source: "qrc:/resources/images/femris_load.png"
            }
        }
    }

    FileDialog {
        id: femrisLoader
        title: "Por favor seleccione un archivo de FEMRIS"

        nameFilters: [ "Archivos de FEMRIS (*.femris)", "Todos los archivos (*)" ]

        onAccepted: {
            console.log("You chose: " + femrisLoader.fileUrl);
            mainWindow.switchSection("CE_Overall");
            //CurrentFileIO.setSource(femrisLoader.fileUrl);

            //codeArea.text = CurrentFileIO.read();
        }
        onRejected: {
            console.log("Canceled");
        }
    }
}
