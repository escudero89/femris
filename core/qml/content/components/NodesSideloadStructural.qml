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

            Layout.minimumWidth: 30
            Layout.preferredWidth: parent.width * 0.05

            iconSource: "qrc:/resources/icons/black/" + fixnodeIcon + ".png"

            tooltip: qsTr("Click para resaltar los nodos que pertenecen a éste borde");

            onClicked: {
                switch(buttonNodeController.state) {
                case "show" : buttonNodeController.state = "hide" ; break;
                case "hide" : buttonNodeController.state = "show" ; break;
                }

                rowModifiedCurrentIndex();

                var changes = {
                    affectedNodes : jsonDomain["sideloadNodes"][index],
                    affectedIndex : index,
                    state : buttonNodeController.state
                };

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

            id: textFieldSideloadX

            Layout.preferredWidth: parent.width / 4
            placeholderText: "x_" + ( index + 1 ) + " [N/m]"

            onEditingFinished: StudyCaseHandler.setSingleStudyCaseInformation("sideloadx" + (index + 1), text, true);

            onFocusChanged: {
                if (focus === true && currentIndex !== index) {
                    rowModifiedCurrentIndex();
                    focus = true;
                }
            }
        }

        TextField {

            id: textFieldSideloadY

            Layout.preferredWidth: parent.width / 4
            placeholderText: "y_" + ( index + 1 ) + " [N/m]"

            onEditingFinished: StudyCaseHandler.setSingleStudyCaseInformation("sideloady" + (index + 1), text, true);

            onFocusChanged: {
                if (focus === true && currentIndex !== index) {
                    rowModifiedCurrentIndex();
                    focus = true;
                }
            }
        }

    }

    Component.onCompleted: {

        var sideloadValueX = StudyCaseHandler.getSingleStudyCaseInformation("sideloadx" + (index + 1), true);
        var sideloadValueY = StudyCaseHandler.getSingleStudyCaseInformation("sideloady" + (index + 1), true);

        if ( sideloadValueX ) {
            textFieldSideloadX.text = sideloadValueX;
        }

        if ( sideloadValueY ) {
            textFieldSideloadY.text = sideloadValueY;
        }
    }
}
