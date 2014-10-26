import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../content"
import "../"

RowLayout {

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
                        //   id: contactsDelegate

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
                                    gridViewDomain.currentIndex = index
                                    console.log(index);
                                    CurrentFileIO.setSource(':/resources/examples/example1.m');
                                    var json = CurrentFileIO.read();
                                    //console.log(json);
                                    var ehmp = CurrentFileIO.getVarFromJsonString(json);
                                    console.log(ehmp["_comment"]);

                                    var keys=[];
                                    for(var k in ehmp) keys.push(k);

                                    console.log("total " + keys.length + " keys: " + keys);
                                }

                                Connections {
                                    target: CurrentFileIO

                                    onError: {
                                        console.log(msg);
                                    }
                                }
                            }
                        }
                    }

                    model: ListModel {

                        ListElement {
                            name: "Example 1"
                            portrait: "qrc:/resources/examples/example1.png"
                        }
                        ListElement {
                            name: "Example 2"
                            portrait: "qrc:/resources/examples/example2.png"
                        }
                    }
                }
            }

            Rectangle {

                Layout.fillHeight: true
                Layout.fillWidth: true

                color: Style.color.background

                GridLayout {

                    width: parent.width
                    height: parent.height

                    columns : 2
                    rows : 2

                    RowLayout {

                        Layout.columnSpan: 2

                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Repeater {

                            model: ["Ancho", "Alto"]

                            delegate: RowLayout {

                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Text {
                                    text: qsTr(modelData)
                                }

                                TextField {
                                    text: "Text"
                                }
                            }
                        }

                    }

                    ColumnLayout {

                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Text {
                            text: qsTr("Sideloads")

                            font.pointSize: Style.fontSize.h4
                        }

                        Flickable {

                            id: flickable

                            clip: true

                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            contentWidth: flickable.width
                            contentHeight: 40 * repeater.model

                            onMovementStarted: Style.color.complement
                            onMovementEnded: Style.color.background

                            flickableDirection: Flickable.VerticalFlick
                            boundsBehavior: Flickable.StopAtBounds

                            ColumnLayout {

                                height: flickable.contentHeight
                                width: flickable.contentWidth

                                spacing: 0

                                Repeater {

                                    id: repeater

                                    model: 30

                                    delegate: Rectangle {

                                        anchors.horizontalCenter: parent.horizontalCenter

                                        Layout.preferredHeight: 40
                                        Layout.preferredWidth: flickable.contentWidth

                                        color: (index % 2 === 0) ? Style.color.background_highlight :  Style.color.background;

                                        RowLayout {

                                            anchors.horizontalCenter: parent.horizontalCenter
                                            height: parent.height
                                            width: parent.width * .95

                                            spacing: 0

                                            Text {
                                                Layout.fillWidth: true
                                                text: index + 1
                                            }

                                            TextField {
                                                id: variablesTextField

                                                Layout.preferredWidth: parent.width / 2
                                                placeholderText: index
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Text {
                            text: qsTr("Sideloads")

                            font.pointSize: Style.fontSize.h4
                        }

                        Flickable {

                            id: flickable2

                            clip: true

                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            contentWidth: flickable2.width
                            contentHeight: 40 * repeater2.model

                            onMovementStarted: Style.color.complement
                            onMovementEnded: Style.color.background

                            flickableDirection: Flickable.VerticalFlick
                            boundsBehavior: Flickable.StopAtBounds

                            ColumnLayout {

                                height: flickable2.contentHeight
                                width: flickable2.contentWidth

                                spacing: 0

                                Repeater {

                                    id: repeater2

                                    model: 30

                                    delegate: Rectangle {

                                        anchors.horizontalCenter: parent.horizontalCenter

                                        Layout.preferredHeight: 40
                                        Layout.preferredWidth: flickable2.contentWidth

                                        color: (index % 2 === 0) ? Style.color.background_highlight :  Style.color.background;

                                        RowLayout {

                                            anchors.horizontalCenter: parent.horizontalCenter
                                            height: parent.height
                                            width: parent.width * .95

                                            spacing: 0

                                            Text {
                                                Layout.fillWidth: true
                                                text: index + 1
                                            }

                                            TextField {
                                                Layout.preferredWidth: parent.width / 2
                                                placeholderText: index
                                            }
                                        }
                                    }
                                }
                            }
                        }
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
                    buttonStatus: "disabled"
                    buttonText.font.pixelSize: height / 2

                    Layout.preferredWidth: 0.6 * parent.width

                    Connections {
                        target: StudyCaseHandler

                        onNewStudyCaseChose: {
                            continueButton.buttonStatus = "success";
                        }
                    }

                    onClicked: {
                        //StudyCaseHandler.createNewStudyCase();
                        mainWindow.switchSection(StudyCaseHandler.saveAndContinue(parentStage));
                    }
                }
            }
        }
    }
}
