import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

Item {

    property variant jsonDomain;

    property int index : 0
    property int currentIndex : 0

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
            Layout.preferredWidth: parent.width * 0.3

            iconSource: "qrc:/resources/icons/black/" + fixnodeIcon + ".png"

            enabled: isEnabled

            tooltip: qsTr("Click para seleccionar un tipo de condición de borde para éste nodo");

            onClicked: {

                switch(buttonNodeController.state) {
                case "neumann"   : buttonNodeController.state = "dirichlet" ; break;
                case "dirichlet" : buttonNodeController.state = "neumann"   ; break;
                }

                rowModifiedCurrentIndex();
                StudyCaseHandler.setSingleStudyCaseInformation("condition-state" + (index + 1), buttonNodeController.state, true);
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

            onEditingFinished: StudyCaseHandler.setSingleStudyCaseInformation("pointload" + (index + 1), text, true);

            onFocusChanged: {
                if (focus === true && repeater.currentIndex !== index) {
                    rowModifiedCurrentIndex();
                    focus = true;
                }
            }
        }

    }

    Component.onCompleted: {

        var pointloadValue = StudyCaseHandler.getSingleStudyCaseInformation("pointload" + (index + 1), true);
        var stateValue     = StudyCaseHandler.getSingleStudyCaseInformation("condition-state" + (index + 1), true);

        if ( pointloadValue && pointloadValue !== "false" ) {
            heatTextField.text = pointloadValue;
        }

        if ( stateValue && stateValue !== "false" ) {
            buttonNodeController.state = stateValue;
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
