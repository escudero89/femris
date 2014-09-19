import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import QtQuick.Dialogs 1.2

import "../"
import "../content"

RowLayout {

    id: parentLayout

    signal peroqueboludo (string msg)

    anchors.fill: parent

    anchors.topMargin: parent.width / 40 ; anchors.bottomMargin: parent.width / 40
    anchors.leftMargin: parent.width / 20 ; anchors.rightMargin: parent.width / 20

    ColumnLayout {

        id: columnLayout

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Layout.maximumWidth: 900
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 0

        RowLayout {

            spacing: 10

            ChoiceBlock {
                header: "TUTORIAL"
                buttonLabel: "Iniciar"
            }

            ChoiceBlock {
                header: "NUEVO"
                buttonLabel: "Crear"
            }

            ChoiceBlock {
                header: "ABRIR"
                buttonLabel: "Cargar"
            }

        }

    }
}
