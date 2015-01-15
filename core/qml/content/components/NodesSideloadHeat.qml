import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

Item {

    property variant previousSideloadValues;
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
                case "show" : buttonNodeController.state = "hide" ; break;
                case "hide" : buttonNodeController.state = "show" ; break;
                }

                repeater.currentIndex = index;

                var changes = {
                    affectedNodes : jsonDomain["sideloadNodes"][index],
                    affectedIndex : index,
                    state : buttonNodeController.state
                };

                Configure.emitMainSignal("NodesChanged", JSON.stringify(changes));
                Configure.emitMainSignal("NodesSideloadChanged", JSON.stringify(changes));
            }

            state: "hide"

            states: [
                State {
                    name: "hide"
                    PropertyChanges {
                        target: buttonNodeController
                        tooltip: qsTr("Resaltar")
                        fixnodeIcon: "star61"
                    }
                },
                State {
                    name: "show"
                    PropertyChanges {
                        target: buttonNodeController
                        tooltip: qsTr("Dejar de resaltar")
                        fixnodeIcon: "star60"
                    }
                }
            ]

            Connections {
                target : Configure

                onMainSignalEmitted : {
                    if ( signalName !== "NodesSideloadChanged" ) {
                        return;
                    }

                    var changes = JSON.parse(args);
                    var isShowing = ( changes.state === "show" );

                    if ( changes.affectedIndex !== index && isShowing) {
                        buttonNodeController.state = "hide";
                    }
                }
            }
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
    }
}
