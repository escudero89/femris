import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

TableView {

    Layout.fillWidth: true
    Layout.fillHeight: true

    TableViewColumn {
        role: "title"
        title: qsTr("Modelo Físico")
        resizable: false
    }

    model: ListModel {
        id: listModelProblem
      //  ListElement{ title: "Transporte de calor" ; soCalled: "heat" }
        ListElement{ title: "Tensión plana"   ; soCalled: "plain-stress" }
        ListElement{ title: "Deformación plana"    ; soCalled: "plain-strain" }
    }

    onClicked: {
        var studyCaseType = listModelProblem.get(row).soCalled;
        StudyCaseHandler.selectNewTypeStudyCase(studyCaseType);
    }
}
