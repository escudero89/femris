import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../"

ColumnLayout {

    property alias textArea : choiceBlockTextArea
    property alias header : headerText
    property alias button : primaryButton
    property alias image : imageChoiceBlock

    property string blockStatus : "default";        // default, used, disabled

    implicitWidth: 200
    implicitHeight: 400
    spacing: 0

    Rectangle {
        id: rectangle1

        Layout.fillWidth: true
        Layout.preferredHeight: width / 5

        color: {
            var finalColor = (typeof(Style.color[primaryButton.buttonStatus]) !== "undefined") ? Style.color[primaryButton.buttonStatus] : Style.color.primary;

            if (blockStatus === "disabled") {
                finalColor = Style.color.comment_emphasized;
            } else if (blockStatus === "used") {
                finalColor = Style.color.content;
            }

            return finalColor;
        }

        Text {
            id: headerText
            text: qsTr(header)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            font.pixelSize: rectangle1.height / 2
            font.bold: true

            color: Style.color.background_highlight
        }

    }

    Rectangle {

        Layout.fillHeight: true
        Layout.fillWidth: true

        color: {
            var finalColor = Style.color.background_highlight;

            if (blockStatus === "disabled") {
                finalColor = Style.color.comment;
            } else if (blockStatus === "used") {
                finalColor = Style.color.background;
            }

            return finalColor;
        }

        ColumnLayout {
            id: columnLayout1
            anchors.fill: parent
            anchors.margins: 10

            spacing: 15

            Image {
                id: imageChoiceBlock

                Layout.preferredHeight: width

                Layout.fillWidth: true
                Layout.maximumWidth: parent.width / 1.5

                Layout.alignment: Qt.AlignCenter

                source: "qrc:/resources/images/square_shadow.gif"

                smooth: true

                fillMode: Image.PreserveAspectFit
            }

            TextArea {
                id: choiceBlockTextArea

                text: qsTr("The source of the image is specified as a URL using the source property. Images can be supplied in any of the standard image formats supported by Qt, including bitmap formats such as PNG and JPEG, and vector graphics formats such as SVG. If you need to display animated images, use the AnimatedImage element.")
                textFormat: TextEdit.RichText

                font.pixelSize: Math.max(parent.width / 15, 12)

                Layout.fillHeight: true
                Layout.fillWidth: true

                backgroundVisible: false
                frameVisible: false

                readOnly: true

                textColor: {
                    var finalColor = Style.color.complement_highlight;

                    if (blockStatus === "disabled") {
                        finalColor = Style.color.comment_emphasized;
                    } else if (blockStatus === "used") {
                        finalColor = Style.color.content;
                    }

                    return finalColor;
                }
            }

            PrimaryButton {
                id: primaryButton

                anchors.bottomMargin: 0
                anchors.bottom: parent.bottom

                Layout.fillWidth: true
                Layout.preferredHeight: parent.height / 11

                buttonStatus: blockStatus
            }

        }
    }

}
