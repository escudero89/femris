import QtQuick 2.3
import QtQuick.Layouts 1.1

import "../"

Rectangle {

    id: rCurrentScreenInfo

    anchors.fill: parent
    color: Style.color.background_highlight
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0

    opacity: 0.95

    z: 1000

    MouseArea {
        anchors.fill: parent
    }

    Text {
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        color: Style.color.comment_emphasized
        text : qsTr("Puedes ocultar estas ventanas desde <b>Edición/Preferencias</b>.")
        textFormat: Text.RichText

        anchors.leftMargin: 10
        anchors.bottomMargin: 10
    }

    ColumnLayout {
        anchors.fill: parent

        Image {
            Layout.fillHeight: true
            Layout.fillWidth: true

            source: "qrc:/resources/images/model/tutorial.png"

            fillMode: Image.PreserveAspectFit
        }

        PrimaryButton {
            Layout.alignment: Qt.AlignBottom | Qt.AlignRight

            text: "Cerrar"

            buttonStatus: "white"
            iconSource: "qrc:/resources/icons/cross41.png"

            onClicked: rCurrentScreenInfo.visible = false;
        }
    }

}
