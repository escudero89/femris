pragma Singleton

import QtQuick 2.2

QtObject {

    property QtObject initial : QtObject {
        property string tutorial :
        "<p>En esta sección recorreremos juntos la base teórica que sostiene al <b>Método de los Elementos Finitos</b>.</p>" +
        "<p>Aprenderemos sobre <i>modelos matemáticos, mallas de elementos finitos, funciones de forma, ensamblaje, matriz de rígidez global,</i> entre otros muchos conceptos.</p>" +
        "<p>Sí crees que ya conoces todos estos temas, y no deseas revisarlos, puedes saltearte este bloque.</p>";

        property string initiate :
        "<p>En este bloque iniciaremos la creación de un nuevo <b>Caso de Estudio</b>.</p>" +
        "<p>Ésto es, un archivo <i>'.femris'</i> que contendrá toda la información necesaria para presentar un modelo matemático en particular y visualizar su solución. </p>"

        property string load :
        "<p></p>"
    }
}
