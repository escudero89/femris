import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0
import QtWebKit.experimental 1.0

import FileIO 1.0

import "../docs"
import "../content"
import "../"
//text: currentWebView.loadProgress
RowLayout {

    property string currentUrlForTutorial : "";
    property string layoutForTutorial : "";

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
                rowParent.currentUrlForTutorial = url;
                currentWebView.url = url;
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

    Rectangle {

        color: "white"
        //width: rowParent.width - indiceContenido.width
        Layout.fillWidth: true
        Layout.fillHeight: true

        RowLayout {

            height: parent.height
            width: parent.width
            spacing: 0

            WebView {
                id: currentWebView

                Layout.fillWidth: true
                Layout.fillHeight: true

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
                    onError: console.log(msg)
                }

                FileIO {
                    id: io_current
                    source: "docs/current.html"
                    onError: console.log(msg)
                }

                Component.onCompleted: {
                    rowParent.layoutForTutorial = io_layout.read();
                    rowParent.currentUrlForTutorial = "docs/view/femris_inicio_tutorial.html";
                    currentWebView.url = "file://" + applicationDirPath + "/docs/current.html";
                }

                onUrlChanged: {
                    io_view.setSource(rowParent.currentUrlForTutorial);
                    var layout  = rowParent.layoutForTutorial;
                    var view = io_view.read();

                    layout = layout.replace("{{=include(view)}}", view);
                    io_current.write(layout);

                    currentWebView.url = "file://" + applicationDirPath + "/docs/current.html";
                }
            }

            // Attach scrollbars to the right of the view.
            ScrollBar {
                id: currentWebViewScrollBar
                Layout.preferredWidth: 10
                Layout.preferredHeight: currentWebView.height - 12

                opacity: 0.7
                orientation: Qt.Vertical
                position: currentWebView.visibleArea.yPosition
                pageSize: currentWebView.visibleArea.heightRatio
            }
        }
    }
}
