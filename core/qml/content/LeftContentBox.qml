import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

import "smallBoxes"
import "components"

Rectangle {

    id: leftContentBox

    property int stepOfProcess : parseInt(StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess"));

    property string parentStage : parent.objectName

    property bool firstTimeOnly : false

    signal blockHiding(bool isHiding)

    ColumnLayout {

        id: columnLayout1

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        height : parent.height * 0.97
        width : parent.width * 0.9

        spacing: 10

        PropertiesAssignationSBox { visible : parentStage === 'CE_Domain'; }

        FirstTimeHere {
            parentStage : leftContentBox.parentStage

            Layout.fillHeight: true
            Layout.fillWidth: true

            Layout.alignment: Qt.AlignBottom
        }

    }
}
