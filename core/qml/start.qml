import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import QtQuick.Dialogs 1.2

import "."
import "content"
import "screens"

QtObject {

    property string initialScreen : "screens/Initial.qml"

    property var myMainWindow: Main {
        visibility: "Hidden"
    }

    property var splashWindow: Splash {
        onTimeout: {
            myMainWindow.visibility = parseInt(Configure.read("lastWindowsSize"));

            if (myMainWindow.visibility === 0) {
                myMainWindow.visibility = 2;
            }

            myMainWindow.finishedLoading();
        }
    }
}
