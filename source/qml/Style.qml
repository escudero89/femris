pragma Singleton

import QtQuick 2.2

QtObject {

    property QtObject color: colorBootstrap // colorBootstrap

    property QtObject colorBootstrap: QtObject{
        // Background tones (DARK)
        property color complement            :  "#222"
        property color complement_highlight  :  "#333"

        // Content tones (DARK | LIGHT)
        property color emphasized_content    :  "#555"
        property color content               :  "#777"
        property color emphasized_comment    :  "#999"
        property color comment               :  "#aaa"

        // Colores de background
        property color background            :  "#eee"
        property color background_highlight  :  "#fff"

        // Serie de colores a utilizar
        property color primary      :           "#428bca"   // azul
        property color success      :           "#5cb85c"   // verde
        property color info         :           "#5bc0de"   // cyan
        property color warning      :           "#f0ad4e"   // naranja
        property color danger       :           "#d9534f"   // rojo
    }

    property QtObject colorSolarized: QtObject{
        // Background tones (DARK)
        property color complement            :  "#002b36"
        property color complement_highlight  :  "#073642"

        // Content tones (DARK | LIGHT)
        property color emphasized_content    :  "#586e75"
        property color content               :  "#657b83"
        property color emphasized_comment    :  "#839496"
        property color comment               :  "#93a1a1"

        // Colores de background
        property color background            :  "#eee8d5"
        property color background_highlight  :  "#fdf6e3"

        // Serie de colores a utilizar
        property color primary      :           "#268bd2"   // azul
        property color success      :           "#859900"   // verde
        property color info         :           "#2aa198"   // cyan
        property color warning      :           "#cb4b16"   // naranja
        property color danger       :           "#dc322f"   // rojo
    }
}
