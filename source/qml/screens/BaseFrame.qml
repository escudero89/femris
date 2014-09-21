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

    Rectangle {
        id: indiceContenido
        color: "red"
        Layout.fillHeight: true
        state: "NORMAL"

        Index {
            id: indexContenido

            anchors.fill: parent
            onLoader : {
                currentWebView.url = url
            }
        }

        states: [
            State {
                name: "NORMAL"
                PropertyChanges { target: indiceContenido; Layout.preferredWidth: rowParent.width * .3 - ocultarIndice.width}
            },
            State {
                name: "OCULTO"
                PropertyChanges { target: indiceContenido; Layout.preferredWidth: 0}
            }
        ]

    }

    Rectangle {
        id: ocultarIndice

        Layout.fillHeight: true
        width: 10

        color: Style.color.complement_highlight

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onContainsMouseChanged: {
                ocultarIndice.color = (containsMouse) ? Style.color.complement : Style.color.complement_highlight
                globalInfoBox.setInfoBox((indiceContenido.state === "NORMAL") ? qsTr("Ocultar Índice") : qsTr("Mostrar Índice"), !containsMouse)
            }

            onClicked : {
                if (indiceContenido.state === "NORMAL")
                    indiceContenido.state = "OCULTO"
                else
                    indiceContenido.state = "NORMAL"
            }
        }
    }

    RowLayout {

        width: rowParent.width - indiceContenido.width
        spacing: 0

        Rectangle {
            id: mainContentRectangle
            color: "blue"
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * .55

            Flickable {
                width: parent.width
                height: parent.height

                WebView {
                    id: currentWebView
                    //url:  "file:///media/Cristian/Dropbox/My Campaigns D&D/El Legado/El Legado - shared/web/monstruos.html"
                    url: "qrc:/docs/index.html"
                    width: parent.width
                    height: parent.height
                    smooth: false
                }
            }
        }

        Rectangle {
            color: Style.color.comment
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width - mainContentRectangle.width


            Text {
                text: currentWebView.loadProgress
            }
        }
    }

}
