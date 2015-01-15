import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

import "components"

ColumnLayout {

    property alias objectRepeater: repeater

    property string textRow : "Nodo #"

    property string textInformation : "pointload"

    property variant jsonDomain : null

    FlickableRepeaterHeader {
        objectHeader.text :
            qsTr("Condiciones nodales") +
            "<br /><small style='color:" + Style.color.content + "'>" +
            "<em>" + qsTr("Número de nodos: ") + repeater.count + "</em></small>"

        Layout.fillHeight: true
        Layout.preferredWidth: parent.width
    }

    RowLayout {

        Layout.fillHeight: true
        Layout.preferredWidth: parent.width

        spacing: 0

        GridView {

            property variant previousFixNodesValues;
            property variant previousPointLoadValues;

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

            delegate: Component {

                Loader {
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
                        NodesHeat {
                            previousFixNodesValues: repeater.previousFixNodesValues;
                            previousPointLoadValues: repeater.previousPointLoadValues;
                        }
                    }

                    Component {
                        id: nodesStructuralComponent
                        NodesStructural {
                            previousFixNodesValues: repeater.previousFixNodesValues;
                            previousPointLoadValues: repeater.previousPointLoadValues;
                        }
                    }
                }
            }

            Component.onCompleted: {
                previousFixNodesValues = eval(StudyCaseHandler
                                              .getSingleStudyCaseInformation("fixnodes")
                                              .replace(/;/g, ",")
                                              .replace("],", "];")
                                              .replace("=", "")
                                              .replace("fixnodes", "")
                                              .trim());

                previousPointLoadValues = eval(StudyCaseHandler
                                               .getSingleStudyCaseInformation("pointload")
                                               .replace(/;/g, ",")
                                               .replace("],", "];")
                                               .replace("=", "")
                                               .replace("pointload", "")
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
