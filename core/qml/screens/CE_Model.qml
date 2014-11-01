import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../content"
import "../"

RowLayout {

    id: rowParent
    objectName: "CE_Model"

    spacing: 0
    anchors.fill: globalLoader

    LeftContentBox {
        id: leftContentRectangle

        color: Style.color.content_emphasized
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.20
    }

    MiddleTutorialBox {
        id: mainContentRectangle

        Layout.fillHeight: true
        Layout.preferredWidth: (parent.width - leftContentRectangle.width) * .55

        urlWebView: "qrc:/docs/ce_domain.html"
    }

    CE_RightBlock {
        id: rightContentRectangle

        Layout.fillHeight: true
        Layout.preferredWidth: parent.width - mainContentRectangle.width - leftContentRectangle.width
    }
}
