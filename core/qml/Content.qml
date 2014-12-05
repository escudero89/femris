pragma Singleton

import QtQuick 2.3
import "."

QtObject {

    property string baseDir : fileApplicationDirPath + "/docs/inner/"

    property string femris : "<strong style='color:" + Style.color.femris + "'>FEMRIS</strong>";

    property variant alert     : splitContent("alert")
    property variant firstTime : splitContent("firstTime")
    property variant initial   : splitContent("initial")
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

        return mainContent;
    }
}
