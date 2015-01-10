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
    spacing: 2

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

