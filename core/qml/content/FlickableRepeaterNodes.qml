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

    Layout.fillHeight: true
    Layout.fillWidth: true

    FlickableRepeaterHeader {
        objectHeader.text :
            qsTr("Condiciones nodales") +
            "<br /><small style='color:" + Style.color.content + "'>" +
            "<em>" + qsTr("Número de nodos: ") + repeater.count + "</em></small>"

        Layout.fillHeight: true
        Layout.fillWidth: true
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
                    }

                    Component {
                        id: nodesHeatComponent
                        NodesHeat {}
                    }

                    Component {
                        id: nodesStructuralComponent
                        NodesStructural {}
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
