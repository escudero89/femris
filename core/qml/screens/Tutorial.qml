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

    onCurrentUrlForTutorialChanged: currentWebView.changeContent()

    Index {

        property double originalMaximumWidth : rowParent.width * 0.3

        id: indiceContenido

        Layout.fillHeight: true
        Layout.fillWidth: true

        Layout.maximumWidth: originalMaximumWidth

        state: "NORMAL"

        onLoader : rowParent.currentUrlForTutorial = url;

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

        Layout.fillWidth: true
        Layout.fillHeight: true

        WebEngineView {

            signal changeContent()

            property string previous_url : ""

            id: currentWebView

            anchors.fill: parent

            visible: false

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

            Component.onCompleted: rowParent.layoutForTutorial = io_layout.read();

            onLoadingChanged: visible = !loading

            onChangeContent: updateCurrentHtml();

            onUrlChanged: indiceContenido.urlPath = url;

            function updateCurrentHtml() {

                // These are for those that we don't to wrap with the layout
                if (rowParent.currentUrlForTutorial[0] === '$') {
                    currentWebView.url = fileApplicationDirPath + "/" + rowParent.currentUrlForTutorial.substr(1);
                    console.log("shapeshapeshape");
                    return;
                }

                // Source that we want to wrap with the layout

                // For external pages, let's load them directly in the browser of the user instead of here
                if (rowParent.currentUrlForTutorial.search("http") !== -1) {
                    tOpenUrlExternal.goHere = rowParent.currentUrlForTutorial;
                    tOpenUrlExternal.start();
                    rowParent.currentUrlForTutorial = "docs/view/external.html";
                }

                wrapDocWithLayout();

                currentWebView.url = fileApplicationDirPath + "/docs/current.html";
            }

            function wrapDocWithLayout() {

                var viewPath = fileApplicationDirPath + "/" + rowParent.currentUrlForTutorial;

                io_view.setSource(viewPath);
                var layout  = rowParent.layoutForTutorial;
                var view = io_view.read();

                layout = layout.replace("{{=include(view)}}", view);
                io_current.write(layout);

            }
        }

        Text {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.leftMargin: 10

            text: (currentWebView.loading) ? qsTr("Cargando (" + currentWebView.loadProgress + "%)...") : ""
        }

        Timer {
            property url goHere

            id: tOpenUrlExternal

            interval: 500
            running: false
            repeat: true
            onTriggered: {
                if (currentWebView.loadProgress === 100) {
                    globalInfoBox.loadUrlInBrowser(goHere);
                    tOpenUrlExternal.stop();
                }
            }
        }

    }


}
