import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

import "../smallBoxes"

Item {
    id: alertModal
    visible: false

    property string contentTitle : "Alert Box!"
    property string contentName : "byDefault"
    property string hasImage : "false"

    anchors.fill: parent
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0

    z: 1000

    function open() {
        alertModal.visible = true;
    }

    function close() {
        alertModal.visible = false;
    }

    Rectangle {
        anchors.fill: parent
        color: Style.color.complement

        opacity: 0.8

        MouseArea {
            anchors.fill: parent
            onClicked: alertModal.close()

        }
    }

    Rectangle {
        id: rectangle1
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        height: parent.height * 0.8
        width: 600

        color: Style.color.comment

        border.width: 3
        border.color: Style.color.background_highlight

        MouseArea {
            // This prevent the previous mouse area to exit the modal
            anchors.fill: parent
        }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Style.color.background_highlight }
                GradientStop { position: 1.0; color: Style.color.comment }
            }

            opacity: 0.25
        }

        Rectangle {
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            opacity: 0.2
        }

        Rectangle {
            id: headerAlertModal

            anchors.right: parent.right
            anchors.rightMargin: 3
            anchors.left: parent.left
            anchors.leftMargin: 3
            anchors.top: parent.top
            anchors.topMargin: 3

            height: textAlertModal.height * 2

            color: Style.color.info

            opacity: 0.8
        }

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: headerAlertModal.top
            anchors.topMargin: textAlertModal.height

            height: textAlertModal.height
            opacity: 0.1
        }

        PrimaryButton {
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            buttonLabel: ""
            iconSource: "qrc:/resources/icons/black/cross41.png"

            buttonStatus: "white"

            height: width
            width: headerAlertModal.height - 15

            onClicked: alertModal.close()
        }

        ColumnLayout {
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            spacing: 20

            Rectangle {

                Layout.fillWidth: true
                Layout.preferredHeight: headerAlertModal.height - 20
                Layout.alignment: Qt.AlignCenter
                color: "transparent"

                Text {
                    id: textAlertModal

                    text: qsTr(contentTitle)
                    font.pointSize: Style.fontSize.h4

                    textFormat: Text.RichText
                    horizontalAlignment: Text.AlignHCenter

                    width: parent.width

                    color: Style.color.background
                }

            }

            TextArea {

                id: textAreaModal

                text: qsTr(Content.alert[contentName])

                Layout.fillHeight: true
                Layout.fillWidth: true

                backgroundVisible: false
                frameVisible: false

                readOnly: true

                textFormat: TextEdit.RichText
                textColor: Style.color.complement_highlight

            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "transparent"
            }

            Image {
                Layout.fillHeight: true
                Layout.fillWidth: true
                fillMode: Image.PreserveAspectFit

                source:  (alertModal.hasImage !== "false") ? alertModal.hasImage : "qrc:/resources/images/square_shadow.png"

                visible: (alertModal.hasImage !== "false") ? true : false
            }
        }
    }
}
