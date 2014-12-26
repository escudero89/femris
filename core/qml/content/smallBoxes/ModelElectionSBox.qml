import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

TableView {

    id: tableViewModel

    anchors.fill: parent

    frameVisible: false
    backgroundVisible: false
    visible: false

    TableViewColumn {
        role: "title"
        title: qsTr("Modelo Físico")
        resizable: false
    }

    model: ListModel {
        id: listModelProblem
        ListElement{ title: "Transporte de calor"  ; soCalled: "heat" }

        ListElement{ title: "Tensión plana"        ; soCalled: "plane-stress" }
        ListElement{ title: "Deformación plana"    ; soCalled: "plane-strain" }
    }

    itemDelegate: Item {

        Text {
            id: textItem

            color: styleData.selected ? Style.color.background_highlight : Style.color.background
            elide: styleData.elideMode
            text: styleData.value
            font.pixelSize: 16

            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: styleData.textAlignment
            anchors.leftMargin: 12
            renderType: Text.NativeRendering

        }
    }

    headerDelegate: Rectangle {
        height: textItemHeader.implicitHeight * 1.4
        width: textItemHeader .implicitWidth
        color: Style.color.complement
        Text {
            id: textItemHeader

            text: styleData.value

            font.pixelSize: Style.fontSize.h5
            font.italic: true
            font.bold: true
            color: Style.color.background

            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            elide: Text.ElideRight
            renderType: Text.NativeRendering
        }
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 1
            anchors.topMargin: 1
            width: 1
            color: "#ccc"
        }
    }

    rowDelegate: Rectangle {
        height: 25
        width: tableViewModel.width
        color: styleData.selected ?
                   Style.color.femris :
                   styleData.alternate ?
                       Style.color.complement :
                       Style.color.complement_highlight
    }

    onVisibleChanged: {
        if (visible) {
            var currentSelection =
                    StudyCaseHandler.checkSingleStudyCaseInformation("typeOfStudyCase") ?
                        StudyCaseHandler.getSingleStudyCaseInformation("typeOfStudyCase") : false;

            if (currentSelection) {
                for ( var k = 0; k < listModelProblem.count; k++ ) {
                    if (listModelProblem.get(k).soCalled === currentSelection) {
                        tableViewModel.selection.select(k);
                    }
                }
            }
        }
    }

    onClicked: {
        StudyCaseHandler.selectNewTypeStudyCase(listModelProblem.get(row).soCalled);
    }

    onDoubleClicked: {
        StudyCaseHandler.selectNewTypeStudyCase(listModelProblem.get(row).soCalled);
        Configure.emitMainSignal("continueStep()");
    }
}
