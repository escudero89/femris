pragma Singleton

import QtQuick 2.2

QtObject {

    property QtObject color: QtObject{
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

        // Niveles de gris
        property color grey_darker  :           "#222"
        property color grey_dark    :           "#333"
        property color grey         :           "#555"
        property color grey_light   :           "#777"
        property color grey_lighter :           "#eee"

        // Serie de colores a utilizar
        property color primary      :           "#268bd2"   // azul
        property color success      :           "#859900"   // verde
        property color info         :           "#2aa198"   // cyan
        property color warning      :           "#cb4b16"   // naranja
        property color danger       :           "#dc322f"   // rojo
    }
}
