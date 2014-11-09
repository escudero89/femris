import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."
import "smallBoxes"

ColumnLayout {

    property alias objectRepeater: repeater
    property alias objectHeader: textHeader

    property string textRow : "Lado #"

    property string textInformation : "sideload"

    property variant jsonDomain : false

    Layout.fillHeight: true
    Layout.fillWidth: true

    Text {
        id: textHeader

        text: qsTr("Condiciones de borde")

        font.pointSize: Style.fontSize.h5
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

            //highlight: Rectangle { color: Style.color.primary; opacity: 0.1; radius: 1 }

            focus: true

            model: 0

            delegate: Item {

                id: cellContent

                width: repeater.cellWidth
                height: repeater.cellHeight

                Rectangle {
                    anchors.fill: parent

                    color: (index === repeater.currentIndex) ? Style.color.primary :
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

                        MyToolTip {
                            id: tooltip

                            text: (!jsonDomain["sideloadNodes"]) ? "" :
                                      (!jsonDomain["sideloadNodes"][index]) ? "" :
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

                    TextField {
                        Layout.preferredWidth: parent.width / 3
                        placeholderText: "x_" + ( index + 1 )

                        onEditingFinished: {
                            StudyCaseHandler.setSingleStudyCaseInformation(textInformation + "x" + (index + 1), text, true);
                        }

                        onAccepted: {
                            console.log("asd")
                        }

                        onFocusChanged: {
                            if (focus === true && repeater.currentIndex !== index) {
                                repeater.currentIndex = index;
                                focus = true;
                            }
                        }
                    }

                    TextField {
                        Layout.preferredWidth: parent.width / 3
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
