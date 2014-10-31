import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtWebKit 3.0

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

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
            //buttonText.font.pixelSize: height / 2

            Layout.fillWidth: parent.width
        }
    }
}
