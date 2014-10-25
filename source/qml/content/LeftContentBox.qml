import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

import "smallBoxes"

Rectangle {

    property int stepOfProcess : parseInt(StudyCaseHandler.getSingleStudyCaseInformation("stepOfProcess"));

    property string parentStage : parent.objectName

    ColumnLayout {

        id: columnLayout1

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        height : parent.height * 0.97
        width : parent.width * 0.9

        spacing: 0

        ModelElectionSBox { visible : { return parentStage === 'CE_Model' } }

        VariablesSBox { visible : { return parentStage === 'CE_DomainOriginal'; } }

        Rectangle {
            color: "transparent"
            Layout.preferredHeight: columnLayout1.height * 0.02
            Layout.fillWidth: true
        }

        FirstTimeBox {}
    }
}
