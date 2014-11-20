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
    anchors.fill: globalLoader

    LeftContentBox {
        id: leftContentRectangle

        color: Style.color.content_emphasized
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.20
    }

    Rectangle {

        Layout.fillHeight: true
        Layout.fillWidth: true

        ColumnLayout {

            height: parent.height
            width: parent.width

            Flickable {
                flickableDirection: Flickable.HorizontalFlick

                Layout.fillHeight: true
                Layout.fillWidth: true

                contentWidth: gridViewDomain.height * gridViewDomain.count
                clip: true

                //color: Style.color.comment

                //contentHeight: height
                //contentWidth: GridView.currentItem.width

                GridView {

                    id: gridViewDomain

                    anchors.fill : parent

                    boundsBehavior: Flickable.StopAtBounds

                    cellWidth: height / 1.1
                    cellHeight: cellWidth

                    highlight: Rectangle {
                        color: Style.color.background;
                        radius: 5;
                    }

                    focus: true

                    currentIndex: (StudyCaseHandler.getSingleStudyCaseInformation("example_index", true) !== "") ? StudyCaseHandler.getSingleStudyCaseInformation("example_index", true) : 0

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
                                    source: portrait

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

                                Connections {
                                    target: CurrentFileIO

                                    onError: {
                                        console.log(msg);
                                    }
                                }
                            }

                            Component.onCompleted: {
                                // We just load the conditions for the first component
                                if (index === gridViewDomain.currentIndex) {
                                    gridViewDomain.fillSideLoadAndFixedNodes(index, exampleFile);
                                }
                            }
                        }
                    }

                    model: ListModel {

                        ListElement {
                            name: "Example 1"
                            portrait: "qrc:/resources/examples/example1.png"
                            exampleFile: "example1.json"
                        }
                        ListElement {
                            name: "Example 2"
                            portrait: "qrc:/resources/examples/example2.png"
                            exampleFile: "example2.json"
                        }
                        ListElement {
                            name: "Example 3"
                            portrait: "qrc:/resources/examples/example3.png"
                            exampleFile: "example3.json"
                        }
                        ListElement {
                            name: "Example 4"
                            portrait: "qrc:/resources/examples/example4.png"
                            exampleFile: "example4.json"
                        }
                    }

                    function fillSideLoadAndFixedNodes(newIndex, exampleFile) {

                        gridViewDomain.currentIndex = newIndex;

                        CurrentFileIO.setSource(':/resources/examples/' + exampleFile);

                        jsonDomain = CurrentFileIO.getVarFromJsonString(CurrentFileIO.read());

                        sideLoadContainer.objectRepeater.model = jsonDomain["sideloadNodes"].length
                        nodesContainer.objectRepeater.model = jsonDomain["coordinates"].length

                        sideLoadContainer.jsonDomain = jsonDomain;

                        StudyCaseHandler.setSingleStudyCaseInformation("example_index", newIndex, true);
                    }
                }
            }

            Rectangle {

                Layout.fillHeight: true
                Layout.fillWidth: true

                color: Style.color.background_highlight

                GridLayout {

                    width: parent.width
                    height: parent.height

                    columns : 2
                    rows : 2

                    FlickableRepeaterNodesSideload {
                        id: sideLoadContainer

                        objectHeader.text: qsTr("Condiciones de borde")
                        textRow: "Lado #"

                        textInformation: "sideload"
                    }

                    FlickableRepeaterNodes {
                        id: nodesContainer

                        objectHeader.text: qsTr("Cargas puntuales y fijas")
                        textRow: "Nodo #"

                        textInformation: "pointload"
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
                    //buttonText.font.pixelSize: height / 2

                    onClicked : mainWindow.switchSection("CE_Overall")

                    Layout.fillWidth: true
                }

                PrimaryButton {
                    id: continueButton

                    buttonLabel: "Guardar y Continuar"
                    buttonStatus: "success"
                    //buttonText.font.pixelSize: height / 2

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
