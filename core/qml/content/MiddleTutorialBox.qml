import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebKit 3.0
import QtWebKit.experimental 1.0

import "../docs"
import "../screens"
import "../"
import "."

Column {

    property string urlWebView: "qrc:/docs/ce_shapefunction.html"

    WebView {
        id: currentWebView

        experimental.preferences.webGLEnabled: true
        experimental.preferences.developerExtrasEnabled: true

        width: parent.width
        height: parent.height

        onLinkHovered: console.log(hoveredUrl)
        url: urlWebView
    }

}
