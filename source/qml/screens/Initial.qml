import QtQuick 2.2
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
                button.onClicked : mainWindow.switchSection("tutorial")
            }

            ChoiceBlock {
                header.text: "NUEVO"

                textArea.text : qsTr(Content.initial.initiate);

                button.buttonLabel: "Crear"
                button.onClicked : {
                    mainWindow.switchSection("CE_Overall");
                }
            }

            ChoiceBlock {
                header.text: "ABRIR"

                textArea.text : qsTr(Content.initial.load);

                button.buttonLabel: "Cargar"
                button.onClicked : {
                    femrisLoader.visible = true;
                    //
                }
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
