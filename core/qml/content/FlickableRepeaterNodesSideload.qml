import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

import "smallBoxes"
import "components"

ColumnLayout {

    property alias objectRepeater: repeater

    property string textRow : "Lado "

    property string textInformation : "sideload"

    property variant jsonDomain : null

    FlickableRepeaterHeader {
        objectHeader.text :
            qsTr("Condiciones de borde") +
            "<br /><small style='color:" + Style.color.content + "'>" +
            "<em>" + qsTr("Número de lados: ") + repeater.count + "</em></small>"

        Layout.fillHeight: true
        Layout.preferredWidth: parent.width
    }

    RowLayout {

        Layout.fillHeight: true
        Layout.preferredWidth: parent.width

        spacing: 0

        GridView {

            property variant previousSideloadValues;
            property variant previousFixNodesValues;

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

            focus: true

            model: 0

            delegate: Item {

                property int index: model.index

                Component.onCompleted: {
                    if (StudyCaseHandler.isStudyType("heat")) {
                        nssRow.visible = false;

                        nshRow.visible = true;
                        nshRow.index = index
                        nshRow.loadPreviousValues();

                    } else {
                        nshRow.visible = false;

                        nssRow.visible = true;
                        nssRow.index = index
                        nssRow.loadPreviousValues();
                    }
                }

                NodesSideloadHeat {
                    id: nshRow
                    visible: true

                    previousFixNodesValues: repeater.previousFixNodesValues;
                    previousSideloadValues: repeater.previousSideloadValues;
                }

                NodesSideloadStructural {
                    id: nssRow
                    visible: false

                    previousSideloadValues: repeater.previousSideloadValues;
                }

            }
            /*
            delegate: Component {

                Loader {

                    property int index: model.index

                    asynchronous: true
                    sourceComponent : StudyCaseHandler.isStudyType("heat") ?
                                          nodesHeatComponent :
                                          nodesStructuralComponent

                    visible: status == Loader.Ready

                    onLoaded: {
                        item.index = index
                        item.loadPreviousValues();
                    }

                    Component {
                        id: nodesHeatComponent
                        NodesSideloadHeat {
                            previousFixNodesValues: repeater.previousFixNodesValues;
                            previousSideloadValues: repeater.previousSideloadValues;
                        }
                    }

                    Component {
                        id: nodesStructuralComponent
                        NodesSideloadStructural {
                            previousSideloadValues: repeater.previousSideloadValues;
                        }
                    }
                }
            }
*/
            Component.onCompleted: {
                previousSideloadValues = eval(StudyCaseHandler
                                              .getSingleStudyCaseInformation("sideload")
                                              .replace(/;/g, ",")
                                              .replace("],", "];")
                                              .replace("=", "")
                                              .replace("sideload", "")
                                              .trim());

                previousFixNodesValues = eval(StudyCaseHandler
                                              .getSingleStudyCaseInformation("fixnodes")
                                              .replace(/;/g, ",")
                                              .replace("],", "];")
                                              .replace("=", "")
                                              .replace("fixnodes", "")
                                              .trim());

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
