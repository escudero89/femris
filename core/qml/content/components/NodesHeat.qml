import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

Item {

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

            tooltip: qsTr("Click para seleccionar un tipo de condición de borde para éste nodo");

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

            enabled: buttonNodeController.isEnabled

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

    onLoadPreviousValues: {

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
