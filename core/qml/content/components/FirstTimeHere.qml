import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

ColumnLayout {

    property string parentStage : ""

    spacing: 0

    Rectangle {

        id: rectanglePrimeraVezAqui

        Layout.preferredHeight: textPrimeraVezAqui.height * 1.5
        Layout.fillWidth: true

        color: Style.color.complement
        border.color: Style.color.complement

        Text {
            id: textPrimeraVezAqui
            text: qsTr("¿Primera vez aquí?")
            font.italic: true

            color: Style.color.background_highlight
            font.pixelSize: Style.fontSize.h5

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Rectangle {

        id: textAreaPrimeraVezAqui
        color: Style.color.complement_highlight

        border.color: Style.color.complement

        Layout.fillHeight: true
        Layout.fillWidth: true

        states: [
            State {
                name: "NORMAL"
                PropertyChanges { target: textAreaPrimeraVezAqui; visible: true }
                PropertyChanges { target: hideButton; buttonLabel: "Ocultar" }
            },
            State {
                name: "OCULTO"
                PropertyChanges { target: textAreaPrimeraVezAqui; visible: false }
                PropertyChanges { target: hideButton; buttonLabel: "Mostrar" }
            }
        ]

        TextArea {

            id: textAreaFirstTime

            text : Content.firstTime[parentStage]
            textColor: Style.color.background

            textFormat: TextEdit.RichText
            backgroundVisible: false
            frameVisible: false

            height: parent.height
            width : parent.width

            readOnly: true
        }

    }

    PrimaryButton {
        id: hideButton

        iconSource: "qrc:/resources/icons/question23.png"

        buttonLabel: "Ayuda Online"
        buttonStatus: "black"

        Layout.fillWidth: parent.width

        onClicked: {
            var url = "https://github.com/escudero89/femris/wiki";

            switch (parentStage) {
            case "CE_Model":
                url = "https://github.com/escudero89/femris/wiki/Modelo-F%C3%ADsico";
                break;
            case "CE_Domain":
                url = "https://github.com/escudero89/femris/wiki/Dominio";
                break;
            }

            globalInfoBox.loadUrlInBrowser(url);
        }
    }

}
