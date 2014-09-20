import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtQuick.XmlListModel 2.0

import "../"

// Contenido del Index
StackView {
    id: stackView

    Layout.fillWidth: true
    Layout.fillHeight: true

    // Donde vamos a estar parados en el Index
    property alias indexQuery : xmlModel.query

    // Implementa navegacion hacia atras
    focus: true
    Keys.onReleased: {
        if (event.key === Qt.Key_Back && stackView.depth > 1) {
            stackView.pop();
            event.accepted = true;
        }
    }

    initialItem: Item {
        width: parent.width
        height: parent.height

        ListView {
            id: xmlView
            model: xmlModel
            anchors.fill: parent
            delegate: AndroidDelegate {

                property variant mySource: {
                    // Si existe source, le cargamos el nuevo
                    var source = xmlModel.get(index).source;
                    return (source) ? "/body/" + source + "/item" : false;
                }

                height: indexLayout.height * 0.05
                text: title
                iconVisible: source ? true : false

                onClicked: {
                    if (mySource) {
                        stackView.push({
                                           "item": Qt.resolvedUrl("qrc:/content/StackIndex.qml"),
                                           "properties": {
                                               "indexQuery" : mySource
                                           }
                                       })
                    }
                }
            }
        }
    }

    // Lee el index desde Xml
    XmlListModel {
        id: xmlModel

        source: "qrc:/docs/index.xml"
        query: "/body/header/item"

        XmlRole { name: "title"; query: "@title/string()" }
        XmlRole { name: "source"; query: "@source/string()" }
        XmlRole { name: "page"; query: "@page/string()" }
    }
}
