import QtQuick 2.4
import QtQuick.Layouts 1.1

import "../"

ColumnLayout {

    signal jsonDataLoaded(variant jsonData);
    id: rExamples

    ListView {

        id: lvExamples

        flickableDirection: Flickable.HorizontalFlick
        flickDeceleration: 150
        maximumFlickVelocity: 300

        clip: true
        orientation: ListView.Horizontal

        Layout.preferredHeight: parent.height
        Layout.preferredWidth: parent.width
        focus: true

        spacing: 5

        currentIndex: -1

        model: ListModel {
            id: lmExamples
        }

        delegate: Item {

            height: rExamples.height
            width: rExamples.height

            Rectangle {
                anchors.fill: parent
            }

            Image {
                anchors.margins: parent.width * 0.05

                anchors.fill: parent
                source: portrait

                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Rectangle {
                anchors.fill: parent
                opacity: 0.2

                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 1.0; color: Style.color.comment }
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    lvExamples.currentIndex = index
                    fillSideLoadAndFixedNodes(index, exampleFile);

                }
            }
        }

        highlight: Rectangle {
            height: parent.height; width: height;

            color: Style.color.femris
            opacity: 0.1

            z: 10000
        }

        header: Rectangle { width: 10; height: rExamples.height; color: Style.color.complement_highlight; }
        footer: Rectangle { width: 10; height: rExamples.height; color: Style.color.complement_highlight; }

        Component.onCompleted: {

            var examples = CurrentFileIO.getFilteredFilesFromDirectory(["example*.json"], applicationDirPath + '/docs/examples');

            lmExamples.clear();

            for ( var k = 1 ; k <= examples.length ; k++ ) {

                var ex = examples[k - 1];
                var newModel = {
                    "name": "Example " + k,
                    "portrait": fileApplicationDirPath + "/docs/examples/" + ex.substring(ex.search(/example\d/), ex.search(".json")) + ".png",
                    "exampleFile": ex.substring(ex.search(/example\d/))
                };

                lmExamples.append(newModel);
            }
        }

        // Only show the scrollbars when the view is moving.
        states: State {
            name: "ShowBars"
            when: lvExamples.movingHorizontally
            PropertyChanges { target: sbHorizontalExamples; opacity: 1 }
        }
    }

    // Attach scrollbars to the right of the view.
    ScrollBar {
        id: sbHorizontalExamples
        Layout.fillWidth: true
        Layout.preferredHeight: 6

        clip: true

        opacity: 0.1
        orientation: Qt.Horizontal
        position: lvExamples.visibleArea.xPosition
        pageSize: lvExamples.visibleArea.widthRatio

        Behavior on opacity { NumberAnimation {} }
    }

    function fillSideLoadAndFixedNodes(newIndex, exampleFile) {

        CurrentFileIO.setSource(fileApplicationDirPath + '/docs/examples/' + exampleFile);

        jsonDataLoaded(CurrentFileIO.getVarFromJsonString(CurrentFileIO.read()));

        if (StudyCaseHandler.checkSingleStudyCaseInformation("exampleName")) {
            StudyCaseHandler.setSingleStudyCaseInformation("exampleName", exampleFile);
        }

    }
}
