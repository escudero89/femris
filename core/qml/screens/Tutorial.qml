import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebEngine 1.0

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

        property double originalMaximumWidth : rowParent.width * 0.3

        id: indiceContenido

        Layout.fillHeight: true
        Layout.fillWidth: true

        Layout.maximumWidth: originalMaximumWidth

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
                    Layout.maximumWidth: originalMaximumWidth
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

            property int oldMouseX

            anchors.fill: parent
            hoverEnabled: true

            onContainsMouseChanged: {
                ocultarIndice.color = (containsMouse) ? Style.color.femris : Style.color.complement
                globalInfoBox.setInfoBox((indiceContenido.state === "NORMAL") ?
                                             qsTr("Click para ocultar Índice. Arrastra el mouse para cambiar el tamaño del Índice.") :
                                             qsTr("Click para mostrar Índice"), !containsMouse)
            }

            onPositionChanged: {
                if (pressed && indiceContenido.state === 'NORMAL') {
                    var widthDiff = indiceContenido.width + mouse.x;

                    if (widthDiff > 60 && widthDiff < rowParent.width) {
                        indiceContenido.Layout.maximumWidth = widthDiff;
                        indiceContenido.originalMaximumWidth = widthDiff;
                    }
                }
            }

            onClicked : {
                if (!pressed) {
                    oldMouseX = 0;
                    indiceContenido.state = (indiceContenido.state !== 'OCULTO') ? 'OCULTO' : 'NORMAL';
                }
            }

            Component.onCompleted: oldMouseX = ocultarIndice.x
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
            WebEngineView {

                property string previous_url : ""

                id: currentWebView

                Layout.fillWidth: true
                Layout.fillHeight: true

                visible: false

                /*
                onNavigationRequested: {
                    var url = "" + request.url;
                    if (url.indexOf("http") === 0) {
                        //request.action = WebEngine.IgnoreRequest;
                        globalInfoBox.loadUrlInBrowser(url);
                    }
                }*/

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
                    visible = true;

                    rowParent.layoutForTutorial = io_layout.read();
                    rowParent.currentUrlForTutorial = "docs/view/femris_inicio_tutorial.html";
                    currentWebView.url = fileApplicationDirPath + "/docs/current.html";
                }

                onUrlChanged: {
                    var url_stringed = String(url);

                    if (previous_url === url_stringed) {
                        return;
                    }

                    previous_url = url_stringed;

                    // These are for those that we don't to wrap with the layout
                    if (rowParent.currentUrlForTutorial[0] === '$') {
                        currentWebView.url = fileApplicationDirPath + "/" + rowParent.currentUrlForTutorial.substr(1);

                    // Source that we want to wrap with the layout
                    } else {

                        if (rowParent.currentUrlForTutorial.search("http") !== -1) {
                            rowParent.currentUrlForTutorial = "docs/view/external.html";
                        }

                        var viewPath = fileApplicationDirPath + "/" + rowParent.currentUrlForTutorial;

                        io_view.setSource(viewPath);
                        var layout  = rowParent.layoutForTutorial;
                        var view = io_view.read();

                        layout = layout.replace("{{=include(view)}}", view);
                        io_current.write(layout);

                        currentWebView.url = fileApplicationDirPath + "/docs/current.html";

                        // Direct link to a website
                    }

                    indiceContenido.urlPath = currentWebView.url;
                }
            }

            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.leftMargin: 10

                text: (currentWebView.loading) ? qsTr("Cargando (" + currentWebView.loadProgress + "%)...") : ""
            }

        }

    }
}
