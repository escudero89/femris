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
                    'CE_Model',
                    'CE_Domain'
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

        Image {
            anchors.fill: parent
            source: "qrc:/resources/images/current_screen_info/" + currentSection + ".png"
            fillMode: Image.PreserveAspectFit
        }

        PrimaryButton {

            anchors.right: parent.right
            anchors.bottom: parent.bottom

            text: "Entendido"

            buttonStatus: "white"
            iconSource: "qrc:/resources/icons/black/correct8.png"

            onClicked: rCurrentScreenInfo.close()
        }

    }
}
