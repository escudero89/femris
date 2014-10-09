import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0
import QtWebKit.experimental 1.0

import FileIO 1.0

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
                indiceContenido.state = (indiceContenido.state !== 'OCULTO') ? 'OCULTO' : 'NORMAL';
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

            WebView {
                id: currentWebView

                width: parent.width
                height: parent.height

                objectName: webViewCurrent

                experimental.preferences.webGLEnabled: true
                experimental.preferences.developerExtrasEnabled: true

                // We load the layout and the view, and put the info in the WebView
                FileIO {
                    id: io_layout
                    source: "docs/layout.html"
                    onError: console.log(msg)
                }

                FileIO {
                    id: io_view
                    source: "docs/about.html"
                    onError: console.log(msg)
                }

                FileIO {
                    id: io_current
                    source: "docs/current.html"
                    onError: console.log(msg)

                    onSourceChanged: {
                        //currentWebView.url = "../docs/current.html";
                        // loadHtml(io_current.read());
                        console.debug("asd");
                    }

                }

                Component.onCompleted: {
                    var layout  = io_layout.read();
                    var view  = io_view.read();
                    layout = layout.replace("{{=include(view)}}", view);

                    io_current.write(layout);

                    currentWebView.url = "../docs/current.html";
                }

                onUrlChanged: {
                    console.log("url| " + currentWebView.url);
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
