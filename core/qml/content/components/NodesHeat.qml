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
        }


        Button {
            property bool isEnabled :
                ( jsonDomain.sideloadNodes.join().search(index + 1) !== -1) ?
                    true : false

            property string fixnodeIcon : "open94"

            id: buttonNodeController
            Layout.preferredWidth: parent.width * 0.3

            iconSource: "qrc:/resources/icons/black/" + fixnodeIcon + ".png"

            enabled: isEnabled

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
                        target: heatTextField
                        textColor: Style.color.femris
                    }
                }
            ]
        }

        TextField {
            id: heatTextField

            Layout.preferredWidth: parent.width * 0.4
            placeholderText: (buttonNodeController.state === "dirichlet") ? "[ºC]" : "[W]"

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

    Component.onCompleted: {
        var previousFixNodesValues = eval(StudyCaseHandler
                                          .getSingleStudyCaseInformation("fixnodes")
                                          .replace(/;/g, ",")
                                          .replace("],", "];")
                                          .replace("=", "")
                                          .replace("fixnodes", "")
                                          .trim());

        var previousPointLoadValues = eval(StudyCaseHandler
                                           .getSingleStudyCaseInformation("pointload")
                                           .replace(/;/g, ",")
                                           .replace("],", "];")
                                           .replace("=", "")
                                           .replace("pointload", "")
                                           .trim());

        //--------------------------------------------------

        var nChecks = previousFixNodesValues.length / 3;

        for ( var k = 0 ; k < nChecks; k++ ) {
            var currentFixNode = previousFixNodesValues.splice(0,3);

            if (currentFixNode[0] === (index + 1)) {
                if (currentFixNode[1] === 1) {
                    console.log(index, k, currentFixNode, buttonNodeController.state);
                    buttonNodeController.state = ((buttonNodeController.state === "y-fijo") ? "xy-fijo" : "x-fijo");
                } else {
                    buttonNodeController.state = ((buttonNodeController.state === "x-fijo") ? "xy-fijo" : "y-fijo");
                }
            }
        }

        //--------------------------------------------------

        nChecks = previousPointLoadValues.length / 3;

        for ( k = 0 ; k < nChecks; k++ ) {
            var currentPointLoad = previousPointLoadValues.splice(0,3);

            if (currentPointLoad[0] === (index + 1)) {
                if (currentPointLoad[1] === 1) {
                    heatTextField.text = currentPointLoad[2];
                } else {
                    heatTextField.text = currentPointLoad[2];
                }
            }
        }
    }
}
