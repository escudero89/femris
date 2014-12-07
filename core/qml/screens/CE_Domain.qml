import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../content"
import "../"

RowLayout {

    property variant jsonDomain : false

    id: rowParent
    objectName: "CE_Domain"

    spacing: 0

    LeftContentBox {
        id: leftContentRectangle

        color: Style.color.content_emphasized
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.20
    }

    Rectangle {

        Layout.fillHeight: true
        Layout.fillWidth: true

        color: "white"

        ColumnLayout {

            height: parent.height
            width: parent.width

            Flickable {

                id: flickableExamples

                Layout.preferredHeight: parent.height * 0.6

                flickableDirection: Flickable.HorizontalFlick

                Layout.fillWidth: true

                contentWidth: gridViewDomain.height * gridViewDomain.count
                clip: true

                GridView {

                    id: gridViewDomain

                    anchors.fill : parent

                    boundsBehavior: Flickable.StopAtBounds

                    cellWidth: height / 1.1
                    cellHeight: cellWidth

                    highlight: Rectangle {
                        color: Style.color.femris;
                        radius: 5
                        opacity: 0.03

                        z: 1000
                    }

                    focus: true

                    currentIndex: 0

                    delegate: Component {

                        Rectangle {
                            id: wrapper

                            width: gridViewDomain.cellWidth
                            height: gridViewDomain.height

                            color: 'transparent'

                            ColumnLayout {

                                height: parent.height
                                width: parent.width

                                Image {
                                    source: (name !== "empty") ? portrait : "qrc:/resources/images/square_shadow.png"

                                    Layout.preferredHeight: parent.height * 0.95
                                    Layout.preferredWidth: parent.width * 0.95
                                    Layout.alignment: Qt.AlignCenter

                                    fillMode: Image.PreserveAspectFit

                                    opacity: (gridViewDomain.currentIndex === index) ? 1 : 0.3
                                }

                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    gridViewDomain.fillSideLoadAndFixedNodes(index, exampleFile);
                                }

                                onDoubleClicked: {

                                    gridViewDomain.fillSideLoadAndFixedNodes(index, exampleFile);

                                    if (flickableExamples.Layout.preferredHeight !== flickableExamples.parent.height) {
                                        flickableExamples.contentX = gridViewDomain.currentIndex * gridViewDomain.cellWidth * (flickableExamples.parent.height / flickableExamples.Layout.preferredHeight);
                                        flickableExamples.Layout.preferredHeight = flickableExamples.parent.height;

                                    } else {
                                        flickableExamples.contentX = gridViewDomain.currentIndex * gridViewDomain.cellWidth * 0.6;
                                        flickableExamples.Layout.preferredHeight = flickableExamples.parent.height * 0.6;
                                    }

                                }

                                Connections {
                                    target: CurrentFileIO

                                    onError: {
                                        console.log(msg);
                                    }
                                }
                            }

                            Component.onCompleted: {
                                if (listModelExamples.count === 1) {
                                    gridViewDomain.fillExamples();
                                }

                                // We just load the conditions for the first component
                                if (index === gridViewDomain.currentIndex) {
                                    gridViewDomain.fillSideLoadAndFixedNodes(index, exampleFile);
                                }
                            }
                        }
                    }

                    model: ListModel {
                        id: listModelExamples

                        ListElement {
                            name: 'empty'
                            portrait: 'empty'
                            exampleFile: 'empty'
                        }
                    }

                    function fillExamples() {

                        listModelExamples.clear();
                        var examples = CurrentFileIO.getFilteredFilesFromDirectory(["example*.json"], 'docs/examples');

                        for ( var k = 1 ; k <= examples.length ; k++ ) {
                            var ex = examples[k - 1];
                            var newModel = {
                                "name": "Example " + k,
                                "portrait": fileApplicationDirPath + "/" + ex.substr(0, ex.search(".json")) + ".png",
                                "exampleFile": ex.substring(ex.search(/example\d/))
                            };

                            listModelExamples.append(newModel);

                            var exampleName = StudyCaseHandler.getSingleStudyCaseInformation("exampleName");
                            if (newModel.exampleFile === exampleName) {
                                currentIndex = k - 1;
                            }
                        }

                    }

                    function fillSideLoadAndFixedNodes(newIndex, exampleFile) {

                        gridViewDomain.currentIndex = newIndex;

                        CurrentFileIO.setSource(fileApplicationDirPath + '/docs/examples/' + exampleFile);

                        jsonDomain = CurrentFileIO.getVarFromJsonString(CurrentFileIO.read());

                        sideLoadContainer.objectRepeater.model = jsonDomain["sideloadNodes"].length
                        nodesContainer.objectRepeater.model = jsonDomain["coordinates"].length

                        sideLoadContainer.jsonDomain = jsonDomain;

                        StudyCaseHandler.setSingleStudyCaseInformation("exampleName", exampleFile);
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 3

                color: Style.color.complement
                opacity: 0.3
            }

            Rectangle {

                Layout.fillHeight: true
                Layout.fillWidth: true

                color: "transparent"

                GridLayout {

                    width: parent.width
                    height: parent.height

                    columns : 2
                    rows : 2

                    columnSpacing: 0

                    FlickableRepeaterNodesSideload {
                        id: sideLoadContainer

                        width: parent.width * 0.45
                    }

                    FlickableRepeaterNodes {
                        id: nodesContainer
                        jsonDomain: rowParent.jsonDomain

                        width: parent.width * 0.55
                    }
                }
            }

            RowLayout {

                spacing: 0
                Layout.fillWidth: true
                Layout.fillHeight: true

                PrimaryButton {
                    buttonLabel: "Vista General"
                    buttonStatus: "primary"
                    iconSource: "qrc:/resources/icons/four29.png"

                    onClicked : mainWindow.switchSection("CE_Overall")

                    Layout.fillWidth: true
                }

                PrimaryButton {
                    id: continueButton

                    buttonLabel: "Guardar y Continuar"
                    buttonStatus: "success"
                    iconSource: "qrc:/resources/icons/save8.png"

                    Layout.preferredWidth: 0.5 * parent.width

                    onClicked: {
                        rowParent.saveCurrentLoads();

                        ProcessHandler.setCommand("clear; cd temp; currentMatFemFile; cd ../scripts/MAT-fem; MATfemris");
                        ProcessHandler.callingProcess();
                    }
                }
            }
        }
    }

    AlertModal {
        id: imageModal
    }

    function saveCurrentLoads() {
        // First we adjust the coordinates usign the width and height set
        var maxCoord = {
            x : jsonDomain['coordinates'][0][0],
            y : jsonDomain['coordinates'][0][1]
        }

        var minCoord = {
            x :jsonDomain['coordinates'][0][0],
            y :jsonDomain['coordinates'][0][1]
        }

        var scaleFactor = {
            width  : StudyCaseHandler.getSingleStudyCaseInformation('gridWidth'),
            height : StudyCaseHandler.getSingleStudyCaseInformation('gridHeight')
        }

        scaleFactor.width = (scaleFactor.width !== '') ? parseFloat(scaleFactor.width) : 1;
        scaleFactor.height = (scaleFactor.height !== '') ? parseFloat(scaleFactor.height) : 1;

        // For normalizing
        for ( var k = 0 ; k < jsonDomain['coordinates'].length ; k++ ) {
            if (jsonDomain['coordinates'][k][0] > maxCoord.x) {
                maxCoord.x = jsonDomain['coordinates'][k][0];

            } else if (jsonDomain['coordinates'][k][0] < minCoord.x) {
                minCoord.x = jsonDomain['coordinates'][k][0];
            }

            if (jsonDomain['coordinates'][k][1] > maxCoord.y) {
                maxCoord.y = jsonDomain['coordinates'][k][1];

            } else if (jsonDomain['coordinates'][k][1] < minCoord.y) {
                minCoord.y = jsonDomain['coordinates'][k][1];
            }
        }

        var coordinates = jsonDomain['coordinates'];

        for ( var k = 0 ; k < coordinates.length ; k++ ) {
            coordinates[k][0] *= scaleFactor.width / ( maxCoord.x - minCoord.x );
            coordinates[k][1] *= scaleFactor.height / ( maxCoord.y - minCoord.y );
        }

        StudyCaseHandler.setSingleStudyCaseJson('coordinates', coordinates);

        StudyCaseHandler.setSingleStudyCaseJson('elements', jsonDomain['elements']);

        /// SIDELOAD

        var sideloadNodes = jsonDomain['sideloadNodes'];
        var sideload = [];

        for ( var k = 0 ; k < sideloadNodes.length ; k++ ) {
            var temp_x = StudyCaseHandler.getSingleStudyCaseInformation('sideloadx' + ( k + 1 ), true);
            var temp_y = StudyCaseHandler.getSingleStudyCaseInformation('sideloady' + ( k + 1 ), true);

            if (temp_x !== '' || temp_y !== '') {

                temp_x = (temp_x === '') ? 0.0 : parseFloat(temp_x);
                temp_y = (temp_y === '') ? 0.0 : parseFloat(temp_y);

                var N = sideloadNodes[k].length;
                for ( var j = 0 ; j < N - 1 ; j++ ) {
                    // The nodes from the edges only take 1/2 of the sideload. Instead,
                    // the nodes in between took the full sideload
                    if (j === 0 || j === N - 2) {
                        sideload.push([ sideloadNodes[k][j], sideloadNodes[k][j + 1], temp_x / 2.0, temp_y / 2.0 ]);
                    } else {
                        sideload.push([ sideloadNodes[k][j], sideloadNodes[k][j + 1], temp_x, temp_y ]);
                    }
                }
            }
        }

        console.log(sideload);

        StudyCaseHandler.setSingleStudyCaseJson('sideload', sideload);

        /// POINTLOAD & FIXNODES

        var pointload = [];
        var fixnodes = [];

        for ( k = 0 ; k < coordinates.length ; k++ ) {
            temp_x = StudyCaseHandler.getSingleStudyCaseInformation('pointloadx' + ( k + 1 ), true);
            temp_y = StudyCaseHandler.getSingleStudyCaseInformation('pointloady' + ( k + 1 ), true);

            if (temp_x !== '') {
                if (temp_x !== qsTr('fijado')) {
                    pointload.push([ k + 1, 1, parseFloat(temp_x) ]);

                } else {
                    fixnodes.push([ k + 1, 1, 0.0 ]);
                }
            }

            if (temp_y !== '') {
                if (temp_y !== qsTr('fijado')) {
                    pointload.push([ k + 1, 2, parseFloat(temp_y) ]);

                } else {
                    fixnodes.push([ k + 1, 2, 0.0 ]);
                }
            }
        }

        StudyCaseHandler.setSingleStudyCaseJson('fixnodes', fixnodes);
        StudyCaseHandler.setSingleStudyCaseJson('pointload', pointload);
    }
}
