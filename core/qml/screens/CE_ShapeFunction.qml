import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebEngine 1.0

import "../docs"
import "../content"
import "../"

RowLayout {

    id: rowParent
    objectName: "CE_ShapeFunction"

    spacing: 0

    GridLayout {

        Layout.fillHeight: true
        Layout.fillWidth: true

        columnSpacing: 0
        rowSpacing: 0

        rows: 2
        columns: 3

        WebEngineView {
            id: currentWebView
            Layout.fillHeight: true
            Layout.fillWidth: true

            Layout.columnSpan: 3

            url: fileApplicationDirPath + "/docs/ce_shapefunction.html"
        }

        PrimaryButton {

            property string loadUrlBase : "docs/ce_shapefunction.html"
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
            buttonStatus: "success"
            iconSource: "qrc:/resources/icons/save8.png"

            Layout.fillWidth: true

            onClicked: {
                mainWindow.switchSection(StudyCaseHandler.saveAndContinue(rowParent.objectName));
            }
        }
    }
}

