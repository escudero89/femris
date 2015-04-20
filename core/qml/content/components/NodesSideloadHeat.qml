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
            text: qsTr("Lado [" + tooltip.text + "]")

            MyToolTip {
                id: tooltip

                text: (!jsonDomain["sideloadNodes"]) ?
                          "" :
                          (!jsonDomain["sideloadNodes"][index]) ?
                              "" :
                              jsonDomain["sideloadNodes"][index].join(', ');

                z: cellContent.z + 100
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: tooltip.show()
                onExited: tooltip.hide()
            }
        }

        Button {

            property string fixnodeIcon : "filter10"

            id: buttonNodeController

            Layout.preferredWidth: parent.width * 0.3

            iconSource: "qrc:/resources/icons/black/" + fixnodeIcon + ".png"

            tooltip: qsTr("Click para seleccionar un tipo de condición de borde para éste lado");

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
                        target: textFieldSideload
                        textColor: Style.color.femris
                    }
                }
            ]

            Component.onCompleted: StudyCaseHandler.setSingleStudyCaseInformation("condition-state" + (index + 1), buttonNodeController.state, true)
        }


        TextField {

            id: textFieldSideload

            Layout.preferredWidth: parent.width * 0.4
            placeholderText: (buttonNodeController.state === "dirichlet") ? "[ºC]" : "[W/m]"

            onEditingFinished: StudyCaseHandler.setSingleStudyCaseInformation("sideload" + (index + 1), text, true);

            onFocusChanged: {
                if (focus === true && currentIndex !== index) {
                    rowModifiedCurrentIndex();
                    focus = true;
                }
            }
        }
    }

    Component.onCompleted: {

        var sideloadValue = StudyCaseHandler.getSingleStudyCaseInformation("sideload" + (index + 1), true);
        var stateValue    = StudyCaseHandler.getSingleStudyCaseInformation("condition-state" + (index + 1), true);

        if ( sideloadValue && sideloadValue !== "false" ) {
            textFieldSideload.text = sideloadValue;
        }

        if ( stateValue && stateValue !== "false" ) {
            buttonNodeController.state = stateValue;
        }
    }
}
