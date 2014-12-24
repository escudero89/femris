import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

//import QtWebEngine 1.0
import QtWebKit 3.0

import FileIO 1.0

import "../docs"
import "../content"
import "../"

RowLayout {

    property string currentUrlForTutorial : "";
    property string layoutForTutorial : "";

    id: rowParent

    spacing: 0

    Index {
        id: indiceContenido

        Layout.fillHeight: true
        Layout.fillWidth: true

        Layout.maximumWidth: rowParent.width * 0.3

        state: "NORMAL"

        onLoader : {
            rowParent.currentUrlForTutorial = url;
            currentWebView.url = url;
        }

        states: [
            State {
                name: "NORMAL"
                PropertyChanges {
                    target: indiceContenido;
                    Layout.maximumWidth: rowParent.width * 0.3
                }
            },
            State {
                name: "OCULTO"
                PropertyChanges {
                    target: indiceContenido;
                    Layout.maximumWidth: 0
                }
            }
        ]
    }

    Rectangle {
        id: ocultarIndice

        Layout.fillHeight: true
        width: 10
        opacity: 0.7

        color: Style.color.complement

        Image {
            source: "qrc:/resources/icons/caret4.png"
            height: 20

            mirror: (indiceContenido.state !== "NORMAL")
            smooth: true
            opacity: 0.5

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onContainsMouseChanged: {
                ocultarIndice.color = (containsMouse) ? Style.color.femris : Style.color.complement
                globalInfoBox.setInfoBox((indiceContenido.state === "NORMAL") ? qsTr("Ocultar Índice") : qsTr("Mostrar Índice"), !containsMouse)
            }

            onClicked : {
                indiceContenido.state = (indiceContenido.state !== 'OCULTO') ? 'OCULTO' : 'NORMAL';
            }
        }
    }
    Rectangle {

        color: Style.color.background
        //width: rowParent.width - indiceContenido.width
        Layout.fillWidth: true
        Layout.fillHeight: true

        RowLayout {

            height: parent.height
            width: parent.width
            spacing: 0
            //WebEngineView {
            WebView {

                property string previous_url : ""

                id: currentWebView

                Layout.fillWidth: true
                Layout.fillHeight: true

                // We load the layout and the view, and put the info in the WebView
                FileIO {
                    id: io_layout
                    source: fileApplicationDirPath + "/docs/layout.html"
                    onError: console.log(msg)
                }

                FileIO {
                    id: io_view
                    onError: console.log(msg)
                }

                FileIO {
                    id: io_current
                    source: fileApplicationDirPath + "/docs/current.html"
                    onError: console.log(msg)
                }

                Component.onCompleted: {
                    rowParent.layoutForTutorial = io_layout.read();
                    rowParent.currentUrlForTutorial = "docs/view/femris_inicio_tutorial.html";
                    currentWebView.url = fileApplicationDirPath + "/docs/current.html";
                }

                onUrlChanged: {
                    var url_stringed = String(url);

                    if (previous_url === url_stringed) {
                        return;
                    } else {
                        previous_url = url_stringed;
                    }

                    // These are for those that we don't to wrap with the layout
                    if (rowParent.currentUrlForTutorial[0] === '$') {
                        currentWebView.url = fileApplicationDirPath + "/" + rowParent.currentUrlForTutorial.substr(1);

                        // Source that we want to wrap with the layout
                    } else if (rowParent.currentUrlForTutorial.search("http") === -1) {

                        var viewPath = fileApplicationDirPath + "/" + rowParent.currentUrlForTutorial;

                        io_view.setSource(viewPath);
                        var layout  = rowParent.layoutForTutorial;
                        var view = io_view.read();

                        layout = layout.replace("{{=include(view)}}", view);
                        io_current.write(layout);

                        currentWebView.url = fileApplicationDirPath + "/docs/current.html";

                        // Direct link to a website
                    } else {
                        currentWebView.url = rowParent.currentUrlForTutorial;
                    }
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
