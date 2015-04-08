import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../docs"
import "../content"
import "../"

import "../content/components"

Rectangle {

    anchors.fill: parent

    gradient: Gradient {
        GradientStop { position: 0.0; color: Style.color.background_highlight }
        GradientStop { position: 1.0; color: Style.color.background }
    }

    RowLayout {

        property variant jsonDomain : {null}

        id: rlDomain
        objectName: "CE_Domain"

        anchors.fill: parent

        spacing: 0

        LeftContentBox {
            id: leftContentRectangle

            color: Style.color.content_emphasized
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.width * 0.20

            parentStage : rlDomain.objectName
        }

        onWidthChanged: clMainDomain.width = width * 0.80;

        ColumnLayout {

            id: clMainDomain

            Layout.preferredHeight: parent.height
            Layout.fillWidth: true

            Behavior on opacity { NumberAnimation {} }

            DomainExamples {
                id: deExamples

                Layout.fillWidth: true

                onJsonDataLoaded: {
                    rlDomain.jsonDomain = jsonData;

                    gvRows.clearModel();
                    gvRows.model = 0;
                    gvRows.model = rlDomain.jsonDomain["sideloadNodes"].length;

                    if (deExamples.state !== "normal") {
                        clMainDomain.opacity = 0;
                        tExamples.start();
                    }
                }

                Timer {
                    id: tExamples
                    interval: 500; running: false;
                    onTriggered: deExamples.state = "normal";

                }

                state: "maximized"

                states: [
                    State {
                        name: "maximized"

                        PropertyChanges {
                            target: deExamples
                            Layout.preferredHeight: clMainDomain.height * 0.8;
                        }
                    },
                    State {
                        name: "normal"

                        PropertyChanges {
                            target: deExamples
                            Layout.preferredHeight: clMainDomain.height * 0.6;
                        }

                        PropertyChanges { target: rTip;         visible: false; }
                        PropertyChanges { target: clRows;       visible: true; }
                        PropertyChanges { target: clMainDomain; opacity: 1.0 }
                    }
                ]

            }

            Rectangle {
                id: rTip

                Layout.preferredHeight: tTipHeader.height * 2
                Layout.preferredWidth: parent.width

                color: Style.color.info

                Text {
                    id: tTipHeader

                    textFormat: Text.RichText

                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Style.color.background_highlight

                    text: qsTr("<em>Para comenzar, seleccione uno de los dominios de ejemplo de la galería de arriba.</em>")
                }

            }

            ColumnLayout {

                id: clRows

                Layout.fillHeight: true
                Layout.preferredWidth: parent.width

                visible: false

                FlickableRepeaterHeader {
                    objectHeader.text :
                        qsTr("Condiciones de borde") +
                        "<br /><small style='color:" + Style.color.content + "'>" +
                        "<em>" + qsTr("Número de lados: ") + gvRows.count + "</em></small>"

                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width
                }

                RowLayout {

                    Layout.fillHeight: true
                    Layout.preferredWidth: clMainDomain.width

                    GridView {

                        property variant previousSideloadValues;
                        property variant previousFixNodesValues;

                        signal clearModel();

                        id: gvRows

                        clip: true

                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width

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

                                    "previousSideloadValues": gvRows.previousSideloadValues,
                                    "previousFixNodesValues": gvRows.previousFixNodesValues,

                                    "jsonDomain": rlDomain.jsonDomain,

                                    "index": index,
                                    "currentIndex": gvRows.currentIndex,
                                    "onRowModifiedCurrentIndex": gvRows.currentIndex = index
                                };

                                var component = Qt.createComponent("../content/components/NodesSideloadHeat.qml");
                                objectRow = component.createObject(iRow, params);

                            }

                            Connections {
                                target: gvRows
                                onClearModel: objectRow.destroy();
                                onWidthChanged: width = gvRows.width;
                            }

                        }


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
                        id: sbRows
                        Layout.preferredWidth: 12
                        Layout.preferredHeight: gvRows.height - 12

                        opacity: 0
                        orientation: Qt.Vertical
                        position: gvRows.visibleArea.yPosition
                        pageSize: gvRows.visibleArea.heightRatio
                    }
                }
            }


            RowLayout {

                Layout.fillWidth: true
                Layout.fillHeight: true

                Layout.alignment: Qt.AlignBottom

                spacing: 0

                PrimaryButton {

                    tooltip: qsTr("Abrir el repaso de funciones de forma en tu navegador por defecto")

                    buttonStatus: "femris"
                    buttonLabel: ""
                    iconSource: "qrc:/resources/icons/stats1.png"

                    onClicked: globalInfoBox.loadUrlInBrowser("docs/ce_shapefunction.html", true);

                }

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

                    Layout.fillWidth: true

                    enabled: false

                    onClicked: {
                        rlDomain.saveCurrentLoads();
                        ProcessHandler.executeInterpreter(StudyCaseHandler.getSingleStudyCaseInformation("typeOfStudyCase"));
                    }

                    Connections {

                        target : StudyCaseHandler

                        onBeforeCheckIfReady: rlDomain.saveCurrentLoads();
                        onReady: continueButton.enabled = status;
                    }

                    Component.onCompleted: StudyCaseHandler.isReady();
                }
            }
        }

        function saveCurrentLoads() {

            // If jsonDomain is empty, we leave
            if (!jsonDomain) {
                return;
            }

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

            for ( k = 0 ; k < coordinates.length ; k++ ) {
                coordinates[k][0] *= scaleFactor.width / ( maxCoord.x - minCoord.x );
                coordinates[k][1] *= scaleFactor.height / ( maxCoord.y - minCoord.y );
            }

            // Then we set the sideload, pointload and fixnodes according to the type of study case
            var extraValues = {
                fixnodes : [],
                sideload : [],
                pointload : []
            };

            if (StudyCaseHandler.isStudyType("heat")) {
                extraValues = saveCurrentLoadsHeat(coordinates);
            } else {
                extraValues = saveCurrentLoadsStructural(coordinates);
            }

            // And finally we save all the values
            StudyCaseHandler.setSingleStudyCaseJson('coordinates', coordinates);
            StudyCaseHandler.setSingleStudyCaseJson('elements', jsonDomain['elements']);
            StudyCaseHandler.setSingleStudyCaseJson('sideload',  extraValues.sideload );
            StudyCaseHandler.setSingleStudyCaseJson('fixnodes',  extraValues.fixnodes );
            StudyCaseHandler.setSingleStudyCaseJson('pointload', extraValues.pointload);
        }

        function saveCurrentLoadsHeat(coordinates) {

            /// SIDELOAD (neumann) & FIXNODES (dirichet)

            var sideloadNodes = jsonDomain['sideloadNodes'];
            var sideload = [];
            var fixnodes = [];

            for ( var k = 0 ; k < sideloadNodes.length ; k++ ) {
                var temp_ = StudyCaseHandler.getSingleStudyCaseInformation('sideload' + ( k + 1 ), true);
                var temp_state_ = StudyCaseHandler.getSingleStudyCaseInformation('condition-state' + ( k + 1 ), true);

                if (temp_ === '') {
                    continue;
                }

                temp_ = parseFloat(temp_);

                var N = sideloadNodes[k].length;
                if (temp_state_ === "dirichlet") {
                    for ( var j = 0 ; j < N ; j++ ) {
                        fixnodes.push([ sideloadNodes[k][j], parseFloat(temp_) ]);
                    }

                } else {
                    for ( var j = 0 ; j < N - 1 ; j++ ) {
                        sideload.push([ sideloadNodes[k][j], sideloadNodes[k][j + 1], temp_ ]);
                    }
                }
            }

            return {
                fixnodes : fixnodes,
                sideload : sideload,
                pointload: []
            };
        }

        function saveCurrentLoadsStructural(coordinates) {

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

            return {
                fixnodes : fixnodes,
                sideload : sideload,
                pointload : pointload
            };
        }
    }

    Connections {
        target: StudyCaseHandler

        onSavingCurrentStudyCase: {
            rlDomain.saveCurrentLoads();
        }
    }

}
