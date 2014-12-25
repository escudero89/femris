import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

Item {

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
/*
        Button {

            property string fixnodeIcon : "open94"

            id: buttonNodeController
            Layout.preferredWidth: parent.width * 0.18
            text: qsTr("libre")

            iconSource: "qrc:/resources/icons/black/" + fixnodeIcon + ".png"

            onClicked: {

                switch(buttonNodeController.state) {
                case "libre"  : buttonNodeController.state = "x-fijo" ; break;
                case "x-fijo" : buttonNodeController.state = "y-fijo" ; break;
                case "y-fijo" : buttonNodeController.state = "xy-fijo"; break;
                case "xy-fijo": buttonNodeController.state = "libre"  ; break;
                }

                repeater.currentIndex = index;
            }

            state: "libre"

            states: [
                State {
                    name: "libre"
                    PropertyChanges {
                        target: buttonNodeController
                        text: qsTr("libre")
                        fixnodeIcon: "open94"
                    }
                },
                State {
                    name: "x-fijo"
                    PropertyChanges {
                        target: buttonNodeController
                        text: qsTr("x-fijo")
                        fixnodeIcon: "lock24"
                    }
                    PropertyChanges {
                        target: textFieldSideloadX
                        text: qsTr("fijado")
                        enabled: false
                    }
                },
                State {
                    name: "y-fijo"
                    PropertyChanges {
                        target: buttonNodeController
                        text: qsTr("y-fijo")
                        fixnodeIcon: "lock24"
                    }
                    PropertyChanges {
                        target: textFieldSideloadY
                        text: qsTr("fijado")
                        enabled: false
                    }
                },
                State {
                    name: "xy-fijo"
                    PropertyChanges {
                        target: buttonNodeController
                        text: qsTr("xy-fijo")
                        fixnodeIcon: "lock24"
                    }
                    PropertyChanges {
                        target: textFieldSideloadX
                        text: qsTr("fijado")
                        enabled: false
                    }
                    PropertyChanges {
                        target: textFieldSideloadY
                        text: qsTr("fijado")
                        enabled: false
                    }
                }
            ]
        }
*/
        TextField {

            id: textFieldSideloadX

            Layout.preferredWidth: parent.width / 4
            placeholderText: "x_" + ( index + 1 )

            onEditingFinished: {
                StudyCaseHandler.setSingleStudyCaseInformation(textInformation + "x" + (index + 1), text, true);
            }

            onFocusChanged: {
                if (focus === true && repeater.currentIndex !== index) {
                    repeater.currentIndex = index;
                    focus = true;
                }
            }
        }

        TextField {

            id: textFieldSideloadY

            Layout.preferredWidth: parent.width / 4
            placeholderText: "y_" + ( index + 1 )

            onEditingFinished: {
                StudyCaseHandler.setSingleStudyCaseInformation(textInformation + "y" + (index + 1), text, true);
            }

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
        var nSideLoad = previousSideloadValues.length / 4;

        for ( var k = 0 ; k < nSideLoad; k++ ) {
            var currentLoad = previousSideloadValues.splice(0,4);

            if (currentSide.indexOf(currentLoad[0]) !== -1 && currentSide.indexOf(currentLoad[1]) !== -1) {
                textFieldSideloadX.text = currentLoad[2];
                textFieldSideloadY.text = currentLoad[3];
            }
        }

        return "";
    }
}
