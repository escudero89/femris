import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

Rectangle {
    id: rectangle1

    property string blockStatus : "default"

    property alias image : imageMiniChoiceBlock

    border.color: Style.color.complement

    color: {
        var finalColor = Style.color.success;

        if (blockStatus === "disabled") {
            finalColor = Style.color.content;
        } else if (blockStatus === "used") {
            finalColor = Style.color.complement_highlight;
        }

        return finalColor;
    }

    Image {
        id: imageMiniChoiceBlock

        height: parent.height * 0.9
        width: parent.width * 0.9
        opacity: 0.7

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        source : "qrc:/resources/images/overall/model.png"
    }

    Rectangle {

        anchors.fill: parent

        border.color: color

        gradient: Gradient {
            GradientStop { position: 0.0; color: Style.color.background }
            GradientStop { position: 1.0; color: Style.color.complement }
        }

        opacity: 0.1
    }

}
