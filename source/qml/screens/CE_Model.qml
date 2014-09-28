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
    width: parent.width

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

    Rectangle {
        id: mainContentRectangle
        color: "blue"
        Layout.fillHeight: true
        Layout.preferredWidth: (parent.width - leftContentRectangle.width) * .55

        WebView {
            id: currentWebView

            width: parent.width
            height: parent.height

            url: "qrc:/docs/current.html"
        }

    }

    Rectangle {
        color: Style.color.comment
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width - mainContentRectangle.width - leftContentRectangle.width

        Text {
            text: currentWebView.loadProgress
        }
    }
}
