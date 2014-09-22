import QtQuick 2.2
import QtQuick.Controls 1.1

import "."

MenuBar {
        Menu {
            title: qsTr("Archivo")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("Edición")
            MenuItem {
                text: qsTr("Preferencias")
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("Ir")
            MenuItem {
                text: qsTr("Pantalla de Inicio")
                onTriggered: mainWindow.switchSection();
            }
        }
        Menu {
            title: qsTr("Ayuda")
            MenuItem {
                text: qsTr("Acerca de...")
                onTriggered: { messageDialog.visible = true }
            }
        }
    }
