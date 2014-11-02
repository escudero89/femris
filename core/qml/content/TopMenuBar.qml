import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.2

import "."

MenuBar {
    Menu {
        title: qsTr("Archivo")
        MenuItem {
            text: qsTr("Nuevo Caso de Estudio")
            shortcut: "Ctrl+N"
            onTriggered: {
                StudyCaseHandler.start();
                mainWindow.switchSection("CE_Overall");
            }
        }
        MenuItem {
            text: qsTr("Cargar Caso de Estudio")
            shortcut: "Ctrl+O"
            onTriggered: {
                StudyCaseHandler.start();
                mainWindow.switchSection("CE_Overall");
            }
        }
        MenuSeparator { }
        MenuItem {
            text: qsTr("Continuar trabajando con Caso de Estudio")
            shortcut: "Ctrl+Shift+O"
            onTriggered: {
                mainWindow.switchSection("CE_Overall");
            }
        }
        MenuItem {
            text: qsTr("Guardar Caso de Estudio")
            shortcut: "Ctrl+S"
            onTriggered: femrisSaver.open();
        }
        MenuItem {
            text: qsTr("Guardar Caso de Estudio como...")
            shortcut: "Ctrl+Shift+S"
            onTriggered: femrisSaver.open();
        }
        MenuSeparator { }
        MenuItem {
            id: menuItemClose

            text: qsTr("Cerrar Caso de Estudio")
            onTriggered: {
                mainWindow.switchSection("Initial");
                StudyCaseHandler.start();
                menuItemClose.enabled = StudyCaseHandler.exists();
            }

            enabled: StudyCaseHandler.exists();
        }
        Connections {
            target: StudyCaseHandler
            onNewStudyCaseCreated: {
                menuItemClose.enabled = StudyCaseHandler.exists();
            }
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
            onTriggered: mainWindow.switchSection("tutorial");
        }
    }
    Menu {
        title: qsTr("Ayuda")
        MenuItem {
            text: qsTr("Acerca de...")
            onTriggered: { messageDialog.visible = true }
        }

        MessageDialog {
            id: messageDialog
            title: "En Construcción"
            text: "En esta versión aún no está disponible esta funcionalidad."
            onAccepted: {
                //console.log("And of course you could only agree.")
                //Qt.quit()
            }

            visible: false
        }

        FileDialog {
            id: femrisSaver
            title: "Guardar Caso de Estudio como..."

            nameFilters: [ "Archivos de FEMRIS (*.femris)", "Todos los archivos (*)" ]

            selectExisting: false

            modality: "ApplicationModal"

            onAccepted: {
                console.log("You chose: " + femrisSaver.fileUrl);
                //CurrentFileIO.setSource(femrisSaver.fileUrl);

                //codeArea.text = CurrentFileIO.read();
            }
            onRejected: {
                console.log("Canceled");
            }
        }
    }
}
