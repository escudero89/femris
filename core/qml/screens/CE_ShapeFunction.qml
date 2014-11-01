import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0
import QtWebKit.experimental 1.0

import "../docs"
import "../content"
import "../"

RowLayout {

    id: rowParent
    objectName: "CE_ShapeFunction"

    spacing: 0
    anchors.fill: globalLoader

    LeftContentBox {
        id: leftContentRectangle

        color: Style.color.content_emphasized
        Layout.fillHeight: true
        Layout.preferredWidth: parent.width * 0.20

        firstTimeOnly: true
    }

    ColumnLayout {

        id: mainContentRectangle

        Layout.fillHeight: true
        Layout.preferredWidth: parent.width - leftContentRectangle.width

        spacing: 0

        WebView {
            id: currentWebView

            experimental.preferences.webGLEnabled: true
            experimental.preferences.developerExtrasEnabled: true

            Layout.fillWidth: true
            Layout.fillHeight: true

            url: "qrc:/docs/ce_shapefunction.html"
        }

        RowLayout {

            spacing: 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            PrimaryButton {
                buttonLabel: "Vista General"
                buttonStatus: "primary"
                //buttonText.font.pixelSize: height / 2

                onClicked : mainWindow.switchSection("CE_Overall")

                Layout.fillWidth: true
            }

            PrimaryButton {
                id: continueButton

                buttonLabel: "Guardar y Continuar"
                buttonStatus: "success"
                //buttonText.font.pixelSize: height / 2

                Layout.preferredWidth: 0.6 * parent.width

                onClicked: {
                    mainWindow.switchSection(StudyCaseHandler.saveAndContinue(rowParent.objectName));
                }
            }
        }
    }
}
