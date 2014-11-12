import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtWebKit 3.0

import "../docs"
import "../content"
import "../"

RowLayout {

    id: rowParent
    objectName: "CE_ShapeFunction"

    spacing: 0

    RowLayout {

        width: rowParent.width
        spacing: 0

        LeftContentBox {
            id: leftContentRectangle

            color: Style.color.content_emphasized
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.20

            firstTimeOnly: true

            onBlockHiding: {
                if (isHiding) {
                    leftContentRectangle.width = leftContentRectangle.parent.width * 0;
                    leftContentRectangle.visible = false;
                } else {
                    leftContentRectangle.width = leftContentRectangle.parent.width * 0.20;
                    leftContentRectangle.visible = true;
                }
                mainContentRectangle.width  = rowParent.width - leftContentRectangle.width;
                mainContentRectangle.x = leftContentRectangle.width;
            }
        }
    }

    ColumnLayout {

        id: mainContentRectangle

        Layout.fillHeight: true
        Layout.preferredWidth: parent.width - leftContentRectangle.width

        spacing: 0

        WebView {
            id: currentWebView

            Layout.fillWidth: true
            Layout.fillHeight: true

            url: "qrc:/docs/ce_shapefunction.html"
        }

        RowLayout {

            spacing: 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            PrimaryButton {

                property string loadUrlBase : "docs/ce_shapefunction.html"
                tooltip: qsTr("Abrir esta página en tu navegador por defecto")

                buttonStatus: "femris"
                buttonLabel: ""

                Layout.preferredWidth: 0.1 * parent.width

                onClicked: {
                    StudyCaseHandler.loadUrlInBrowser(loadUrlBase);
                }

                iconSource: "qrc:/resources/icons/external2.png"
            }

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

                Layout.preferredWidth: 0.5 * parent.width

                onClicked: {
                    mainWindow.switchSection(StudyCaseHandler.saveAndContinue(rowParent.objectName));
                }
            }
        }
    }
}
