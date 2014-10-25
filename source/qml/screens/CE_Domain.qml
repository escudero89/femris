import QtQuick 2.2
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

    ColumnLayout {

        Layout.fillHeight: true
        Layout.fillWidth: true

        spacing: 0

        Rectangle {

            Layout.fillHeight: true
            Layout.fillWidth: true

            GridView {

                property int z_index : z

                id: gridViewDomain

                anchors.fill : parent

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
                                console.log(index)
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

        RowLayout {

            spacing: 0
            Layout.preferredWidth: parent.width
            Layout.fillHeight: true

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

        }

        RowLayout {

            spacing: 0
            Layout.preferredWidth: parent.width
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
                    StudyCaseHandler.createNewStudyCase();
                    mainWindow.switchSection(StudyCaseHandler.saveAndContinue(parentStage));
                }
            }
        }
    }
}
