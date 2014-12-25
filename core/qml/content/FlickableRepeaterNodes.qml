import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import QtWebKit 3.0

import "../docs"
import "../screens"
import "../"
import "."

import "components"

ColumnLayout {

    property alias objectRepeater: repeater
    property alias objectHeader: textHeader

    property string textRow : "Nodo #"

    property string textInformation : "pointload"

    property variant jsonDomain : null

    Layout.fillHeight: true
    Layout.fillWidth: true

    Rectangle {
        id: rectangle1

        Layout.preferredHeight: textHeader.height * 1.1
        Layout.preferredWidth: parent.width

        color: Style.color.background_highlight

        Text {
            id: textHeader

            text: qsTr("Condiciones nodales") + "<br /><small style='color:" + Style.color.content + "'><em>" + qsTr("Número de nodos: ") + repeater.count + "</em></small>"
            textFormat: Text.RichText
            font.pointSize: Style.fontSize.h5

            anchors.left: parent.left
            anchors.leftMargin: 12
        }

    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 3

        color: Style.color.complement
        opacity: 0.3
    }

    RowLayout {

        Layout.fillHeight: true
        Layout.fillWidth: true

        spacing: 0

        GridView {

            id: repeater

            clip: true

            Layout.fillHeight: true
            Layout.fillWidth: true

            cellHeight: 40
            cellWidth: width;

            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds

            // Only show the scrollbars when the view is moving.
            states: State {
                name: "ShowBars"
                when: repeater.movingVertically
                PropertyChanges { target: verticalScrollBar; opacity: 1 }
            }

            transitions: Transition {
                NumberAnimation { properties: "opacity"; duration: 400 }
            }

            //highlight: Rectangle { color: Style.color.primary; opacity: 0.1; radius: 1; z: repeater.z }

            focus: true

            model: 0

            delegate: NodesStructural {}

        }

        // Attach scrollbars to the right of the view.
        ScrollBar {
            id: verticalScrollBar
            Layout.preferredWidth: 12
            Layout.preferredHeight: repeater.height - 12

            opacity: 0
            orientation: Qt.Vertical
            position: repeater.visibleArea.yPosition
            pageSize: repeater.visibleArea.heightRatio
        }
    }
}
