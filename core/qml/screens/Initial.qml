import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import QtQuick.Dialogs 1.2

import "../"
import "../content"

RowLayout {

    id: parentLayout

    anchors.fill: globalLoader

    ColumnLayout {

        id: columnLayout

        Layout.fillHeight: true
        Layout.fillWidth: true

        Layout.maximumHeight: parent.height * 0.9
        Layout.maximumWidth: (width < 900) ? parent.width * 0.9 : 900

        Layout.alignment: Qt.AlignCenter

        spacing: 0

        RowLayout {

            spacing: 10

            ChoiceBlock {
                header.text: "TUTORIAL"

                textArea.text : qsTr(Content.initial.tutorial);

                button.buttonLabel: "Iniciar"
                button.buttonStatus: "info"
                button.iconSource: "qrc:/resources/icons/book95.png"

                button.onClicked : mainWindow.switchSection("Tutorial")

                image.source: "qrc:/resources/images/femris_tutorial2.png"
            }

            ChoiceBlock {
                header.text: "NUEVO"

                textArea.text : qsTr(Content.initial.initiate);

                button.buttonLabel: "Crear"
                button.buttonStatus: "femris"
                button.iconSource: "qrc:/resources/icons/file27.png"

                button.onClicked : {
                    StudyCaseHandler.start();
                    mainWindow.switchSection("CE_Overall");
                }

                image.source: "qrc:/resources/images/femris_new.png"
            }

            ChoiceBlock {
                header.text: "ABRIR"

                textArea.text : qsTr(Content.initial.load);

                button.buttonLabel: "Cargar"
                button.buttonStatus: "primary"
                button.iconSource: "qrc:/resources/icons/open96.png"

                button.onClicked : Configure.emitMainSignal("femrisLoader.open()")

                image.source: "qrc:/resources/images/femris_load.png"
            }
        }
    }
}
