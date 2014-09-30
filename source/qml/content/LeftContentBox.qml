import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

Rectangle {

    ColumnLayout {

        id: columnLayout1

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        height : parent.height * 0.97
        width : parent.width * 0.9

        spacing: 0

        TableView {

            Layout.fillHeight: true
            Layout.fillWidth: true

            TableViewColumn {
                role: "title"
                title: qsTr("Modelo Físico")
                resizable: false
            }

            model: ListModel {
               ListElement{ title: "Ecuación de Transporte" ; author: "Gabriel" }
               ListElement{ title: "Brilliance"    ; author: "Jens" }
               ListElement{ title: "Outstanding"   ; author: "Frederik" }
            }
        }

        PrimaryButton {
            buttonLabel: "Nuevo Modelo"
            buttonStatus: "white"
            buttonText.font.pixelSize: height / 2

            Layout.fillWidth: true
        }

        Rectangle {
            color: "transparent"
            Layout.preferredHeight: columnLayout1.height * 0.02
            Layout.fillWidth: true
        }

        FirstTimeBox {
        }
    }
}
