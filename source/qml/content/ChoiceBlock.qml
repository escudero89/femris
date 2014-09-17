import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../"

ColumnLayout {

    implicitWidth: 200
    implicitHeight: 400
    spacing: 0

    Rectangle {
        id: rectangle1

        Layout.preferredHeight: 40
        Layout.fillWidth: true

        color: Style.color.info

        Text {
            text: qsTr(header)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            font.pointSize: parent.height / 3
            font.bold: true

            color: Style.color.grey_lighter
        }

    }

    Rectangle {

        Layout.fillHeight: true
        Layout.fillWidth: true

        color: Style.color.background_highlight

        ColumnLayout {
            id: columnLayout1
            anchors.fill: parent
            anchors.margins: 20

            spacing: 25

            Text {
                text: qsTr("The source of the image is specified as a URL using the source property. Images can be supplied in any of the standard image formats supported by Qt, including bitmap formats such as PNG and JPEG, and vector graphics formats such as SVG. If you need to display animated images, use the AnimatedImage element.")
                //anchors.top: image_insider.bottom
                //anchors.topMargin: 20

                Layout.fillWidth: true

                wrapMode: Text.WordWrap
            }

            PrimaryButton {
                anchors.bottomMargin: 0
                anchors.bottom: parent.bottom

                Layout.fillWidth: true

                height: 60
            }
        }
    }

}
