import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

ColumnLayout {

    property alias objectRepeater: repeater
    property alias objectHeader: textHeader

    property string textRow : "Nodo #"

    property string textInformation : "pointload"

    property variant jsonDomain : null

    Layout.fillHeight: true
    Layout.fillWidth: true

    Rectangle {
        id: rectangle1

        Layout.preferredHeight: textHeader.height * 1.1
        Layout.preferredWidth: parent.width

        color: Style.color.background_highlight

        Text {
            id: textHeader

            text: qsTr("Cargas puntuales y condiciones nodales") + "<br /><small style='color:" + Style.color.content + "'><em>" + qsTr("Número de nodos: ") + repeater.count + "</em></small>"
            textFormat: Text.RichText
            font.pointSize: Style.fontSize.h5

            anchors.left: parent.left
            anchors.leftMargin: 12
        }

    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 3

        color: Style.color.complement
        opacity: 0.3
    }

    RowLayout {

        Layout.fillHeight: true
        Layout.fillWidth: true

        spacing: 0

        GridView {

            id: repeater

            clip: true

            Layout.fillHeight: true
            Layout.fillWidth: true

            cellHeight: 40
            cellWidth: width;

            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds

            // Only show the scrollbars when the view is moving.
            states: State {
                name: "ShowBars"
                when: repeater.movingVertically
                PropertyChanges { target: verticalScrollBar; opacity: 1 }
            }

            transitions: Transition {
                NumberAnimation { properties: "opacity"; duration: 400 }
            }

            //highlight: Rectangle { color: Style.color.primary; opacity: 0.1; radius: 1; z: repeater.z }

            focus: true

            model: 0

            delegate: Item {

                id: cellContent

                width: repeater.cellWidth
                height: repeater.cellHeight

                Rectangle {
                    anchors.fill: parent

                    color: (index === repeater.currentIndex) ? Style.color.femris :
                                                               ((index % 2 === 0) ? Style.color.background_highlight :  Style.color.background) ;

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
                        property bool isEnabled : ( jsonDomain.sideloadNodes.join().search(index + 1) !== -1) ? true : false
                        property string fixnodeIcon : "open94"

                        id: buttonNodeController
                        Layout.preferredWidth: parent.width * 0.18
                        text: qsTr("libre")

                        iconSource: "qrc:/resources/icons/black/" + fixnodeIcon + ".png"

                        enabled: isEnabled

                        onClicked: {
                            switch(buttonNodeController.state) {
                            case "libre"  : buttonNodeController.state = "x-fijo" ; buttonNodeController.fixnodeIcon = "lock24"; break;
                            case "x-fijo" : buttonNodeController.state = "y-fijo" ; buttonNodeController.fixnodeIcon = "lock24"; break;
                            case "y-fijo" : buttonNodeController.state = "xy-fijo"; buttonNodeController.fixnodeIcon = "lock24"; break;
                            case "xy-fijo": buttonNodeController.state = "libre"  ; buttonNodeController.fixnodeIcon = "open94"; break;
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
                                }
                            },
                            State {
                                name: "x-fijo"
                                PropertyChanges {
                                    target: buttonNodeController
                                    text: qsTr("x-fijo")
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
                        placeholderText: "x_" + ( index + 1 )

                        onTextChanged: {
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
                        id: yTextField

                        Layout.preferredWidth: parent.width / 4
                        placeholderText: "y_" + ( index + 1 )

                        onTextChanged: {
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
                    var previousFixNodesValues = eval(StudyCaseHandler.getSingleStudyCaseInformation("fixnodes").replace(/;/g, ",").replace("],", "];").substr("fixnodes =".length));
                    var previousPointLoadValues = eval(StudyCaseHandler.getSingleStudyCaseInformation("pointload").replace(/;/g, ",").replace("],", "];").substr("pointload =".length));

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

                    for ( var k = 0 ; k < nChecks; k++ ) {
                        var currentPointLoad = previousPointLoadValues.splice(0,3);

                        if (currentPointLoad[0] === (index + 1)) {
                            if (currentPointLoad[1] === 1) {
                                xTextField.text = currentPointLoad[2];
                            } else {
                                yTextField.text = currentPointLoad[2];
                            }
                        }
                    }
                }
            }

        }

        // Attach scrollbars to the right of the view.
        ScrollBar {
            id: verticalScrollBar
            Layout.preferredWidth: 12
            Layout.preferredHeight: repeater.height - 12

            opacity: 0
            orientation: Qt.Vertical
            position: repeater.visibleArea.yPosition
            pageSize: repeater.visibleArea.heightRatio
        }
    }
}
