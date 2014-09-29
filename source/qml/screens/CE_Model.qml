import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../content"
import "../"

RowLayout {

    id: rowParent

    spacing: 0
    anchors.fill: globalLoader

    Rectangle {
        id: leftContentRectangle

        color: Style.color.content_emphasized
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.20

        ColumnLayout {

            height : parent.height
            width : parent.width

            TableView {

                Layout.preferredHeight: parent.height * 0.3
                Layout.fillWidth: true

                TableViewColumn {
                    role: "title"
                    title: qsTr("Modelo Físico")
                    resizable: false
                }

                model: ListModel {
                   ListElement{ title: "Ecuación de Transporte" ; author: "Gabriel" }
                   ListElement{ title: "Brilliance"    ; author: "Jens" }
                   ListElement{ title: "Outstanding"   ; author: "Frederik" }
                }
            }

            PrimaryButton {
                buttonLabel: "Nuevo Modelo"
                buttonStatus: "white"
                buttonText.font.pixelSize: height / 2
                Layout.fillWidth: true
            }

            Column {
                Layout.fillHeight: true
                Layout.fillWidth: true

                TextArea {
                    text : "If height and width are not explicitly set, Text will attempt to determine how much room is needed and set it accordingly. Unless wrapMode is set, it will always prefer width to height (all text will be placed on a single line).
The elide property can alternatively be used to fit a single line of plain text to a set width.
Note that the <b>Supported HTML Subset </b>is limited. Also, if the text contains HTML img tags that load remote images, the text is reloaded."
                    textColor: Style.color.background

                    textFormat: TextEdit.RichText
                    backgroundVisible: false
                    frameVisible: false

                    height: parent.height - hideButton.height
                    width : parent.width
                }

                PrimaryButton {
                    id: hideButton

                    buttonLabel: "Ocultar"
                    buttonStatus: "info"
                    buttonText.font.pixelSize: height / 2

                    width : parent.width
                }
            }
        }
    }

    Column {
        id: mainContentRectangle
        Layout.fillHeight: true
        Layout.preferredWidth: (parent.width - leftContentRectangle.width) * .55

        WebView {
            id: currentWebView

            width: parent.width
            height: parent.height

            url: "qrc:/docs/current.html"
        }

    }

    Column {
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width - mainContentRectangle.width - leftContentRectangle.width

        Rectangle {

            color: leftContentRectangle.color
            width: parent.width
            height: parent.height - continueButton.height

            ColumnLayout {

                height: parent.height * 0.95
                width: parent.width * 0.9
                spacing: 0

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                WebView {
                    Layout.fillWidth: parent.width
                    Layout.fillHeight: parent.height

                    url: "qrc:/docs/current.html"

                }

                PrimaryButton {
                    buttonLabel: "Ir hasta aqui"
                    buttonStatus: "white"
                    buttonText.font.pixelSize: height / 2

                    Layout.fillWidth: parent.width
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


    }
}
