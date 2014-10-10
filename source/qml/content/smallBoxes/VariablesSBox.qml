import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

import QtQuick.Dialogs 1.2

import "../../docs"
import "../../screens"
import "../../"
import "../"
import "."

Rectangle {

    id: variablesSBox

    Layout.fillHeight: true
    Layout.fillWidth: true

    border.color: Style.color.background_highlight

    ColumnLayout {

        height: parent.height
        width: parent.width

        spacing: 0

        Rectangle {

            id: variablesRectangle

            Layout.preferredHeight: textCode.height * 1.5
            Layout.preferredWidth: variablesList.width

            color: Style.color.background_highlight

            Text {
                id: textCode

                text: qsTr("Variables")
                font.italic: true

                color: Style.color.complement
                font.pixelSize: Style.fontSize.h5
                font.bold: true

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ListView {

            id: variablesList

            Layout.preferredHeight: parent.height - buttonSaveVariables.height - variablesRectangle.height
            Layout.preferredWidth: parent.width

            delegate: Rectangle {

                anchors.horizontalCenter: parent.horizontalCenter

                width: variablesRectangle.width - 2
                height: variablesTextField.height * 1.2
                color: (index % 2 === 0) ? Style.color.background :  Style.color.background_highlight;

                RowLayout {

                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height
                    width: parent.width * .95

                    spacing: 0

                    Text {
                        Layout.fillWidth: true
                        text: title
                    }

                    TextField {
                        id: variablesTextField

                        Layout.preferredWidth: parent.width / 2
                        text: author
                    }
                }
            }

            clip: true

            z: variablesRectangle.z - 1

            model: ListModel {
                id: listModelVariablesSBox
            }

            Connections {
                target: CurrentFileIO

                onPerformedRead: {
                    var dynamicVariables = getArgsFromScriptFile(content);
                    var dynamicVariablesKeys = Object.keys(dynamicVariables);
                    var k;

                    listModelVariablesSBox.clear();

                    for ( k = 0 ; k < dynamicVariablesKeys.length ; k++ ) {
                        listModelVariablesSBox.append({
                            'title': dynamicVariablesKeys[k],
                            'author' : dynamicVariables[dynamicVariablesKeys[k]]
                        });
                    }
                }
            }
        }

        PrimaryButton {
            id: buttonSaveVariables
            Layout.fillWidth: true

            buttonText.font.pixelSize: height / 2
            buttonLabel: qsTr('Guardar')

            buttonStatus: 'white'

            onClicked: {
                StudyCaseHandler.createDomainFromScriptFile(CurrentFileIO.read());
            }
        }
    }

    function getArgsFromScriptFile(content) {
        var regex = new RegExp("^\s*function.*\\[(.*)\\].+domain\\((.*)\\)$", "m");
        var match = regex.exec(content);

        var returned_values = match[1].split(',');
        var args = match[2].split(',');
        var kArgs;

        var dynamicVariables = {};
        var dynamicArgs;

        for ( kArgs = 0; kArgs < args.length; kArgs++ ) {
            if (args[kArgs].search('=') > 0) {
                dynamicArgs = args[kArgs].split('=');
                dynamicVariables[dynamicArgs[0].trim()] = dynamicArgs[1].trim();
                console.log(dynamicArgs[1].trim());
            } else {
                dynamicVariables[args[kArgs].trim()] = '';
            }
        }

        return dynamicVariables;
    }

}
