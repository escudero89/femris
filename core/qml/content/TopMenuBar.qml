import QtQuick 2.4
import QtQuick.Controls 1.3
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
            onTriggered: Configure.emitMainSignal("dialogs.load.open()")
        }
        MenuSeparator { }
        MenuItem {
            id: menuItemSave

            text: qsTr("Guardar Caso de Estudio")
            shortcut: "Ctrl+S"
            iconSource: "qrc:/resources/icons/black/save8.png"
            onTriggered: {
                if (StudyCaseHandler.getLastSavedPath() !== "") {
                    StudyCaseHandler.saveCurrentStudyCase(StudyCaseHandler.getLastSavedPath());
                } else {
                    dialogs.save.open();
                }
            }

            enabled: StudyCaseHandler.exists();
        }
        MenuItem {
            id: menuItemSaveAs

            text: qsTr("Guardar Caso de Estudio como...")
            iconSource: "qrc:/resources/icons/black/save8.png"
            shortcut: "Ctrl+Shift+S"
            onTriggered: dialogs.save.open();

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

                menuItemClose.enabled = exists;
                menuItemSave.enabled = exists;
                menuItemSaveAs.enabled = exists;
            }

            onMarkedAsSaved: {
                menuItemSave.enabled = false;
            }

            onMarkedAsNotSaved: {
                menuItemSave.enabled = true;
            }

            onLoadingNewStudyCase: {
                menuItemClose.trigger();
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
            onTriggered: mainWindow.switchSection("Tutorial")
        }
    }
    Menu {
        title: qsTr("Ayuda")
        MenuItem {
            text: qsTr("Ver Ayuda Online")
            shortcut: "F1"
            iconSource: "qrc:/resources/icons/black/question23.png"
            onTriggered: {
                openOnlineHelp.github = "wiki/Gu%C3%ADa-del-Usuario";
                openOnlineHelp.start();
            }
        }
        MenuSeparator { }
        MenuItem {
            text: qsTr("Reportar un problema")
            iconSource: "qrc:/resources/icons/black/bug6.png"
            onTriggered: {
                openOnlineHelp.github = "issues";
                openOnlineHelp.start();
            }
        }
        MenuItem {
            text: qsTr("Contacto")
            iconSource: "qrc:/resources/icons/black/speech59.png"
            onTriggered: {
                openOnlineHelp.github = "wiki/Contacto";
                openOnlineHelp.start();
            }
        }

        // This timer is required to avoid crashes due to immediate opening of url
        Timer {
            property string github

            id : openOnlineHelp
            interval: 500; running: false;
            onTriggered: globalInfoBox.loadUrlInBrowser("https://github.com/escudero89/femris/" + github);
        }

        MenuSeparator { }
        MenuItem {
            text: qsTr("Acerca de...")
            onTriggered: whichMenu("about");
            iconSource: "qrc:/resources/icons/black/star60.png"
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
    }
}
