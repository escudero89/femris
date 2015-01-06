import QtQuick 2.4

import "."
import "modals"

Item {

    property alias alert : alertModal
    property alias preferences : preferencesModal

    anchors.fill: parent

    AlertModal { id: alertModal }
    LoadingModal {}
    FirstTimeModal { visible: !Configure.check("firstTime", "true") }
    FirstTimeModal { id: preferencesModal; firstTime: false }

}
