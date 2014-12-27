import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

RowLayout {

    property string fromWhere : ""

    Layout.fillWidth: true
    spacing: 0

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
            mainWindow.saveAndContinue(fromWhere);
        }

        visible: ( fromWhere !== "" )
    }

}
