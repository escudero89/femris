import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

Column {

    WebView {
        id: currentWebView

        width: parent.width
        height: parent.height

        url: "qrc:/docs/current.html"
    }

}
