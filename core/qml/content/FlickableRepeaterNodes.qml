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

    property int amountOfLoadedElements : 0
    property variant jsonDomain : null

    property alias gvRows: gvRows

    signal finishedLoading()

    id: clRows

    FlickableRepeaterHeader {
        objectHeader.text :
            qsTr("Restricciones nodales") +
            "<br /><small style='color:" + Style.color.content + "'>" +
            "<em>" + qsTr("Número de nodos: ") + gvRows.count + "</em></small>"

        Layout.fillHeight: true
        Layout.preferredWidth: parent.width
    }

    RowLayout {

        Layout.fillHeight: true
        Layout.preferredWidth: clRows.width

        GridView {

            signal clearModel();

            id: gvRows

            clip: true

            Layout.fillHeight: true
            Layout.preferredWidth: parent.width - sbRows.width

            cellHeight: 40
            cellWidth: width;

            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds

            // Only show the scrollbars when the view is moving.
            states: State {
                name: "ShowBars"
                when: gvRows.movingVertically
                PropertyChanges { target: sbRows; opacity: 1 }
            }

            transitions: Transition {
                NumberAnimation { properties: "opacity"; duration: 400 }
            }

            highlight: Rectangle {
                height : gvRows.cellHeight
                width: gvRows.width
                color: Style.color.femris

                opacity: 0.4
            }

            focus: true

            model: 0

            delegate: RowLayout {

                id: iRow

                property variant objectRow;

                height : gvRows.cellHeight
                width: gvRows.cellWidth

                Component.onCompleted: {

                    var params = {
                        "Layout.preferredHeight": gvRows.cellHeight,
                        "Layout.fillWidth": true,

                        "previousPointLoadValues": gvRows.previousPointLoadValues,
                        "previousFixNodesValues": gvRows.previousFixNodesValues,

                        "jsonDomain": clRows.jsonDomain,

                        "index": index,
                        "currentIndex": gvRows.currentIndex
                    };

                    var componentFile = "";

                    // Check which file to load
                    if ( StudyCaseHandler.isStudyType('heat') ) {
                        componentFile = "../content/components/NodesHeat.qml";
                    } else {
                        componentFile = "../content/components/NodesStructural.qml";
                    }

                    var component = Qt.createComponent(componentFile);
                    objectRow = component.createObject(iRow, params);

                    // Connects with the signal in the object
                    objectRow.rowModifiedCurrentIndex.connect(function() {
                        gvRows.currentIndex = index;
                    });

                    // For notifying loading
                    clRows.amountOfLoadedElements++;

                }

                Connections {
                    target: gvRows
                    onClearModel: { objectRow.destroy(); }
                    onWidthChanged: width = gvRows.width;
                }

            }
        }

        // Attach scrollbars to the right of the view.
        ScrollBar {
            id: sbRows
            Layout.preferredWidth: 12
            Layout.preferredHeight: gvRows.height - 12

            opacity: 0
            orientation: Qt.Vertical
            position: gvRows.visibleArea.yPosition
            pageSize: gvRows.visibleArea.heightRatio
        }
    }

    onAmountOfLoadedElementsChanged: {
        if ( gvRows.count > 0 && gvRows.count === amountOfLoadedElements ) {
            finishedLoading();
            amountOfLoadedElements = 0;
        }
    }
}
