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

            Rectangle {

                Layout.fillHeight: true
                Layout.fillWidth: true

                GridView {

                    id: gridViewDomain

                    anchors.fill : parent

                    boundsBehavior: Flickable.StopAtBounds

                    cellWidth: width / 2

                    highlight: Rectangle {
                        color: "lightsteelblue";
                        radius: 5;
                    }

                    focus: true

                    delegate: Component {

                        Rectangle {
                            id: wrapper

                            width: gridViewDomain.cellWidth
                            height: gridViewDomain.height

                            color: 'transparent'

                            ColumnLayout {

                                height: parent.height
                                width: parent.width

                                Text {
                                    id: contactInfo
                                    text: name
                                    color: GridView.isCurrentItem ? "red" : "black"
                                }

                                Image {
                                    source: portrait

                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    fillMode: Image.PreserveAspectFit
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
                                if (index === 0) {
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
                    }

                    function fillSideLoadAndFixedNodes(index, exampleFile) {

                        gridViewDomain.currentIndex = index;
                        console.log(index);
                        CurrentFileIO.setSource(':/resources/examples/' + exampleFile);

                        jsonDomain = CurrentFileIO.getVarFromJsonString(CurrentFileIO.read());

                        sideLoadContainer.objectRepeater.model = jsonDomain["sideloadNodes"].length
                        nodesContainer.objectRepeater.model = jsonDomain["coordinates"].length
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

                    FlickableRepeaterNodes {
                        id: sideLoadContainer

                        objectHeader.text: qsTr("Condiciones de borde")
                        textRow: "Lado #"
                    }

                    FlickableRepeaterNodes {
                        id: nodesContainer

                        objectHeader.text: qsTr("Cargas puntuales y fijas")
                        textRow: "Nodo #"
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
                    buttonText.font.pixelSize: height / 2

                    onClicked : mainWindow.switchSection("CE_Overall")

                    Layout.fillWidth: true
                }

                PrimaryButton {
                    id: continueButton

                    buttonLabel: "Guardar y Continuar"
                    buttonStatus: "success"
                    buttonText.font.pixelSize: height / 2

                    Layout.preferredWidth: 0.6 * parent.width
/*
                    Connections {
                        target: StudyCaseHandler

                        onNewStudyCaseChose: {
                            continueButton.buttonStatus = "success";
                        }
                    }*/

                    onClicked: {
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
                            width  : StudyCaseHandler.getSingleStudyCaseInformation('width', true),
                            height : StudyCaseHandler.getSingleStudyCaseInformation('height', true)
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

                            if (jsonDomain['coordinates'][k][0] > maxCoord.y) {
                                maxCoord.y = jsonDomain['coordinates'][k][1];

                            } else if (jsonDomain['coordinates'][k][0] < minCoord.y) {
                                minCoord.y = jsonDomain['coordinates'][k][1];
                            }
                        }

                        var coordinates = jsonDomain['coordinates'];

                        for ( var k = 0 ; k < coordinates.length ; k++ ) {
                            coordinates[k][0] *= scaleFactor.width / ( maxCoord.x - minCoord.x );
                            coordinates[k][1] *= scaleFactor.height / ( maxCoord.y - minCoord.y );
                        }

                        StudyCaseHandler.setSingleStudyCaseInformation('coordinates', coordinates);

                        //mainWindow.switchSection(StudyCaseHandler.saveAndContinue(parentStage));
                    }
                }
            }
        }
    }
}
