import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0
import QtWebKit.experimental 1.0

import "../docs"
import "../content"
import "../"

RowLayout {

    id: rowParent
    objectName: "CE_ShapeFunction"

    spacing: 0
    anchors.fill: globalLoader

    LeftContentBox {
        id: leftContentRectangle

        color: Style.color.content_emphasized
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.20

    }

    Column {

        id: mainContentRectangle

        Layout.fillHeight: true
        Layout.preferredWidth: parent.width - leftContentRectangle.width

        WebView {
            id: currentWebView

            experimental.preferences.webGLEnabled: true
            experimental.preferences.developerExtrasEnabled: true

            width: parent.width
            height: parent.height

            url: "qrc:/docs/ce_shapefunction.html"
        }

    }

}
