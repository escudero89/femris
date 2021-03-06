import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebEngine 1.0
import FileIO 1.0

import "../docs"
import "../content"
import "../content/components"
import "../"

ColumnLayout {

    objectName: "CE_Results"
    spacing: 0

    Item {
        Layout.fillHeight: true
        Layout.fillWidth: true

        WebEngineView {

            id: currentWebView

            anchors.fill: parent

            opacity: 0

            // We load the layout and the view, and put the info in the WebView
            FileIO {
                id: io_layout
                source: fileApplicationDirPath + "/docs/ce_results_layout.html"
                onError: console.log(msg)
            }

            FileIO {
                id: io_view
                source: (StudyCaseHandler.isStudyType("heat")) ?
                            fileApplicationDirPath + "/docs/ce_results_view_heat.html"  :
                            fileApplicationDirPath + "/docs/ce_results_view.html"

                onError: console.log(msg)
            }

            FileIO {
                id: io_current
                source: fileApplicationDirPath + "/docs/ce_results.html"
                onError: console.log(msg)
            }

            FileIO {
                id: io_handler
                source: fileApplicationDirPath + "/temp/currentMatFemFile.m"
                onError: console.log(msg)
            }

            Component.onCompleted: {
                var layout  = io_layout.read();
                var view = io_view.read();

                view = view.replace('{{=include(currentMatFemFile.m)}}', removeUselessEmptyLines(io_handler.read()));
                view = replaceInLayoutScriptsFiles(view);

                layout = layout.replace("{{=include(view)}}", view);
                io_current.write(layout);

                currentWebView.url = fileApplicationDirPath + "/docs/ce_results.html";
                currentWebView.reload();
                Configure.emitMainSignal("loadingImage.show()")
            }

            onLoadingChanged: {
                if (!loading && loadProgress === 100) {
                    Configure.emitMainSignal("loadingImage.close()")
                    opacity = 1;
                }
            }

            function replaceInLayoutScriptsFiles(content) {

                var scripts_dir = fileApplicationDirPath + "/scripts/MAT-fem/";

                var files = content.match(/{{\=include\((\w+\.*\w+)\)}}/g);

                for ( var kFile = 0; kFile < files.length ; kFile++ ) {

                    var script = files[kFile].substring("{{=include(".length, files[kFile].length - 3);

                    io_handler.source = scripts_dir + script;
                    content = content.replace(files[kFile], removeFemrisAdditionComment(io_handler.read()));
                }

                return content;
            }

            function removeFemrisAdditionComment(file) {
                file = file.replace(/\r\n/g, "___breakline___");

                var femrisAdditionRegex = /\% FEMRIS .*? END FEMRIS ADDITION/g;

                while (file.search(femrisAdditionRegex) !== -1) {
                    file = file.replace(femrisAdditionRegex, "");
                }

                file = file.replace(/\_\_\_breakline\_\_\_/g, "\r\n");

                return removeUselessEmptyLines(file);
            }

            function removeUselessEmptyLines(file) {
                // We replace triple enter with just one double enter
                var tripleEnterRegex = /\r\n\s*\r\n\s*\r\n/g;

                while (file.search(tripleEnterRegex) !== -1) {
                    file = file.replace(tripleEnterRegex, "\r\n");
                }

                return file;
            }

            MouseArea {
                anchors.top: parent.top
                anchors.topMargin: 3
                anchors.right: parent.right
                anchors.rightMargin: StudyCaseHandler.isStudyType('heat') ? 18 : 3

                height: 39
                width: 41

                onClicked: globalInfoBox.loadUrlInBrowser("https://github.com/escudero89/femris/wiki/Resultados");
            }
        }

        Text {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.bottomMargin: 10

            text: (currentWebView.loading) ? qsTr("Cargando (" + currentWebView.loadProgress + "%)...") : ""
            color:  Style.color.background;
        }

    }

    FooterButtons {
        urlBase : "docs/ce_results.html"

        Layout.alignment: Qt.AlignBottom
    }

}
