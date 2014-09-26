// MATRIX >>>>>>>>>

var G_COLOR_DEFAULT = "#c3c3c3";

// We set the SVG matrix as a global variable, and also the dummy (efficiency)
var $G_DRAW_MATRIX = $("#draw-matrix");
var $G_DRAW_MATRIX_DUMMY = $('#draw-matrix-dummy');

// We get in this variable the width of the SVG that contains the drawing
var G_MATRIX_WIDTH = parseInt($G_DRAW_MATRIX.css("width"));

// Make an instance of two and place it on the page.
var elem = document.getElementById('draw-matrix').children[0];

var params = { width: "100%", height: "100%" };
var twoMatrix = new Two(params).appendTo(elem);

/**
 * Get an object that indicates which node connects with whom
 *
 * @param {number[]} xnode - Position of the nodes (i.e., [[x1,y1], ..., [xN,yN]])
 * @param {number[]} ielem - Nodes in the element (i.e., [[xnode1,  ..., xnode4], ...)
 * @return {number[]} - The node and the connections (i.e., { xnode1 : [ xnode1, xnode2, ...], ... }
 */
function getNodeConnections(xnode, ielem) {

    var k, j;
    var connections = {};

    for ( k = 0 ; k < xnode.length ; k++ ) {
        for ( j = 0 ; j < ielem.length ; j++ ) {
            if ($.inArray(k, ielem[j]) >= 0) {
                // If it hasn't already a ielem associated
                if (connections[k]) {
                    connections[k] = connections[k].concat(ielem[j]);
                } else {
                    connections[k] = ielem[j];
                }
            }
        }
        connections[k] = $.unique(connections[k]);
    }

    return connections;
}

/**
 * Get a color from a particular idx
 *
 * @param {number} idx - Index of reference for the color
 * @return {string} - The color in format RGB Hex Code
 */
function getColorFromIdx(idx) {
    var colorLevel = [ 255, 210, 168, 126, 84, 42 ];     // Values RGB to consider
    var combinations = [
                [ 1.00,    0.00,    0.00 ],
                [ 1.00,    0.50,    0.00 ],
                [ 0.75,    0.75,    0.00 ],
                [ 1.00,    1.00,    0.00 ],
                [ 0.50,    1.00,    0.00 ],
                [ 0.00,    1.00,    0.00 ],
                [ 0.00,    1.00,    0.50 ],
                [ 0.00,    1.00,    1.00 ],
                [ 0.00,    0.75,    0.75 ],
                [ 0.00,    0.50,    1.00 ],
                [ 0.00,    0.00,    1.00 ],
                [ 0.50,    0.00,    1.00 ],
                [ 1.00,    0.00,    1.00 ],
                [ 0.75,    0.00,    0.75 ]
            ];

    var numberOfLevels = combinations.length;       // Amount of gradients to consider

    // We calculted what kind of color we are going to choose
    var combinationChose = idx % numberOfLevels;
    var colorLevelChose = Math.floor(idx / numberOfLevels);

    // And we get the color in RGB Hex code
    var colorGet = "#";
    var subColorGet = "";                           // For adding zeros in front if needed

    $.each(combinations[combinationChose], function(idx, val) {
        subColorGet = Math.floor(val * colorLevel[colorLevelChose]);

        colorGet += ((subColorGet < 15) ? "0" : "") + subColorGet.toString(16);
    });

    return colorGet;
}

/**
 * Transform a string of SVG code into an object that can work along with Two.js
 * More info at: http://stackoverflow.com/a/3642265/1104116
 *
 * @param {Two} two - A Two Object
 * @param {number[]} xnode - Position of the nodes (i.e., [[x1,y1], ..., [xN,yN]])
 * @param {number[]} ielem - Nodes in the element (i.e., [[xnode1,  ..., xnode4], ...)
 * @param {number} matrix_width - The width of the matrix (is a square matrix)
 * @return {Two.Group()} - The group that contains the matrix
 */
function drawMatrix(xnode, ielem, matrix_width) {

    if (typeof matrix_width === undefined) {
        matrix_width = G_MATRIX_WIDTH;
    }

    var k, i, j, twoCell;

    var groupMatrix = new Two.Group();

    var localParamsTextSVG = {          // These are the text's params shared locally
        'text-anchor' : 'middle',
        'fill' : 'white',
        'font-family' : 'Georgia'
    };

    var sideRectangle = matrix_width * 0.8 / ( xnode.length - 1 ); // to get the size of each rectangle

    var iniPosX = G_MATRIX_WIDTH * 0.1;
    var iniPosY = iniPosX;

    var nodeConnections = getNodeConnections(xnode, ielem);

    // We draw the matrix as a collection of rectangles
    for ( i = 0 ; i < xnode.length ; i++ ) {
        for ( j = 0 ; j < xnode.length ; j++ ) {
            twoCell = twoMatrix.makeRectangle(
                iniPosX + sideRectangle * j,
                iniPosY + sideRectangle * i,
                sideRectangle,
                sideRectangle
            )

            twoCell.id_cell = j + xnode.length * i;
            twoCell.id_row = i;
            twoCell.id_col = j;

            // We check if the cell has a content != 0
            var isDifferentFromZero = false;

            for ( k = 0; k < ielem.length ; k++ ) {
                if ($.inArray(i, ielem[k]) >= 0) {
                    if ($.inArray(j, ielem[k]) >= 0) {
                        isDifferentFromZero = true;
                        break;
                    }
                }
            }

            if (isDifferentFromZero) {
                twoCell.fill_original = "#f5f5f5";
                twoCell.stroke_original = "#b3b3b3";
            } else {
                twoCell.fill_original = "#535353";
                twoCell.stroke_original = "#535353";
            }
            twoCell.fill = twoCell.fill_original;
            twoCell.stroke = twoCell.stroke_original;

            groupMatrix.add(twoCell);
        }
    }

    return groupMatrix;
}

function setMatrixDrawing(xnode, ielem) {

    var groupMatrix = drawMatrix(xnode, ielem, G_MATRIX_WIDTH);

    twoMatrix.add(groupMatrix);

    // And we render
    twoMatrix.update();

    return groupMatrix;
}
