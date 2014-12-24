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

    //WebEngineView {
    WebView {
        id: currentWebView
        Layout.fillHeight: true
        Layout.fillWidth: true

        url: fileApplicationDirPath + "/docs/ce_shapefunction.html"
    }

    FooterButtons {
        fromWhere: parent.objectName
    }
}

