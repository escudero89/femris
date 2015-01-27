import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../docs"
import "../content"
import "../"

RowLayout {

    property variant jsonDomain : null

    id: rowParent
    objectName: "CE_Domain"

    spacing: 0

    LeftContentBox {
        id: leftContentRectangle

        color: Style.color.content_emphasized
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.20

        parentStage : rowParent.objectName
    }

    Rectangle {

        Layout.fillHeight: true
        Layout.fillWidth: true

        color: "white"

        ColumnLayout {

            anchors.fill: parent

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
                                    id: exampleImage

                                    source: (name !== "empty") ? portrait : "qrc:/resources/images/square_shadow.png"

                                    Layout.preferredHeight: parent.height * 0.95
                                    Layout.preferredWidth: parent.width * 0.95
                                    Layout.alignment: Qt.AlignCenter

                                    fillMode: Image.PreserveAspectFit
                                    smooth: true

                                    opacity: (gridViewDomain.currentIndex === index) ? 1 : 0.3
                                    state: (gridViewDomain.currentIndex === index) ? "selected" : "default"

                                    Behavior on scale {
                                        NumberAnimation {}
                                    }

                                    states: [
                                        State {
                                            name: "selected"
                                            PropertyChanges {
                                                target : exampleImage
                                                scale : 1
                                            }
                                        },
                                        State {
                                            name: "default"
                                            PropertyChanges {
                                                target : exampleImage
                                                scale : 0.8
                                            }
                                        }
                                    ]
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
                                    //rowParent.saveCurrentLoads();
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
                        var examples = CurrentFileIO.getFilteredFilesFromDirectory(["example*.json"], applicationDirPath + '/docs/examples');

                        for ( var k = 1 ; k <= examples.length ; k++ ) {
                            var ex = examples[k - 1];
                            var newModel = {
                                "name": "Example " + k,
                                "portrait": fileApplicationDirPath + "/docs/examples/" + ex.substring(ex.search(/example\d/), ex.search(".json")) + ".png",
                                "exampleFile": ex.substring(ex.search(/example\d/))
                            };

                            listModelExamples.append(newModel);

                            if (StudyCaseHandler.checkSingleStudyCaseInformation("exampleName")) {
                                var exampleName = StudyCaseHandler.getSingleStudyCaseInformation("exampleName");
                                if (newModel.exampleFile === exampleName) {
                                    currentIndex = k - 1;
                                }
                            }
                        }

                    }

                    function fillSideLoadAndFixedNodes(newIndex, exampleFile) {

                        // Loading new data
                        gridViewDomain.currentIndex = newIndex;

                        CurrentFileIO.setSource(fileApplicationDirPath + '/docs/examples/' + exampleFile);

                        jsonDomain = CurrentFileIO.getVarFromJsonString(CurrentFileIO.read());

                        sideLoadContainer.objectRepeater.model = jsonDomain["sideloadNodes"].length;
                        nodesContainer.objectRepeater.model = jsonDomain["coordinates"].length;

                        sideLoadContainer.jsonDomain = jsonDomain;
                        nodesContainer.jsonDomain = jsonDomain;

                        if (StudyCaseHandler.checkSingleStudyCaseInformation("exampleName")) {
                            StudyCaseHandler.setSingleStudyCaseInformation("exampleName", exampleFile);
                        }

                        sideLoadContainer.objectRepeater.visible = true;
                        nodesContainer.objectRepeater.visible = true;
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 3

                color: Style.color.complement
                opacity: 0.3
            }

            GridLayout {

                property alias sideLoadContainer : sideLoadContainer
                property alias nodesContainer    : nodesContainer

                columns : StudyCaseHandler.isStudyType("heat") ? 1 : 2
                rows : 2

                columnSpacing: 0

                Layout.fillHeight: true
                Layout.preferredWidth : parent.width

                FlickableRepeaterNodesSideload {
                    id: sideLoadContainer

                    Layout.preferredWidth : parent.width / 2
                }

                FlickableRepeaterNodes {
                    id: nodesContainer
                    jsonDomain: rowParent.jsonDomain

                    Layout.preferredWidth : parent.width / 2

                    visible: !StudyCaseHandler.isStudyType("heat");
                }
            }

            RowLayout {

                spacing: 0
                Layout.fillWidth: true
                Layout.fillHeight: true

                PrimaryButton {

                    tooltip: qsTr("Abrir esta página en tu navegador por defecto")

                    buttonStatus: "femris"
                    buttonLabel: ""
                    iconSource: "qrc:/resources/icons/external2.png"

                    onClicked: {
                        StudyCaseHandler.loadUrlInBrowser(modelWebView.urlBase);
                    }

                }

                PrimaryButton {
                    buttonLabel: "Vista General"
                    buttonStatus: "primary"
                    iconSource: "qrc:/resources/icons/four29.png"

                    onClicked : mainWindow.switchSection("CE_Overall")

                    Layout.fillWidth: true
                }

                PrimaryButton {

                    property bool isReadyToCheckForFixnodes : false
                    property bool fixnodesReady : false

                    signal changedProperties()

                    id: continueButton

                    buttonLabel: "Guardar y Continuar"
                    buttonStatus: "success"
                    iconSource: "qrc:/resources/icons/save8.png"

                    Layout.preferredWidth: 0.5 * parent.width

                    enabled: false

                    onClicked: {
                        rowParent.saveCurrentLoads();
                        ProcessHandler.executeInterpreter(StudyCaseHandler.getSingleStudyCaseInformation("typeOfStudyCase"));
                    }

                    onChangedProperties: {
                        if (isReadyToCheckForFixnodes && fixnodesReady) {
                            enabled = true;
                        } else {
                            enabled = false;
                        }
                    }

                    Connections {
                        target : StudyCaseHandler

                        onReady: {
                            continueButton.isReadyToCheckForFixnodes = status;
                            continueButton.changedProperties();
                        }
                    }

                    Connections {
                        target: Configure

                        onMainSignalEmitted: {
                            if (signalName === "fixnodesChanged") {
                                rowParent.saveCurrentLoads();
                                StudyCaseHandler.isReady();
                            }
                        }
                    }

                    Component.onCompleted: StudyCaseHandler.isReady();
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

        // Only after we check the other validations, we check if the fixnodes are not empty
        // If that's the case, we are ready to go
        continueButton.fixnodesReady = (continueButton.isReadyToCheckForFixnodes && extraValues.fixnodes.length);
        continueButton.changedProperties();
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
            for ( var j = 0 ; j < N - 1 ; j++ ) {
                if (temp_state_ === "dirichlet") {
                    fixnodes.push([ k + 1, parseFloat(temp_) ]);
                } else {
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

    Connections {
        target: StudyCaseHandler

        onSavingCurrentStudyCase: {
            saveCurrentLoads();
        }
    }
}
