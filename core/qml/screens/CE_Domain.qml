import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../docs"
import "../content"
import "../"

import "../content/components"

Rectangle {
    id: rectangle1

    anchors.fill: parent

    gradient: Gradient {
        GradientStop { position: 0.0; color: Style.color.background_highlight }
        GradientStop { position: 1.0; color: Style.color.background }
    }

    Rectangle {
        id: rLoading

        width: 90
        height: 24
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20

        color: Style.color.complement

        z: 5000

        opacity: 0

        Text {
            id: tLoading

            text: qsTr("Cargando...")
            style: Text.Normal
            font.italic: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.pixelSize:12

            color: Style.color.background_highlight
        }

        Behavior on opacity { NumberAnimation { duration: 200 } }

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

                    // Sides
                    frnsRows.loading = true;
                    frnsRows.gvRows.clearModel();
                    frnsRows.gvRows.model = 0;
                    frnsRows.gvRows.model = rlDomain.jsonDomain["sideloadNodes"].length;

                    // Nodes
                    if (!StudyCaseHandler.isStudyType('heat')) {
                        frnRows.loading = true;
                        frnRows.gvRows.clearModel();
                        frnRows.gvRows.model = 0;
                        frnRows.gvRows.model = rlDomain.jsonDomain["coordinates"].length;
                    }

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
                        PropertyChanges { target: frnsRows;       visible: true; }
                        PropertyChanges { target: frnRows;       visible: !StudyCaseHandler.isStudyType('heat'); }
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

            RowLayout {

                Layout.fillWidth: true
                Layout.fillHeight: true

                FlickableRepeaterNodesSideload {

                    property bool loading : false

                    id: frnsRows

                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width

                    jsonDomain: rlDomain.jsonDomain

                    visible: false

                    onFinishedLoading: frnsRows.loading = false;

                }

                FlickableRepeaterNodes {

                    property bool loading : false

                    id: frnRows

                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width

                    jsonDomain: rlDomain.jsonDomain

                    visible: false

                    onFinishedLoading: frnRows.loading = false;

                }

                states: State {
                    name: "show"
                    when: frnRows.loading || frnsRows.loading
                    PropertyChanges { target: rLoading; opacity: 1 }
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

                    onClicked: {
                        rlDomain.saveCurrentLoads();

                        if (StudyCaseHandler.isReady()) {
                            ProcessHandler.executeInterpreter(StudyCaseHandler.getSingleStudyCaseInformation("typeOfStudyCase"));
                        }
                    }

                    Connections {

                        target : StudyCaseHandler

                        onFail: Configure.emitMainSignal(
                                    "setInfoBox",
                                    "<span style='color:" + Style.color.danger + "'>" +
                                    "<strong>No se puede procesar el Caso de Estudio:</strong> " +
                                    failedRuleMessage + ".");
                    }

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
