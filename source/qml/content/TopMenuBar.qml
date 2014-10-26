import QtQuick 2.3
import QtQuick.Controls 1.1

import "."

MenuBar {
        Menu {
            title: qsTr("Archivo")
            MenuItem {
                text: qsTr("Nuevo Caso de Estudio")
                shortcut: "Ctrl+N"
                onTriggered: Qt.quit();
            }
            MenuItem {
                text: qsTr("Guardar Caso de Estudio")
                shortcut: "Ctrl+S"
                onTriggered: Qt.quit();
            }
            MenuItem {
                text: qsTr("Guardar Caso de Estudio cómo...")
                shortcut: "Ctrl+Shift+S"
                onTriggered: Qt.quit();
            }
            MenuSeparator { }
            MenuItem {
                text: qsTr("Cerrar Caso de Estudio")
                onTriggered: Qt.quit();
            }
            MenuSeparator { }
            MenuItem {
                text: qsTr("Salir")
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("Edición")
            MenuItem {
                text: qsTr("Preferencias")
                shortcut: "Ctrl+P"
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("Ir")
            MenuItem {
                text: qsTr("Menu Principal")
                shortcut: "Ctrl+Alt+M"
                onTriggered: mainWindow.switchSection("Initial");
            }
            MenuItem {
                text: qsTr("Selección de Etapa")
                shortcut: "Ctrl+Alt+E"
                onTriggered: mainWindow.switchSection("CE_Overall");
            }
            MenuItem {
                text: qsTr("Tutorial")
                shortcut: "Ctrl+T"
                onTriggered: mainWindow.switchSection("BaseFrame");
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
