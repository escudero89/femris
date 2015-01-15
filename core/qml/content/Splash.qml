import QtQuick 2.0
import QtQuick.Window 2.1

import "../"

//! [splash-properties]
Window {
    id: splash
    color: "transparent"
    title: "Splash Window"
    modality: Qt.ApplicationModal
    flags: Qt.SplashScreen
    property int timeoutInterval: 3000
    signal timeout
//! [splash-properties]
//! [screen-properties]
    x: (Screen.width - splashImage.width) / 2
    y: (Screen.height - splashImage.height) / 2
//! [screen-properties]
    width: splashImage.width
    height: splashImage.height

    Image {
        id: splashImage
        source: "qrc:/resources/images/splash-screen.png"
        MouseArea {
            anchors.fill: parent
        }

        z: -1000

        Text {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 10
            anchors.topMargin: 10

            text: Content.appName + " <small>versión " + Content.version + "</small>" +
                  "<br/><small>" + qsTr("Cargando...") + "</small>"
            color:  "#EEEEEE"

            textFormat: Text.RichText
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10

            text: qsTr("<small>&copy; 2014-2015 Cristian Escudero. Todos los derechos reservados.</small>")
            color:  "#CCCCCC"

            textFormat: Text.RichText
            opacity: 0.5
        }
    }
    //! [timer]
    Timer {
        interval: timeoutInterval; running: true; repeat: false
        onTriggered: {
            visible = false
            splash.timeout()
        }
    }
    //! [timer]
    Component.onCompleted: visible = true
}
