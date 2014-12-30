import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtQuick.XmlListModel 2.0

import "../"

// Index
ColumnLayout {

    id: indexLayout

    // Reloads the central loader usign the StackView
    signal loader(string url)

    // TopBar
    BorderImage {
        border.bottom: 8
        source: "qrc:/resources/images/toolbar.png"

        Layout.fillWidth: true

        Rectangle {
            id: backButton

            height: parent.height * .6
            width: opacity ? 60 : 0

            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            antialiasing: true
            radius: 4
            opacity: stackView.depth > 1 ? 1 : 0

            color: backmouse.pressed ? Style.color.primary : "transparent"

            Behavior on opacity { NumberAnimation{} }

            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/resources/icons/chevron20.png"
                height: parent.height
                width: height
            }

            MouseArea {
                id: backmouse
                anchors.fill: parent
                anchors.margins: -10

                // Le avisamos a StackView que deberia volver
                onClicked: stackView.makePop();
            }
        }

        Text {
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter

            color: Style.color.background
            font.pixelSize: parent.height / 2
            text: qsTr("Índice")
        }
    }

    StackIndex {
        id: stackView

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    // BottomBar
    RowLayout {

        Layout.alignment: Qt.AlignBottom

        Layout.fillWidth: true
        spacing: 0

        PrimaryButton {
            buttonStatus: "black"
            buttonLabel: "Regresar"
            iconSource: "qrc:/resources/icons/reply8.png"

            Layout.fillWidth: true

            onClicked: {
                if (StudyCaseHandler.exists()) {

                } else {
                    mainWindow.switchSection(StudyCaseHandler.getSingleStudyCaseInformation("tutorialReturnTo", true));
                }
            }
        }

        PrimaryButton {
            buttonStatus: "femris"
            buttonLabel: "BROWSER"
            iconSource: "qrc:/resources/icons/external2.png"

            Layout.fillWidth: true

            onClicked: StudyCaseHandler.loadUrlInBrowser("docs/current.html");
        }
    }
}
