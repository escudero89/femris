import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

Column {

    Rectangle {

        color: Style.color.content_emphasized

        width: parent.width
        height: parent.height - continueButton.height

        ColumnLayout {

            height: parent.height * 0.95
            width: parent.width * 0.9
            spacing: 0

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            WebView {
                Layout.fillWidth: parent.width
                Layout.fillHeight: parent.height

                url: "qrc:/docs/current.html"

            }

            PrimaryButton {
                buttonLabel: "Ir hasta aqui"
                buttonStatus: "white"
                buttonText.font.pixelSize: height / 2

                Layout.fillWidth: parent.width
            }
        }
    }

    RowLayout {

        spacing: 0
        width: parent.width

        PrimaryButton {
            buttonLabel: "Vista General"
            buttonStatus: "primary"
            buttonText.font.pixelSize: height / 2

            onClicked : mainWindow.switchSection("CE_Overall")

            Layout.fillWidth: true
        }

        PrimaryButton {
            id: continueButton

            buttonLabel: "Guardar y Continuar"
            buttonStatus: "success"
            buttonText.font.pixelSize: height / 2

            Layout.preferredWidth: 0.6 * parent.width
        }
    }
}
