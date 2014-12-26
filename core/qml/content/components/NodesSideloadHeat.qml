import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

Item {

    property int index : 0

    id: cellContent

    width: repeater.cellWidth
    height: repeater.cellHeight

    Rectangle {
        anchors.fill: parent

        color: (index === repeater.currentIndex) ?
                   Style.color.femris :
                   ((index % 2 === 0) ?
                        Style.color.background_highlight :
                        Style.color.background) ;

        opacity: 0.3

        Behavior on color {
            ColorAnimation {}
        }
    }

    RowLayout {

        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height
        width: parent.width * .95

        spacing: 0

        Text {
            Layout.fillWidth: true
            text: qsTr(textRow + (index + 1))

            MyToolTip {
                id: tooltip

                text: (!jsonDomain["sideloadNodes"]) ?
                          "" :
                          (!jsonDomain["sideloadNodes"][index]) ?
                              "" :
                              jsonDomain["sideloadNodes"][index].join('-')

                z: cellContent.z + 100
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    tooltip.show();
                }

                onExited: {
                    tooltip.hide();
                }
            }
        }

        Button {

            property string fixnodeIcon : "open94"

            id: buttonNodeController
            Layout.preferredWidth: parent.width * 0.3

            iconSource: "qrc:/resources/icons/black/" + fixnodeIcon + ".png"

            onClicked: {

                switch(buttonNodeController.state) {
                case "dirichlet"  : buttonNodeController.state = "neumann"   ; break;
                case "neumann"    : buttonNodeController.state = "dirichlet" ; break;
                }

                repeater.currentIndex = index;
            }

            state: "neumann"
            enabled: false

            states: [
                State {
                    name: "neumann"
                    PropertyChanges {
                        target: buttonNodeController
                        text: qsTr("Neumann")
                        fixnodeIcon: "bookmark10"
                    }
                },
                State {
                    name: "dirichlet"
                    PropertyChanges {
                        target: buttonNodeController
                        text: qsTr("Dirichlet")
                        fixnodeIcon: "bookmark9"
                    }
                    PropertyChanges {
                        target: textFieldSideload
                        textColor: Style.color.femris
                    }
                }
            ]
        }


        TextField {

            id: textFieldSideload

            Layout.preferredWidth: parent.width * 0.4
            placeholderText: (buttonNodeController.state === "dirichlet") ? "[ºC]" : "[W/m]"

            onEditingFinished: StudyCaseHandler.setSingleStudyCaseInformation(textInformation + (index + 1), text, true);

            onFocusChanged: {
                if (focus === true && repeater.currentIndex !== index) {
                    repeater.currentIndex = index;
                    focus = true;
                }
            }
        }
    }

    Component.onCompleted: {
        var previousSideloadValues = eval(StudyCaseHandler.getSingleStudyCaseInformation("sideload").replace(/;/g, ",").replace("],", "];").replace("=", "").replace("sideload", "").trim());

        var currentSide = jsonDomain["sideloadNodes"][index];
        var nSideLoad = previousSideloadValues.length / 3;

        for ( var k = 0 ; k < nSideLoad; k++ ) {
            var currentLoad = previousSideloadValues.splice(0, 3);

            if (currentSide.indexOf(currentLoad[0]) !== -1 && currentSide.indexOf(currentLoad[1]) !== -1) {
                textFieldSideload.text = currentLoad[2];
            }
        }

        return "";
    }
}
