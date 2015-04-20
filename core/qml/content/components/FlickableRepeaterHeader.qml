import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebKit 3.0

import "../../"
import "../smallBoxes"
import "../"
import "."

ColumnLayout {

    property alias objectHeader: textHeader

    Rectangle {

        Layout.preferredHeight: textHeader.height * 1.1
        Layout.preferredWidth: parent.width

        color: Style.color.background_highlight

        Text {
            id: textHeader

            textFormat: Text.RichText
            font.pointSize: Style.fontSize.h5

            anchors.left: parent.left
            anchors.leftMargin: 12
        }

    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 3

        color: Style.color.complement
        opacity: 0.3
    }
}
