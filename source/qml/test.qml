import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import "."
import "content/"

ColumnLayout {

    height: parent.height
    width: parent.width

ListModel {
    id: pageModel
    ListElement {
        title: "Buttons"
        page: "content/ButtonPage.qml"
    }
    ListElement {
        title: "Sliders"
        page: "content/SliderPage.qml"
    }
    ListElement {
        title: "ProgressBar"
        page: "content/ProgressBarPage.qml"
    }
    ListElement {
        title: "Tabs"
        page: "content/TabBarPage.qml"
    }
    ListElement {
        title: "TextInput"
        page: "content/TextInputPage.qml"
    }
    ListElement {
        title: "List"
        page: "content/ListPage.qml"
    }
}


}
