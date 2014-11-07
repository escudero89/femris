import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtQuick.XmlListModel 2.0

import "../"

// Contenido del Index
StackView {
    id: stackView

    Layout.fillWidth: true
    Layout.fillHeight: true

    // Para volver hacia atras con la navegacion
    signal makePop()

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

            signal currentIndexChanged()

            highlight: Rectangle {
                id: highlightRectangle
                color: Style.color.background_highlight
                radius: 2
                opacity: 0
            }


            delegate: AndroidDelegate {
                // Mi seleccion actual
                property variant myCurrent : xmlModel.get(index)

                property variant mySource: {
                    // Si existe source, le cargamos el nuevo
                    var source = myCurrent.source;
                    return (source) ? "/body/" + source + "/item" : false;
                }

                height: indexLayout.height * 0.04
                text: title

                isSelected: (xmlView.currentIndex === index)
                hasChild: (source) ? true : false

                onClicked: {
                    xmlView.currentIndex = index;
                    xmlView.highlightItem.opacity = 1;

                    // Si tiene source es porque tiene hijos, sino es porque apunta a una page
                    if (mySource) {

                        stackView.push({
                           "item": Qt.resolvedUrl("qrc:/content/StackIndex.qml"),
                           "properties": {
                               "id" : "stackChild",
                               "indexQuery" : mySource
                           }
                       });

                    } else {
                        // Informamos a IndexLayout que cargue la nueva pagina
                        indexLayout.loader(myCurrent.page);
                    }
                }
            }
        }
    }

    // Lee el index desde Xml
    XmlListModel {
        id: xmlModel

        source: fileApplicationDirPath + "/docs/index.xml"
        query: "/body/header/item"

        XmlRole { name: "title"; query: "@title/string()" }
        XmlRole { name: "source"; query: "@source/string()" }
        XmlRole { name: "page"; query: "@page/string()" }
    }

    onMakePop : {
        // Hacemos un pop en el hijo. Si eso no funciona, el pop es en el padre
        if (depth > 1) {
            if (!currentItem.pop()) {
                pop();
            }
        }
    }
}
