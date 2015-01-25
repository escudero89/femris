import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

Item {

    property variant previousSideloadValues;
    property variant previousFixNodesValues;
    property variant previousPointLoadValues;
    property int index : 0

    signal loadPreviousValues();

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

            property string fixnodeIcon : "filter10"

            id: buttonNodeController

            Layout.minimumWidth: 30
            Layout.preferredWidth: parent.width * 0.05

            iconSource: "qrc:/resources/icons/black/" + fixnodeIcon + ".png"

            tooltip: qsTr("Click para resaltar los nodos que pertenecen a éste borde");

            onClicked: {

                switch(buttonNodeController.state) {
                case "neumann"   : buttonNodeController.state = "dirichlet" ; break;
                case "dirichlet" : buttonNodeController.state = "neumann"   ; break;
                }

                repeater.currentIndex = index;

                StudyCaseHandler.setSingleStudyCaseInformation(textInformation + "-state" + (index + 1), buttonNodeController.state, true);
                Configure.emitMainSignal("fixnodesChanged");
            }

            state: "dirichlet"

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

            onEditingFinished: {
                StudyCaseHandler.setSingleStudyCaseInformation(textInformation + (index + 1), text, true);
                Configure.emitMainSignal("fixnodesChanged");
            }

            onFocusChanged: {
                if (focus === true && repeater.currentIndex !== index) {
                    repeater.currentIndex = index;
                    focus = true;
                }
            }
        }
    }

    onLoadPreviousValues: {

        var currentSide = jsonDomain["sideloadNodes"][index];
        var nSideLoad = previousSideloadValues.length / 3;

        for ( var k = 0 ; k < nSideLoad; k++ ) {
            var currentLoad = [
                        previousSideloadValues[k * ( nSideLoad - 1)],
                        previousSideloadValues[k * ( nSideLoad - 1) + 1],
                        previousSideloadValues[k * ( nSideLoad - 1) + 2]
                    ];

            if (currentSide.indexOf(currentLoad[0]) !== -1 && currentSide.indexOf(currentLoad[1]) !== -1) {
                textFieldSideload.text = currentLoad[2];
            }
        }

        //--------------------------------------------------

        var nChecks = previousFixNodesValues.length / 2;

        for ( var k = 0 ; k < nChecks; k++ ) {
            var currentFixNode = [
                previousFixNodesValues[k * ( nChecks - 1)],
                previousFixNodesValues[k * ( nChecks - 1) + 1]
            ];

            if (currentFixNode[0] === (index + 1)) {
                buttonNodeController.state = "dirichlet";
                heatTextField.text = currentFixNode[1];
            }
        }

        //--------------------------------------------------

        nChecks = previousPointLoadValues.length / 2;

        for ( k = 0 ; k < nChecks; k++ ) {
            var currentPointLoad = [
                previousPointLoadValues[k * ( nChecks - 1)],
                previousPointLoadValues[k * ( nChecks - 1) + 1]
            ];

            if (currentPointLoad[0] === (index + 1)) {
                buttonNodeController.state = "neumann";
                heatTextField.text = currentFixNode[1];
            }
        }
    }
}
