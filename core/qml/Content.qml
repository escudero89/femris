pragma Singleton

import QtQuick 2.3
import "."

QtObject {

    property string femris : "<strong style='color:" + Style.color.femris + "'>FEMRIS</strong>";

    property QtObject firstTime : QtObject {
        property string welcome:
        "<p>El Software Educativo destinado a ayudarte en tu aprendizaje sobre el <i>Método de los Elementos Finitos</i>.</p>" +
        "<p>Al parecer, esta es la <b>primera vez</b> que inicias el programa. " +
        "Si es así, ¿podrías configurar los siguientes parámetros del sistema?</p>"
    }

    property QtObject initial : QtObject {
        property string tutorial :
        "<p>En éste bloque recorreremos juntos la base teórica que sostiene al <b>Método de los Elementos Finitos</b>.</p>" +
        "<p>Aprenderemos sobre <i>modelos matemáticos, mallas de elementos finitos, funciones de forma, ensamblaje, matriz de rígidez global,</i> entre otros muchos conceptos.</p>" +
        "<p>Sí crees que ya conoces todos estos temas, y no deseas revisarlos, puedes saltearte este bloque.</p>";

        property string initiate :
        "<p>En éste bloque iniciaremos la creación de un nuevo <b>Caso de Estudio</b>.</p>" +
        "<p>Ésto es, un archivo <i>'.femris'</i> que contendrá toda la información necesaria para presentar un modelo matemático en particular y visualizar su solución. </p>"

        property string load :
        "<p>Éste bloque está destinado a la carga de <b>Casos de Estudio</b> ya creados, con la extensión  <i>'.femris'</i>.</p>" +
        "<p>"+ femris +" también permite la importación de archivos  <i>'.m'</i> creados con <b>MAT-fem</b>.</p>" +
        "<p>La detección de un tipo de archivo u otro lo hace automáticamente "+ femris +". " +
        "Sin embargo, éste no valida su funcionamiento al cargarlo. Sí hay un error, éste aparecerá en el momento de procesar los resultados.</p>"
    }

    property QtObject alert : QtObject {
        property string byDefault :
        "<p>By Default</p>";

        property string about :
        "<p>" + femris + " fue creado por Cristian Escudero como parte de su Proyecto Final de Carrera de la Carrera de Ingeniería en Informática en la Facultad de Ingeniería y Ciencias Hídricas anexa a la Universidad Nacional del Litoral</p>";
    }
}
