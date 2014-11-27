import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

TableView {

    id: tableViewModel

    Layout.fillWidth: true
    Layout.fillHeight: true

    visible: false

    TableViewColumn {
        role: "title"
        title: qsTr("Modelo Físico")
        resizable: false
    }

    model: ListModel {
        id: listModelProblem
      //  ListElement{ title: "Transporte de calor" ; soCalled: "heat" }
        ListElement{ title: "Tensión plana"        ; soCalled: "plane-stress" }
        ListElement{ title: "Deformación plana"    ; soCalled: "plane-strain" }
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
        var studyCaseType = listModelProblem.get(row).soCalled;
        StudyCaseHandler.selectNewTypeStudyCase(studyCaseType);
    }
}
