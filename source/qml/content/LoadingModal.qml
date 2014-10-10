import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import "../docs"
import "../screens"
import "../"
import "."

import "smallBoxes"

Item {
    id: loadingModal
    visible: true

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
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        height: parent.height * 0.7
        width: parent.width * 0.7

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
            z: parent.z + 1
        }

        RowLayout {

            anchors.fill: parent
            z: parent.z + 2

            ProgressBar {
                id: progressBarModal
                Layout.alignment: Qt.AlignCenter

                value: 0
                minimumValue: 0
                maximumValue: 100

                style: ProgressBarStyle {
                    background: Rectangle {
                        color: Style.color.background
                        border.color: Style.color.background_highlight
                        border.width: 2
                        implicitWidth: 200
                        implicitHeight: 24
                    }
                    progress: Rectangle {
                        border.color: Style.color.background
                        color: Style.color.primary
                    }

                }

                Behavior on value {
                    NumberAnimation { duration: 500 }
                }
            }
        }

    }

    Connections {
        target: ProcessHandler

        onProccessCalled: {
            loadingModal.visible = 1;
            console.log("Called...");
            progressBarModal.value = Math.floor(Math.random() * 100 % 40) + 10;
        }

        onProcessWrote: {
            console.log("Wrote...");
            progressBarModal.value = Math.floor(Math.random() * 100 % 20) + 60;
        }

        onProcessRead: {
            console.log("Read...");
            progressBarModal.value = 100;
        }

        onProcessFinished: {
            loadingModal.visible = 0;
            console.log("Finished...");
            progressBarModal.value = 0;
        }

    }
}
