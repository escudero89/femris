import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0
//import QtWebKit.experimental 1.0

import FileIO 1.0

import "../docs"
import "../content"
import "../"

RowLayout {

    id: rowParent
    objectName: "CE_Results"

    spacing: 0

    RowLayout {

        width: rowParent.width
        spacing: 0

        LeftContentBox {
            id: leftContentRectangle

            color: Style.color.content_emphasized
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.20

            firstTimeOnly: true

            onBlockHiding: {
                if (isHiding) {
                    leftContentRectangle.width = leftContentRectangle.parent.width * 0;
                    leftContentRectangle.visible = false;
                } else {
                    leftContentRectangle.width = leftContentRectangle.parent.width * 0.20;
                    leftContentRectangle.visible = true;
                }
                currentWebView.width  = rowParent.width - leftContentRectangle.width;
                currentWebView.x = leftContentRectangle.width;
            }
        }


        WebView {
            id: currentWebView

            url: fileApplicationDirPath + "/docs/ce_results.html"

            Layout.fillHeight: true
            Layout.fillWidth: true

            //experimental.preferences.developerExtrasEnabled: true

            /*MouseArea {
                anchors.fill: parent

                onClicked : {
                    //currentWebView.reload()
                    console.log(fileApplicationDirPath + "docs/ce_results.html")
                }
            }*/

        }

    }

}