pragma Singleton

import QtQuick 2.2

QtObject {

    property QtObject color: QtObject{
        // Background tones (DARK)
        property color base03 :    "#002b36";
        property color base02 :    "#073642";

        // Content tones (DARK | LIGHT)
        property color base01 :    "#586e75";
        property color base00 :    "#657b83";
        property color base0 :     "#839496";
        property color base1 :     "#93a1a1";

        // Background tones (LIGHT)
        property color base2 :     "#eee8d5";
        property color base3 :     "#fdf6e3";

        // Other colors
        property color yellow :    "#b58900";
        property color orange :    "#cb4b16";
        property color red :       "#dc322f";
        property color magenta :   "#d33682";
        property color violet :    "#6c71c4";

        property color blue :      "#268bd2";
        property color light_blue :"#26b6d2";

        property color cyan :      "#2aa198";
        property color green :     "#859900";
    }
}
