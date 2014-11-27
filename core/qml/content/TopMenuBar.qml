import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.2

import "."
import "../"

MenuBar {
    signal whichMenu(string menuItem)

    Menu {
        title: qsTr("Archivo")
        MenuItem {
            text: qsTr("Nuevo Caso de Estudio")
            shortcut: "Ctrl+N"
            iconSource: "qrc:/resources/icons/black/file28.png"

            onTriggered: {
                StudyCaseHandler.start();
                mainWindow.switchSection("CE_Overall");
            }
        }
        MenuItem {
            text: qsTr("Cargar Caso de Estudio")
            shortcut: "Ctrl+O"
            iconSource: "qrc:/resources/icons/black/open96.png"
            onTriggered: Configure.emitMainSignal("femrisLoader.open()")
        }
        MenuSeparator { }
        MenuItem {
            id: menuItemContinue

            text: qsTr("Continuar con Vista General")
            shortcut: "Ctrl+Shift+O"
            iconSource: "qrc:/resources/icons/black/file27.png"
            onTriggered: mainWindow.switchSection("CE_Overall")

            enabled: StudyCaseHandler.exists();
        }
        MenuItem {
            id: menuItemSave

            text: qsTr("Guardar Caso de Estudio")
            shortcut: "Ctrl+S"
            iconSource: "qrc:/resources/icons/black/save8.png"
            onTriggered: femrisSaver.open();

            enabled: StudyCaseHandler.exists();
        }
        MenuItem {
            id: menuItemSaveAs

            text: qsTr("Guardar Caso de Estudio como...")
            iconSource: "qrc:/resources/icons/black/save8.png"
            shortcut: "Ctrl+Shift+S"
            onTriggered: femrisSaver.open();

            enabled: StudyCaseHandler.exists();
        }
        MenuSeparator { }
        MenuItem {
            id: menuItemClose

            text: qsTr("Cerrar Caso de Estudio")
            iconSource: "qrc:/resources/icons/black/cross41.png"
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
                var exists = StudyCaseHandler.exists();

                menuItemContinue.enabled = exists;
                menuItemClose.enabled = exists;
                menuItemSave.enabled = exists;
                menuItemSaveAs.enabled = exists;
            }
        }

        MenuSeparator { }
        MenuItem {
            text: qsTr("Salir")
            shortcut: "Ctrl+Q"
            iconSource: "qrc:/resources/icons/black/remove11.png"
            onTriggered: whichMenu("close")
        }
    }
    Menu {
        title: qsTr("Edición")
        MenuItem {
            text: qsTr("Preferencias")
            shortcut: "Ctrl+P"
            iconSource: "qrc:/resources/icons/black/open95.png"
            onTriggered: whichMenu("preferences")
        }
    }
    Menu {
        title: qsTr("Ir")
        MenuItem {
            text: qsTr("Menu Principal")
            shortcut: "Ctrl+Alt+M"
            iconSource: "qrc:/resources/icons/black/eye50.png"
            onTriggered: mainWindow.switchSection("Initial")
        }
        MenuItem {
            text: qsTr("Selección de Etapa")
            shortcut: "Ctrl+Alt+E"
            iconSource: "qrc:/resources/icons/black/four29.png"
            onTriggered: mainWindow.switchSection("CE_Overall")
        }
        MenuItem {
            text: qsTr("Tutorial")
            shortcut: "Ctrl+T"
            iconSource: "qrc:/resources/icons/black/book95.png"
            onTriggered: mainWindow.switchSection("tutorial")
        }
    }
    Menu {
        title: qsTr("Ayuda")
        MenuItem {
            text: qsTr("Acerca de...")
            iconSource: "qrc:/resources/icons/black/question23.png"
            onTriggered: whichMenu("about");
        }
    }

    Menu {
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
                StudyCaseHandler.saveCurrentStudyCase(femrisSaver.fileUrl);
            }
            onRejected: {
                console.log("Canceled");
            }
        }
    }
}
