// DRAW >>>>>>>>>

// We define some variables for the colors
var G_COLOR_NODE = "#428bca";
var G_COLOR_ELEM = "#428bca";
var G_COLOR_NODE_HIGH = "#d9534f";
var G_COLOR_ELEM_HIGH = "#d9534f";

// We set the SVG as a global variable, and also the dummy (efficiency)
var $G_DRAW_SHAPES = $("#draw-shapes");
var $G_DRAW_SHAPES_DUMMY = $('#draw-shapes-dummy');

// We get in this variable the width of the SVG that contains the drawing
var G_SHAPES_WIDTH = parseInt($G_DRAW_SHAPES.css("width"));

/**
 * Transform a string of SVG code into an object that can work along with Two.js
 * More info at: http://stackoverflow.com/a/3642265/1104116
 *
 * @param {string} s - An element to be parsed into the SVG
 * @return {fragment} frag - The object to append into the SVG
 */
function parseSVG(s) {

    var div = document.createElementNS('http://www.w3.org/1999/xhtml', 'div');
    div.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg">'+s+'</svg>';
    var frag = document.createDocumentFragment();

    while ( div.firstChild.firstChild ) {
        frag.appendChild( div.firstChild.firstChild );
    }

    return frag;
}

/**
 * Adds the params to a string, in the HTML tag format (i.e, idx="val")
 *
 * @param {string[]} params - A Javascript Object with the params
 * @return {string} html - The params transformed into the html tag syntax
 */
function addParams(params) {
    var html = '';

    $.each(params, function(idx, val) {
        html += ' ' + idx + '="' + val + '"';
    });

    return html;
}

/**
 * Creates a SVG Text Element (https://www.dashingd3js.com/svg-text-element)
 *
* @param {string} text - The text value of the object
* @param {string[]} params - A Javascript Object with the params
 * @return {string} - The SVG Text element
 */
function getTextSVG(text, params) {
    return "<text" + addParams(params) + ">" + text + "</text>";
}

/**
 * Creates a SVG Text Element (https://www.dashingd3js.com/svg-text-element)
 *
* @param {string} elem - The string that contains the element
 * @return {bool} - True if the operation was successuful, false otherwise
 */
function addElementToSVG(elem) {
    $G_DRAW_SHAPES_DUMMY.children().append(elem);
}

/**
 * Scales an array of xnode
 *
 * @param {number[]} xnode - An array of nodes (i.e., [[x1,y1], ..., [xN,yN]])
 * @return {Number[]} xnode - The array scaled
 */
function transformCoordinates(xnode) {

    var x_min = xnode[0][0];    // minimum x coordinate
    var x_max = x_min;          // maximum x coordinate
    var k;                      // counter

    var alpha;                  // alpha * x + beta = new_x
    var beta;

    // We get the maximum width and height of the coordinates
    for ( k = 0; k < xnode.length; k++ ) {
        if (xnode[k][0] < x_min) {
            x_min = xnode[k][0];
        } else if (xnode[k][0] > x_max) {
            x_max = xnode[k][0];
        }
    }

    // Then we calculate the maximum width of SVG and with that we set the scale factor
    alpha = 8 / 10 * ( G_SHAPES_WIDTH / ( x_max - x_min ) );
    beta  = G_SHAPES_WIDTH / 10 * ( 1 - 8 * x_min / ( x_max - x_min ) );

    // Finally we apply the scale factor to the coordinates
    for ( k = 0; k < xnode.length; k++ ) {
        xnode[k][0] = alpha * xnode[k][0] + beta;
        xnode[k][1] = alpha * xnode[k][1] + beta;
    }

    return xnode;
}

// Crea una serie de elementos y los agrupa, en base a un xnod = [x1 y1; x2 y2; ... ; xN yN]
// y un icone = [nodoA1 nodoA2 nodoA3 nodoA4 ; nodoN1 nodoN2 nodoN3 nodoN4]
// (el icone comienza con indice 1)
function makeElements(two, xnode, ielem) {

    var groupElem = new Two.Group();
    var groupNode = new Two.Group();

    var localParamsTextSVG = {          // These are the text's params shared locally
        'fill' : 'white',
        'font-family' : 'Georgia',
        'pointer-events' : 'none',
        'style' : 'cursor:pointer',
        'text-anchor' : 'middle'
    };

    var k, j, elem, twoElem, twoNode, paramsTextSVG;

    // We transform the original coordinates so they can fit better in the SVG
    xnode = transformCoordinates(xnode);

    // First we draw the elements
    for ( k = 0 ; k < ielem.length ; k++ ) {
        elem = ielem[k];

        // Elemento rectangular
        twoElem = two.makePolygon(
            xnode[ elem[0] - 1 ][0], xnode[ elem[0] - 1 ][1],
            xnode[ elem[1] - 1 ][0], xnode[ elem[1] - 1 ][1],
            xnode[ elem[2] - 1 ][0], xnode[ elem[2] - 1 ][1],
            xnode[ elem[3] - 1 ][0], xnode[ elem[3] - 1 ][1]
        );

        twoElem.fill = G_COLOR_ELEM;

        twoElem.type = 'elem';
        twoElem.k_ielem = k + 1;
        twoElem.ielem = elem;

        groupElem.add(twoElem);

        // And we add the text over the element
        paramsTextSVG = localParamsTextSVG;
        paramsTextSVG.x = 0.5 * ( xnode[ elem[0] - 1 ][0] + xnode[ elem[2] - 1 ][0] );
        paramsTextSVG.y = 0.5 * ( xnode[ elem[0] - 1 ][1] + xnode[ elem[2] - 1 ][1] );

        addElementToSVG(getTextSVG("element " + twoElem.k_ielem, paramsTextSVG));
    }

    // Then we draw the nodes
    for ( j = 0; j < xnode.length; j++ ) {
        twoNode = two.makeCircle(xnode[j][0], xnode[j][1], G_SHAPES_WIDTH * 0.02);
        twoNode.fill = G_COLOR_NODE;

        twoNode.type = 'node';
        twoNode.k_ielem = j + 1;
        twoNode.ielem = elem[j];

        groupNode.add(twoNode);

        // And we add the text over the node
        paramsTextSVG = localParamsTextSVG;
        paramsTextSVG.x = xnode[j][0];
        paramsTextSVG.y = xnode[j][1] + 2; // the +2 it's just for the text's vertical alignment

        addElementToSVG(getTextSVG(twoNode.k_ielem, paramsTextSVG));
    }

    groupNode.opacity = 0.95;
    groupElem.opacity = 0.7;

    two.add(groupElem);
    two.add(groupNode);

    return { 'elems' : groupElem, 'nodes' : groupNode };
}
