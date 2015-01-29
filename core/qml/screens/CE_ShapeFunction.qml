import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

//import QtWebEngine 1.0
import QtWebKit 3.0

import "../docs"
import "../content"
import "../content/components"
import "../"

ColumnLayout {

    objectName: "CE_ShapeFunction"
    spacing: 0

    Item {
        Layout.fillHeight: true
        Layout.fillWidth: true

        //WebEngineView {
        WebView {
            id: currentWebView

            anchors.fill: parent

            opacity: 0

            url: fileApplicationDirPath + "/docs/ce_shapefunction.html"

            onLoadingChanged: {
                if (!loading && loadProgress === 100) {
                    Configure.emitMainSignal("loadingImage.close()")
                    opacity = 1;
                }
            }

            Component.onCompleted: Configure.emitMainSignal("loadingImage.show()")

            MouseArea {
                anchors.top: parent.top
                anchors.topMargin: 3
                anchors.right: parent.right
                anchors.rightMargin: 18

                height: 35
                width: 41

                onClicked: {
                    globalInfoBox.loadUrlInBrowser("https://github.com/escudero89/femris/wiki/Funciones-de-Forma");
                }
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
        fromWhere: parent.objectName

        Layout.alignment: Qt.AlignBottom
    }
}

