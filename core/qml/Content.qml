pragma Singleton

import QtQuick 2.4
import "."

import "custom.js" as Custom

QtObject {

    property string appName: "FEMRIS"
    property string version: "0.9.2"

    property string baseDir : applicationDirPath + "/docs/inner/"

    property string femris : "<strong style='color:" + Style.color.femris + "'>FEMRIS</strong>";

    property variant alert     : splitContent("alert")
    property variant firstTime : splitContent("firstTime")
    property variant initial   : splitContent("initial")
    property variant model     : splitContent("model")
    property variant overall   : splitContent("overall")


    function splitContent(fileName) {
        var content = CurrentFileIO.readFromSource(baseDir + fileName + ".html");

        var splittedContent = content.split('\r\n');
        var mainContent = {};

        var insideBlock = false;

        for ( var kLine = 0; kLine < splittedContent.length ; kLine++ ) {
            var line = splittedContent[kLine];
            var matchResultStart = line.match(/{{start\|(\w+)}}/);
            var matchResultEnd = line.match(/{{end|(\w+)}}/);

            line = line.replace(/\$femris/g, femris);

            if (matchResultEnd) {
                insideBlock = false;
            }

            if (insideBlock) {
                if (!mainContent[insideBlock]) {
                    mainContent[insideBlock] = line + "\r\n";
                } else {
                    mainContent[insideBlock] += line + "\r\n";
                }
            }

            if (matchResultStart) {
                insideBlock = matchResultStart[1];
            }
        }

        /*
        for ( var keyContent in mainContent ) {
            if (!mainContent.hasOwnProperty(keyContent)) {
                continue;
            }

            mainContent[keyContent] = Custom.escapeHtmlEntities(mainContent[keyContent]);
            console.log(mainContent[keyContent]);
        }*/

        return mainContent;
    }
}
