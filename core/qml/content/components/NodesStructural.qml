import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

Item {

    property variant jsonDomain;

    property variant previousFixNodesValues;
    property variant previousPointLoadValues;

    property int index : 0
    property int currentIndex : 0

    signal loadPreviousValues();
    signal rowModifiedCurrentIndex();

    id: cellContent

    Rectangle {
        anchors.fill: parent
        color: ((index % 2 === 0) ? Style.color.background_highlight : Style.color.background) ;

        opacity: 0.7
    }

    RowLayout {

        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height
        width: parent.width * .95

        spacing: 0

        Text {
            Layout.fillWidth: true
            text: qsTr("Nodo #" + (index + 1))
        }


        Button {
            property bool isEnabled : ( jsonDomain.sideloadNodes.join().search(index + 1) !== -1)

            property string fixnodeIcon : "open94"

            id: buttonNodeController
            Layout.preferredWidth: parent.width * 0.18
            text: qsTr("libre")

            iconSource: "qrc:/resources/icons/black/" + fixnodeIcon + ".png"

            enabled: isEnabled

            tooltip: qsTr("Click para seleccionar un tipo de condición de borde para éste nodo");

            onClicked: {

                switch(buttonNodeController.state) {
                case "libre"  : buttonNodeController.state = "x-fijo" ; break;
                case "x-fijo" : buttonNodeController.state = "y-fijo" ; break;
                case "y-fijo" : buttonNodeController.state = "xy-fijo"; break;
                case "xy-fijo": buttonNodeController.state = "libre"  ; break;
                }

                rowModifiedCurrentIndex();
                StudyCaseHandler.isReady();
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
                        target: xTextField
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
                        target: yTextField
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
                        target: xTextField
                        text: qsTr("fijado")
                        enabled: false
                    }
                    PropertyChanges {
                        target: yTextField
                        text: qsTr("fijado")
                        enabled: false
                    }
                }
            ]
        }

        TextField {
            id: xTextField

            Layout.preferredWidth: parent.width / 4
            placeholderText: "x_" + ( index + 1 ) + " [N]"

            onTextChanged: {
                StudyCaseHandler.setSingleStudyCaseInformation("pointloadx" + (index + 1), text, true);
                StudyCaseHandler.isReady();
            }

            onFocusChanged: {
                if (focus === true && currentIndex !== index) {
                    rowModifiedCurrentIndex();
                    focus = true;
                }
            }
        }

        TextField {
            id: yTextField

            Layout.preferredWidth: parent.width / 4
            placeholderText: "y_" + ( index + 1 ) + " [N]"

            onTextChanged: {
                StudyCaseHandler.setSingleStudyCaseInformation("pointloady" + (index + 1), text, true);
                StudyCaseHandler.isReady();
            }

            onFocusChanged: {
                if (focus === true && currentIndex !== index) {
                    rowModifiedCurrentIndex();
                    focus = true;
                }
            }
        }
    }

    onLoadPreviousValues: {

        var nChecks = previousFixNodesValues.length / 3;

        for ( var k = 0 ; k < nChecks; k++ ) {
            var currentFixNode = [
                previousFixNodesValues[k * ( nChecks - 1)],
                previousFixNodesValues[k * ( nChecks - 1) + 1],
                previousFixNodesValues[k * ( nChecks - 1) + 2]
            ];

            if (currentFixNode[0] === (index + 1)) {
                if (parseInt(currentFixNode[1]) === 1) {
                    buttonNodeController.state =
                            ((buttonNodeController.state === "y-fijo") ? "xy-fijo" : "x-fijo");
                } else {
                    buttonNodeController.state =
                            ((buttonNodeController.state === "x-fijo") ? "xy-fijo" : "y-fijo");
                }
            }
        }

        //--------------------------------------------------

        nChecks = previousPointLoadValues.length / 3;

        for ( k = 0 ; k < nChecks; k++ ) {
            var currentPointLoad = [
                previousPointLoadValues[k * ( nChecks - 1)],
                previousPointLoadValues[k * ( nChecks - 1) + 1],
                previousPointLoadValues[k * ( nChecks - 1) + 2]
            ];

            if (currentPointLoad[0] === (index + 1)) {
                if (currentPointLoad[1] === 1) {
                    xTextField.text = currentPointLoad[2];
                } else {
                    yTextField.text = currentPointLoad[2];
                }
            }
        }
    }

    Connections {
        target : Configure

        onMainSignalEmitted : {
            if (signalName !== "NodesSideloadChanged") {
                return;
            }

            var changes = JSON.parse(args);
            var isShowing = ( changes.state === "show" );
            var isHiding  = !isShowing;

            // These applies to all the nodes
            parent.enabled = isHiding ? true : false;
            parent.opacity = isHiding ? 1    : 0.2  ;

            if (isHiding) {
                return;
            }

            // As the index starts in zero, we need to add one
            if (changes.affectedNodes.indexOf(index + 1) === -1) {
                return;
            }

            // These only to those nodes selected
            parent.enabled = isShowing ? true : false ;
            parent.opacity = isShowing ? 1    : 0.2   ;
        }
    }
}
