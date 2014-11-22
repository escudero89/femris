import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

import "../docs"
import "../screens"
import "../"
import "."

import "smallBoxes"

Item {
    id: alertModal
    visible: false

    property string contentTitle : "Alert Box!"
    property string contentName : "byDefault"

    anchors.fill: parent
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0

    z: 1000

    Rectangle {
        anchors.fill: parent
        color: Style.color.complement

        opacity: 0.8

        MouseArea {
            anchors.fill: parent
        }
    }

    Rectangle {
        id: rectangle1
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        height: 400
        width: 600

        color: Style.color.comment

        border.width: 3
        border.color: Style.color.background_highlight

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 1.0; color: "black" }
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
            anchors.top: headerAlertModal.bottom - textAlertModal.height
            anchors.topMargin: 0

            height: textAlertModal.height
            opacity: 0.1
        }

        ColumnLayout {
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            z: parent.z + 3

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
                text: qsTr(Content.alert[contentName])

                font.pointSize: Style.fontSize.h5

                Layout.maximumHeight: 120
                Layout.fillWidth: true

                backgroundVisible: false
                frameVisible: false

                readOnly: true

                textFormat: TextEdit.RichText
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "transparent"
            }

            RowLayout {

                Layout.fillHeight: true
                Layout.fillWidth: true

                Layout.alignment: Qt.AlignRight

                PrimaryButton {
                    buttonLabel: "Cerrar"
                    iconSource: "qrc:/resources/icons/black/cross41.png"

                    buttonStatus: "white"

                    onClicked: {
                        alertModal.visible = false;
                    }
                }
            }
        }
    }
}
