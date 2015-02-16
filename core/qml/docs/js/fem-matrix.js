// MATRIX >>>>>>>>>

var G_COLOR_DEFAULT = "#f3f3f3";
var G_COLOR_EMPTY = "#737373";

var globalMatrixObject = {

    TwoMatrix : false,

    xnode : false,
    ielem : false,

    $drawMatrix : false,
    $drawMatrixDummy : false,
    matrixWidth : false,

    sideCell : false,
    cellDataMatrix : false,
    cellDataVectorPhi: false,
    cellDataVectorF: false,

    groupMatrix : false,
    groupVectorPhi : false,
    groupVectorF : false,

    group: false,

    /**
     * Get an object that indicates which node connects with whom
     *
     * @return {number[]} - The node and the connections (i.e., { xnode1 : [ xnode1, xnode2, ...], ... }
     */
    getNodeConnections : function () {

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
    },

    /**
     * Checks if a cell is empty, so we don't draw it.
     *
     * @param {number[]} valueOf - Value of the position of the cell inside the matrix/vector
     * @param {bool} isMatrix - Tells if the node belongs to a matrix (true) or not (false)
     * @return {bool} indicates if we draw it or not
     */
    isCellDifferentFromZero : function (valueOf, isMatrix) {

        var ielem = this.ielem;
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
    },

    /**
     * Colorise a cell (both stroke and fill). If it is inside a matrix, colorise
     * regarding if it has values or not inside (by checking the ielem)
     *
     * @param {Two.Cell()} twoCell - The element cell (it could be probably a Two.makeRectangle)
     * @param {bool} isCellDifferentFromZero - Indicates if it's empty or not
     * @return {Two.Cell} - The element cell
     */
    coloriseCell : function (twoCell, isCellDifferentFromZero) {

        if (isCellDifferentFromZero || !twoCell.isMatrix) {
            twoCell.fill_original = G_COLOR_DEFAULT;
            twoCell.stroke_original = "#b3b3b3";
        } else {
            twoCell.fill_original = G_COLOR_EMPTY;
            twoCell.stroke_original = G_COLOR_EMPTY;
        }

        twoCell.fill = twoCell.fill_original;
        twoCell.stroke = twoCell.stroke_original;

        return twoCell;
    },

    /**
     * Draws a cell
     *
     * @param {number[]} cellData - Information for creating the cell
     * @param {number[]} valueOf - Value of the position of the cell inside the matrix/vector
     * @param {bool} isMatrix - Tells if the node belongs to a matrix (true) or not (false)
     * @return {Two.makeRectangle() || bool} - The element cell or false if it doesn't have data
     */
    drawCell : function (cellData, valueOf, isMatrix) {

        isMatrix = assignIfNecessary(isMatrix, false);

        var isDifferentFromZero = isMatrix && this.isCellDifferentFromZero(valueOf, isMatrix);
        var twoCell = false;

        // Vectors are all always different from zero
        if (isDifferentFromZero || !isMatrix) {
            twoCell = this.TwoMatrix.makeRectangle(
                cellData.iniPosX + cellData.sideCell / 2 + cellData.sideCell * ( valueOf.col - 1),
                cellData.iniPosY + cellData.sideCell / 2 + cellData.sideCell * ( valueOf.row - 1),
                cellData.sideCell - 1,
                cellData.sideCell - 1
            );

            twoCell.id_cell = valueOf.col + this.xnode.length * ( valueOf.row - 1);
            twoCell.id_row = valueOf.row;
            twoCell.id_col = valueOf.col;
            twoCell.isMatrix = isMatrix;

            this.coloriseCell(twoCell, isDifferentFromZero);
        }

        return twoCell;
    },


    /**
     * Transform a string of SVG code into an object that can work along with Two.js
     * More info at: http://stackoverflow.com/a/3642265/1104116
     *
     * @param {number[]} cellData - Information for creating the cells of the matrix
     * @return {Two.Group()} - The group that contains the matrix
     */
    drawMatrix : function (cellData) {

        var groupMatrix = new Two.Group();

        var valueOf = {
            'col' : 0,
            'row' : 0
        };

        // We draw the matrix as a collection of rectangles
        for ( valueOf.row = 1 ; valueOf.row <= this.xnode.length ; valueOf.row++ ) {
            for ( valueOf.col = 1 ; valueOf.col <= this.xnode.length ; valueOf.col++ ) {
                var cell = this.drawCell(cellData, valueOf, true);
                // We only add the cell if it's different from zero
                if (cell) {
                    groupMatrix.add(cell);
                }
            }
        }

        return groupMatrix;
    },

    /**
     * Transform a string of SVG code into an object that can work along with Two.js
     * More info at: http://stackoverflow.com/a/3642265/1104116
     *
     * @param {number[]} cellData - Information for creating the cells of the vector
     * @return {Two.Group()} - The group that contains the matrix
     */
    drawVector : function (cellData, sideVector) {

        sideVector = assignIfNecessary(sideVector, 'vertical');

        var i;

        var groupVector = new Two.Group();

        var valueOf = {
            'col' : 0,
            'row' : 0
        };

        // We draw the matrix as a collection of rectangles
        for ( i = 1 ; i <= this.xnode.length ; i++ ) {
            // It depends if we want a vertical or an horizontal vector
            if (sideVector === 'vertical') {
                valueOf.row = i;
            } else {
                valueOf.col = i;
            }

            groupVector.add(this.drawCell(cellData, valueOf));
        }

        return groupVector;
    },

    /**
     * Draws the background of the entire matrix shown in `ce_results`. What's
     * the idea here? If we've had made one cell for each empty cell, the result
     * is kind of laggy (because the are lots of empty cells). So, to avoid doing
     * that, we made a big rectangle that covers all the background of each
     * white cell (which are those with values in it).
     *
     * @param  {Object} data         Information used to set the origins of the rectangle
     * @param  {Object} boundingRect Information with the sizes of the background rectangle
     * @return {Two.Object()}        The rectangle as a Two.Object()
     */
    drawBackground : function (data, boundingRect) {

        var twoBackground = this.TwoMatrix.makePolygon(
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
    },

    /**
     * Initializes this object and mainly all the `ce_results` view.
     *
     * @param {string} baseSVG Name of the SVG identifier
     * @param {string} baseSVG Name of the SVG dummy identifier, to use as a  temporary SVG
     * @param {number[]} xnode - Position of the nodes (i.e., [[x1,y1], ..., [xN,yN]])
     * @param {number[]} ielem - Nodes in the element (i.e., [[xnode1,  ..., xnode4], ...)
     */
    setMatrixDrawing : function (baseSVG, baseSVGdummy, xnode, ielem) {

        if (this.TwoMatrix) {
            return this.group;
        }

        this.$drawMatrix = $('#' + baseSVG);
        this.$drawMatrixDummy = $('#' + baseSVGdummy);

        this.xnode = xnode;
        this.ielem = ielem;

        this.TwoMatrix = new Two({
                width: "100%",
                height: "100%"
            }).appendTo(document.getElementById(baseSVG).children[0]);


        this.matrixWidth = parseInt(this.$drawMatrix.css("width"));

        this.sideCell = (this.matrixWidth * 0.9 / ( xnode.length + 3 )) * .9;

        this.cellDataMatrix = {
            'iniPosX' : this.matrixWidth * 0.08,
            'iniPosY' : this.matrixWidth * 0.08 + G_HEIGHT_NAVBAR,
            'sideCell': this.sideCell
        };

        this.cellDataVectorPhi = {
            'iniPosX' : this.matrixWidth - this.matrixWidth * 0.08 + this.cellDataMatrix.sideCell,
            'iniPosY' : this.cellDataMatrix.iniPosY,
            'sideCell': this.cellDataMatrix.sideCell
        };

        this.cellDataVectorF = {
            'iniPosX' :
                ( this.cellDataMatrix.iniPosX + this.cellDataMatrix.sideCell * xnode.length +
                  this.cellDataVectorPhi.iniPosX ) * 0.5,
            'iniPosY' : this.cellDataMatrix.iniPosY,
            'sideCell': this.cellDataMatrix.sideCell
        };

        this.groupMatrix    = this.drawMatrix(this.cellDataMatrix);
        this.groupVectorPhi = this.drawVector(this.cellDataVectorPhi);
        this.groupVectorF   = this.drawVector(this.cellDataVectorF);

        this.group = {
            'groupMatrix'    : this.groupMatrix,
            'groupVectorPhi' : this.groupVectorPhi,
            'groupVectorF'   : this.groupVectorF,
        };

        this.TwoMatrix.add(this.drawBackground(this.cellDataMatrix, this.groupMatrix.getBoundingClientRect(true)));

        this.TwoMatrix.add(this.groupMatrix);

        this.TwoMatrix.add(this.groupVectorPhi);
        this.TwoMatrix.add(this.groupVectorF);

        this.TwoMatrix.update();

        this.updatePan();

        return this.group;
    },

    /**
     * Updates the SVG by adding controls to it (such as zoom and pan).
     */
    updatePan : function() {
        svgPanZoom('#draw-matrix svg', {
            panEnabled: true,
            controlIconsEnabled: true,
            zoomEnabled: true,
            dblClickZoomEnabled: false,
            zoomScaleSensitivity: 0.2,
            minZoom: 0.5,
            maxZoom: 10,
            fit: true,
            center: true,
            refreshRate: 'auto',
            beforeZoom: function(){},
            onZoom: function(){},
            beforePan: function(){},
            onPan: function(){}
        });
    },

};