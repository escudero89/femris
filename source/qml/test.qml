import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

RowLayout {

    id: rowParent

    spacing: 0

    Rectangle {
        id: indiceContenido
        color: "red"
        Layout.fillHeight: true
        state: "NORMAL"

        states: [
            State {
                name: "NORMAL"
                PropertyChanges { target: indiceContenido; Layout.preferredWidth: rowParent.width * .2}
            },
            State {
                name: "OCULTO"
                PropertyChanges { target: indiceContenido; Layout.preferredWidth: rowParent.width / 20}
            }
        ]

        MouseArea {
            anchors.fill: parent
            onClicked : {
                // La primera vez no esta activado, luego si
                indiceContenidoBehavior.enabled = true

                if (indiceContenido.state == "NORMAL")
                    indiceContenido.state = "OCULTO"
                else
                    indiceContenido.state = "NORMAL"
            }
        }

        Behavior on Layout.preferredWidth {
            id: indiceContenidoBehavior
            enabled: false
            NumberAnimation { duration: 100 }
        }
    }

    RowLayout {

        spacing: 0

        Rectangle {
            color: "gray"
            Layout.fillHeight: true
            Layout.preferredWidth: rowParent.width * .5
        }

        Rectangle {
            color: "white"
            Layout.fillHeight: true
            Layout.preferredWidth: rowParent.width * .5
        }
    }

}
