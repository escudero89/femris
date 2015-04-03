import QtQuick 2.3
import QtQuick.Layouts 1.1

import "../"

Item {

    signal open(string section)
    signal close()

    property string currentSection : "CE_Model"

    property variant alreadyShownInThisInstance : []

    id: rCurrentScreenInfo

    anchors.fill: parent
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0

    z: 10000

    onOpen: {

        // If the configuration is off, we don't show any screen
        if (Configure.check("showScreenInfo", "false")) {
            return;
        }

        var stepsToConsider = [
                    'CE_Overall',
                    'CE_Model',
                    'CE_Domain',
                    'CE_ShapeFunction',
                    'CE_Results'
                ];

        // Exists the screen for this step?
        if (! (stepsToConsider.indexOf(section) >= 0) ) {
            return;
        }

        // If we already have shown this screen, we don't show it again in the same instance
        if (alreadyShownInThisInstance.indexOf(section) >= 0) {
            return;
        }

        // Then we made the selection
        currentSection = section;
        alreadyShownInThisInstance.push(section);

        visible =  true;
        naFadeIn.start();

    }

    onClose: {
        naFadeOut.start();
    }

    Rectangle {

        id: rInfoScreen

        anchors.fill: parent

        color: Style.color.background
        opacity: 0

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

            onClicked: {
                rCurrentScreenInfo.close()
            }
        }

        onOpacityChanged: visible = (opacity === 0) ? false : true

    }

    NumberAnimation {

        id: naFadeIn
        running: false

        target: rInfoScreen

        property: "opacity"

        to: 0.99
        duration: 0

    }

    NumberAnimation {

        id: naFadeOut
        running: false

        target: rInfoScreen

        property: "opacity"

        to: 0
        duration: 700

    }

}
