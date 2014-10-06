import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

TableView {

    Layout.fillHeight: true
    Layout.fillWidth: true

    TableViewColumn {
        role: "title"
        title: qsTr("Modelo Físico")
        resizable: false
    }

    model: ListModel {
        id: listModelProblem
        ListElement{ title: "Ecuación de Transporte" ; author: "Gabriel" }
        ListElement{ title: "Brilliance"    ; author: "Jens" }
        ListElement{ title: "Outstanding"   ; author: "Frederik" }
    }

    onClicked: {
        console.log(listModelProblem.get(row).author);
    }
}
