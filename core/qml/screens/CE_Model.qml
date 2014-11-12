import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../content"
import "../"

RowLayout {

    id: rowParent
    objectName: "CE_Model"
    property string parentStage : objectName

    spacing: 0
    anchors.fill: globalLoader

    LeftContentBox {
        id: leftContentRectangle

        color: Style.color.content_emphasized
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.20
    }

    ColumnLayout {

        spacing: 0

        WebView {
            id: currentWebView

            Layout.fillHeight: true
            Layout.fillWidth: true

            onLinkHovered: console.log(hoveredUrl)
            url: fileApplicationDirPath + "/docs/view/soon/index.html"
        }

        RowLayout {

            spacing: 0
            Layout.fillHeight: true
            Layout.fillWidth: true

            PrimaryButton {

                property string loadUrlBase : "docs/view/soon/index.html"
                tooltip: qsTr("Abrir esta página en tu navegador por defecto")

                buttonStatus: "femris"
                buttonLabel: ""

                Layout.preferredWidth: 0.1 * parent.width

                onClicked: {
                    StudyCaseHandler.loadUrlInBrowser(loadUrlBase);
                }

                iconSource: "qrc:/resources/icons/external2.png"
            }

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
                buttonStatus: "disabled"
                //buttonText.font.pixelSize: height / 2

                Layout.preferredWidth: 0.5 * parent.width

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
