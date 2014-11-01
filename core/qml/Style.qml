pragma Singleton

import QtQuick 2.3

QtObject {

    // Themes availables:
    // colorSolarized
    // colorBootstrap

    property QtObject fontSize: QtObject {
        property int h1 : 36
        property int h2 : 30
        property int h3 : 24
        property int h4 : 18
        property int h5 : 14
        property int h6 : 12
    }

    //property alias g_theme : theme
    property string theme : "colorBootstrap"

    property QtObject color: QtObject {

        function getColorByTheme(theTheme, whichOne) {
            var colour = null;

            switch (theTheme) {
                //>>>>>>>>>>>>>>>>>>>>
                case "colorBootstrap":
                    switch(whichOne) {
                        case "complement"            : colour = "#111"; break;
                        case "complement_highlight"  : colour = "#333"; break;
                        case "content_emphasized"    : colour = "#555"; break;
                        case "content"               : colour = "#777"; break;
                        case "comment_emphasized"    : colour = "#999"; break;
                        case "comment"               : colour = "#bbb"; break;
                        case "background"            : colour = "#eee"; break;
                        case "background_highlight"  : colour = "#f8f8f8"; break;
                        case "primary"               : colour = "#428bca"; break;
                        case "success"               : colour = "#5cb85c"; break;
                        case "info"                  : colour = "#5bc0de"; break;
                        case "warning"               : colour = "#f0ad4e"; break;
                        case "danger"                : colour = "#d9534f"; break;
                    }
                    break;
                //>>>>>>>>>>>>>>>>>>>>
                case "colorSolarized-light":
                    switch(whichOne) {
                        case "complement"            : colour = "#002b36"; break;
                        case "complement_highlight"  : colour = "#073642"; break;
                        case "content_emphasized"    : colour = "#586e75"; break;
                        case "content"               : colour = "#657b83"; break;
                        case "comment_emphasized"    : colour = "#839496"; break;
                        case "comment"               : colour = "#93a1a1"; break;
                        case "background"            : colour = "#eee8d5"; break;
                        case "background_highlight"  : colour = "#fdf6e3"; break;
                        case "primary"               : colour = "#268bd2"; break;
                        case "success"               : colour = "#859900"; break;
                        case "info"                  : colour = "#2aa198"; break;
                        case "warning"               : colour = "#cb4b16"; break;
                        case "danger"                : colour = "#dc322f"; break;
                    }
                    break;
                //>>>>>>>>>>>>>>>>>>>>
                case "colorSolarized-dark":
                    switch(whichOne) {
                        case "background_highlight"  : colour = "#002b36"; break;
                        case "background"            : colour = "#073642"; break;
                        case "comment"               : colour = "#586e75"; break;
                        case "comment_emphasized"    : colour = "#657b83"; break;
                        case "content"               : colour = "#839496"; break;
                        case "content_emphasized"    : colour = "#93a1a1"; break;
                        case "complement_highlight"  : colour = "#eee8d5"; break;
                        case "complement"            : colour = "#fdf6e3"; break;
                        case "primary"               : colour = "#268bd2"; break;
                        case "success"               : colour = "#859900"; break;
                        case "info"                  : colour = "#2aa198"; break;
                        case "warning"               : colour = "#cb4b16"; break;
                        case "danger"                : colour = "#dc322f"; break;
                    }
                    break;
            }

            return colour;
        }

        property color complement            :  getColorByTheme(theme, "complement")
        property color complement_highlight  :  getColorByTheme(theme, "complement_highlight")

        // Content tones (DARK | LIGHT)
        property color content_emphasized    :  getColorByTheme(theme, "content_emphasized")
        property color content               :  getColorByTheme(theme, "content")
        property color comment_emphasized    :  getColorByTheme(theme, "comment_emphasized")
        property color comment               :  getColorByTheme(theme, "comment")

        // Colores de background
        property color background            :  getColorByTheme(theme, "background")
        property color background_highlight  :  getColorByTheme(theme, "background_highlight")

        // Serie de colores a utilizar
        property color primary               :  getColorByTheme(theme, "primary")   // azul
        property color success               :  getColorByTheme(theme, "success")   // verde
        property color info                  :  getColorByTheme(theme, "info")   // cyan
        property color warning               :  getColorByTheme(theme, "warning")   // naranja
        property color danger                :  getColorByTheme(theme, "danger")   // rojo

    }

}
