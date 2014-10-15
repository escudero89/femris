import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0
import QtWebKit.experimental 1.0

import FileIO 1.0

import "../docs"
import "../content"
import "../"


RowLayout {

    id: rowParent
    spacing: 0

    RowLayout {

        width: rowParent.width
        spacing: 0

        Rectangle {
            color: Style.color.comment
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width - mainContentRectangle.width

            Text {
                text: currentWebView.loadProgress
            }
        }

        Rectangle {
            id: mainContentRectangle
            color: "blue"
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width

            WebView {
                id: currentWebView

              url: "qrc:/docs/ce_results.html"
             //  url: "http://html5test.com/"
                width: parent.width
                height: parent.height

                experimental.preferences.developerExtrasEnabled: true
            }

        }

    }

}
