import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../"
import "../smallBoxes"
import "../"
import "."

RowLayout {

    property string fromWhere : ""
    property string urlBase   : ""

    property bool enableContinue : true

    Layout.fillWidth: true
    spacing: 0

    PrimaryButton {
        tooltip: qsTr("Abrir esta página en tu navegador por defecto")

        buttonStatus: "femris"
        buttonLabel: ""
        iconSource: "qrc:/resources/icons/external2.png"

        onClicked: {
            StudyCaseHandler.loadUrlInBrowser(urlBase);
        }

        visible: (urlBase.length > 0) ? true : false
    }

    PrimaryButton {
        buttonLabel: "Vista General"
        buttonStatus: "primary"
        iconSource: "qrc:/resources/icons/four29.png"

        onClicked : mainWindow.switchSection("CE_Overall")

        Layout.fillWidth: true
    }

    PrimaryButton {
        tooltip: qsTr("Exportar Caso de Estudio para GiD")

        buttonLabel: "Exportar"
        buttonStatus: "warning"
        iconSource: "qrc:/resources/icons/GiD.png"

        Layout.fillWidth: true

        onClicked: dialogs.exportAs.open();

        visible: ( fromWhere === "" )
    }

    PrimaryButton {
        buttonLabel: "Guardar y Continuar"
        buttonStatus: enableContinue ? "success" : "disabled"
        iconSource: "qrc:/resources/icons/save8.png"

        Layout.fillWidth: true

        onClicked: mainWindow.saveAndContinue(fromWhere);

        visible: ( fromWhere !== "" )
    }

}
