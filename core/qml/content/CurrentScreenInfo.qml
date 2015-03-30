import QtQuick 2.3
import QtQuick.Layouts 1.1

import "../"

Item {

    signal open(string section)
    signal close()

    property string currentSection : "CE_Model"

    id: rCurrentScreenInfo

    anchors.fill: parent
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0

    z: 10000

    onOpen: {

        var stepsToConsider = [
                    'CE_Overall',
                    "CE_Model"
                ];

        if (! (stepsToConsider.indexOf(section) >= 0) ) {
            return;
        }

        currentSection = section;
        visible =  true;
    }

    onClose: {
        visible = false;
    }

    Rectangle {

        anchors.fill: parent

        color: Style.color.background
        opacity: 0.99

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

                source: "qrc:/resources/images/current_screen_info/" + currentSection + ".png"

                fillMode: Image.PreserveAspectFit
            }

            PrimaryButton {
                Layout.alignment: Qt.AlignBottom | Qt.AlignRight

                text: "Entendido"

                buttonStatus: "white"
                iconSource: "qrc:/resources/icons/black/correct8.png"

                onClicked: rCurrentScreenInfo.close()
            }
        }
    }
}
