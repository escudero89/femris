import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

ColumnLayout {

    Layout.alignment: Qt.AlignBottom

    Layout.fillHeight: true
    Layout.fillWidth: true

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

        Layout.preferredHeight: columnLayout1.height * 0.5
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

            text : "If height and width are not explicitly set, Text will attempt to determine how much room is needed and set it accordingly. Unless wrapMode is set, it will always prefer width to height (all text will be placed on a single line).
The elide property can alternatively be used to fit a single line of plain text to a set width.
Note that the <b>Supported HTML Subset </b>is limited. Also, if the text contains HTML img tags that load remote images, the text is reloaded."
            textColor: Style.color.background

            textFormat: TextEdit.RichText
            backgroundVisible: false
            frameVisible: false

            height: parent.height
            width : parent.width

        }

    }

    PrimaryButton {
        id: hideButton

        buttonLabel: "Ocultar"
        buttonStatus: "black"
        buttonText.font.pixelSize: height / 2

        Layout.fillWidth: parent.width

        onClicked: {
            textAreaPrimeraVezAqui.state =
                    (textAreaPrimeraVezAqui.state !== 'OCULTO') ? 'OCULTO' : 'NORMAL';
        }
    }
}
