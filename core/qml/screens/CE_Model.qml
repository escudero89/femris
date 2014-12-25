import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

//import QtWebEngine 1.0
import QtWebKit 3.0

import "../docs"
import "../content"
import "../"

RowLayout {

    property string parentStage : objectName

    id: rowParent
    objectName: "CE_Model"

    spacing: 0

    LeftContentBox {
        id: leftContentRectangle

        color: Style.color.content_emphasized
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.20

        parentStage : "CE_Model"
    }

    GridLayout {

        Layout.fillHeight: true
        Layout.fillWidth: true

        columnSpacing: 0
        rowSpacing: 0

        rows: 2
        columns: 3

        WebView {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Layout.columnSpan: 3

            url: fileApplicationDirPath + "/docs/ce_model.html"
        }

        PrimaryButton {

            property string loadUrlBase : "docs/ce_model.html"
            tooltip: qsTr("Abrir esta página en tu navegador por defecto")

            buttonStatus: "femris"
            buttonLabel: ""
            iconSource: "qrc:/resources/icons/external2.png"

            onClicked: {
                StudyCaseHandler.loadUrlInBrowser(loadUrlBase, true);
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
            id: continueButton

            buttonLabel: "Guardar y Continuar"
            buttonStatus: "disabled"
            iconSource: "qrc:/resources/icons/save8.png"

            Layout.fillWidth: true

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
