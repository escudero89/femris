import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtQuick.XmlListModel 2.0

import "../"

// Index
ColumnLayout {

    id: indexLayout

    // Recarga el loader central usando el StackView
    signal loader(string url)

    // Relleno de fondo
    Rectangle {
        color: Style.color.background
        anchors.fill: parent
    }

    // TopBar
    BorderImage {
        border.bottom: 8
        source: "qrc:/resources/images/toolbar.png"

        Layout.preferredHeight: indexLayout.height * 0.05
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
                source: "qrc:/resources/images/navigation_previous_item.png"
                height: parent.height
                width: height
            }

            MouseArea {
                id: backmouse
                anchors.fill: parent
                anchors.margins: -10

                onClicked: {
                    // Le avisamos a StackView que deberia volver
                    stackView.makePop()
                }
            }
        }

        Text {
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter

            color: Style.color.info
            font.pixelSize: parent.height / 2
            text: qsTr("Índice")
        }
    }

    StackIndex {
        id: stackView
    }

}
