// MATRIX >>>>>>>>>

var G_COLOR_DEFAULT = "#f3f3f3";
var G_COLOR_EMPTY = "#737373";

// We set the SVG matrix as a global variable, and also the dummy (efficiency)
var $G_DRAW_MATRIX = $("#draw-matrix");
var $G_DRAW_MATRIX_DUMMY = $('#draw-matrix-dummy');

// We get in this variable the width of the SVG that contains the drawing
var G_MATRIX_WIDTH = parseInt($G_DRAW_MATRIX.css("width"));

// Make an instance of two and place it on the page.
var G_ELEM_MATRIX = document.getElementById('draw-matrix').children[0];

var G_PARAMS = { width: "100%", height: "100%" };
var G_TWO_MATRIX = new Two(G_PARAMS).appendTo(G_ELEM_MATRIX);

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
 * Checks if a cell is empty, so we don't draw it.
 *
 * @param {number[]} ielem - Nodes in the element (i.e., [[xnode1,  ..., xnode4], ...)
 * @param {number[]} valueOf - Value of the position of the cell inside the matrix/vector
 * @param {bool} isMatrix - Tells if the node belongs to a matrix (true) or not (false)
 * @return {bool} indicates if we draw it or not
 */
function isCellDifferentFromZero(ielem, valueOf, isMatrix) {

    var isDifferentFromZero = false;

    // Only if it's a matrix we are going to colorise the cells
    for ( var k = 0; k < ielem.length && isMatrix ; k++ ) {
        if ($.inArray(valueOf.row, ielem[k]) >= 0) {
            if ($.inArray(valueOf.col, ielem[k]) >= 0) {
                isDifferentFromZero = true;
                break;
            }
        }
    }

    return isDifferentFromZero;
}

/**
 * Colorise a cell (both stroke and fill). If it is inside a matrix, colorise
 * regarding if it has values or not inside (by checking the ielem)
 *
 * @param {Two.Cell()} - The element cell (it could be probably a Two.makeRectangle)
 * @param {number[]} xnode - Position of the nodes (i.e., [[x1,y1], ..., [xN,yN]])
 * @param {number[]} ielem - Nodes in the element (i.e., [[xnode1,  ..., xnode4], ...)
 * @param {number[]} valueOf - Value of the position of the cell inside the matrix/vector
 * @param {bool} isCellDifferentFromZero - Indicates if it's empty or not
 * @return {Two.Cell} - The element cell
 */
function coloriseCell(twoCell, ielem, valueOf, isCellDifferentFromZero) {

    if (isCellDifferentFromZero || !twoCell.isMatrix) {
        twoCell.fill_original = G_COLOR_DEFAULT;
        twoCell.stroke_original = "#b3b3b3";
    } else {
        twoCell.fill_original = G_COLOR_EMPTY;
        twoCell.stroke_original = G_COLOR_EMPTY;
    }

    twoCell.fill = twoCell.fill_original;
    twoCell.stroke = twoCell.stroke_original;

    twoCell.linewidth = 0;

    return twoCell;
}


/**
 * Draws a cell
 *
 * @param {number[]} xnode - Position of the nodes (i.e., [[x1,y1], ..., [xN,yN]])
 * @param {number[]} ielem - Nodes in the element (i.e., [[xnode1,  ..., xnode4], ...)
 * @param {number[]} cellData - Information for creating the cell
 * @param {number[]} valueOf - Value of the position of the cell inside the matrix/vector
 * @param {bool} isMatrix - Tells if the node belongs to a matrix (true) or not (false)
 * @return {Two.makeRectangle() || bool} - The element cell or false if it doesn't have data
 */
function drawCell(xnode, ielem, cellData, valueOf, isMatrix) {

    var isDifferentFromZero = isMatrix && isCellDifferentFromZero(ielem, valueOf, isMatrix);
    var twoCell = false;

    // Vectors are all always different from zero
    if (isDifferentFromZero || !isMatrix) {
        twoCell = G_TWO_MATRIX.makeRectangle(
            cellData.iniPosX + cellData.sideCell / 2 + cellData.sideCell * ( valueOf.col - 1),
            cellData.iniPosY + cellData.sideCell / 2 + cellData.sideCell * ( valueOf.row - 1),
            cellData.sideCell - 1,
            cellData.sideCell - 1
        );

        twoCell.id_cell = valueOf.col + xnode.length * ( valueOf.row - 1);
        twoCell.id_row = valueOf.row;
        twoCell.id_col = valueOf.col;
        twoCell.isMatrix = isMatrix;

        coloriseCell(twoCell, ielem, valueOf, isDifferentFromZero);
    }

    return twoCell;
}

/**
 * Transform a string of SVG code into an object that can work along with Two.js
 * More info at: http://stackoverflow.com/a/3642265/1104116
 *
 * @param {number[]} xnode - Position of the nodes (i.e., [[x1,y1], ..., [xN,yN]])
 * @param {number[]} ielem - Nodes in the element (i.e., [[xnode1,  ..., xnode4], ...)
 * @param {number[]} cellData - Information for creating the cells of the matrix
 * @return {Two.Group()} - The group that contains the matrix
 */
function drawMatrix(xnode, ielem, cellData) {

    var groupMatrix = new Two.Group();

    var valueOf = {
        'col' : 0,
        'row' : 0
    };

    // We draw the matrix as a collection of rectangles
    for ( valueOf.row = 1 ; valueOf.row <= xnode.length ; valueOf.row++ ) {
        for ( valueOf.col = 1 ; valueOf.col <= xnode.length ; valueOf.col++ ) {
            var cell = drawCell(xnode, ielem, cellData, valueOf, true);
            // We only add the cell if it's different from zero
            if (cell) {
                groupMatrix.add(cell);
            }
        }
    }

    return groupMatrix;
}

/**
 * Transform a string of SVG code into an object that can work along with Two.js
 * More info at: http://stackoverflow.com/a/3642265/1104116
 *
 * @param {number[]} xnode - Position of the nodes (i.e., [[x1,y1], ..., [xN,yN]])
 * @param {number[]} ielem - Nodes in the element (i.e., [[xnode1,  ..., xnode4], ...)
 * @param {number[]} cellData - Information for creating the cells of the vector
 * @return {Two.Group()} - The group that contains the matrix
 */
function drawVector(xnode, ielem, cellData, sideVector) {

    sideVector = assignIfNecessary(sideVector, 'vertical');

    var i;

    var groupVector = new Two.Group();

    var valueOf = {
        'col' : 0,
        'row' : 0
    };

    // We draw the matrix as a collection of rectangles
    for ( i = 1 ; i <= xnode.length ; i++ ) {
        // It depends if we want a vertical or an horizontal vector
        if (sideVector === 'vertical') {
            valueOf.row = i;
        } else {
            valueOf.col = i;
        }

        groupVector.add(drawCell(xnode, ielem, cellData, valueOf));
    }

    return groupVector;

}

function drawBackground(data, boundingRect) {

    var twoBackground = G_TWO_MATRIX.makePolygon(
        data.iniPosX, data.iniPosY,
        data.iniPosX + boundingRect.width, data.iniPosY,
        data.iniPosX + boundingRect.width, data.iniPosY + boundingRect.height,
        data.iniPosX, data.iniPosY + boundingRect.height,
        true
    );

    twoBackground.fill_original = G_COLOR_EMPTY;
    twoBackground.stroke_original = G_COLOR_EMPTY;

    twoBackground.fill = twoBackground.fill_original;
    twoBackground.stroke = twoBackground.stroke_original;

    return twoBackground;
}

function setMatrixDrawing(xnode, ielem) {

    var sideCell = (G_MATRIX_WIDTH * 0.9 / ( xnode.length + 3 ));

    var cellDataMatrix = {
        'iniPosX' : G_MATRIX_WIDTH * 0.08,
        'iniPosY' : G_MATRIX_WIDTH * 0.08 + G_HEIGHT_NAVBAR,
        'sideCell': sideCell
    };

    var cellDataVectorPhi = {
        'iniPosX' : G_MATRIX_WIDTH - G_MATRIX_WIDTH * 0.08 + cellDataMatrix.sideCell,
        'iniPosY' : cellDataMatrix.iniPosY,
        'sideCell': cellDataMatrix.sideCell
    };

    var cellDataVectorF = {
        'iniPosX' : ( cellDataMatrix.iniPosX + cellDataMatrix.sideCell * xnode.length + cellDataVectorPhi.iniPosX) * 0.5,
        'iniPosY' : cellDataMatrix.iniPosY,
        'sideCell': cellDataMatrix.sideCell
    };

    var groupMatrix = drawMatrix(xnode, ielem, cellDataMatrix);
    var groupVectorPhi = drawVector(xnode, ielem, cellDataVectorPhi);
    var groupVectorF = drawVector(xnode, ielem, cellDataVectorF);

    G_TWO_MATRIX.add(drawBackground(cellDataMatrix, groupMatrix.getBoundingClientRect(true)));

    G_TWO_MATRIX.add(groupMatrix);

    G_TWO_MATRIX.add(groupVectorPhi);
    G_TWO_MATRIX.add(groupVectorF);

    // And we render
    G_TWO_MATRIX.update();

    return {
        'groupMatrix' : groupMatrix,
        'groupVectorPhi' : groupVectorPhi,
        'groupVectorF' : groupVectorF,
    };
}
