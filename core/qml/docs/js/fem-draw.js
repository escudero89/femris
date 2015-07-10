// DRAW >>>>>>>>>

var G_COLOR_NODE = "#428bca";
var G_COLOR_ELEM = "#428bca";

// We set the SVG as a global variable, and also the dummy (efficiency)
var G_DRAW_SHAPES = "#draw-shapes";
var G_DRAW_SHAPES_DUMMY = '#draw-shapes-dummy';

// We get in this variable the width of the SVG that contains the drawing
var G_SHAPES_WIDTH = parseInt($(G_DRAW_SHAPES).css("width"));

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
    $(G_DRAW_SHAPES_DUMMY).children().append(elem);
}

/**
 * Scales an array of xnode
 *
 * @param {number[]} xnode - An array of nodes (i.e., [[x1,y1], ..., [xN,yN]])
 * @param {number} factorOfDeformation - How much is scaled the deformation (if any)
 * @return {Number[]} xnode - The array scaled
 */
function transformCoordinates(xnode, factorOfDeformation) {

    factorOfDeformation = assignIfNecessary(factorOfDeformation, 0); //38747.4

    var x_min = xnode[0][0];    // minimum x coordinate
    var x_max = x_min;          // maximum x coordinate

    var y_max = xnode[0][1];
    var y_min_pixel = false;

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

        if (xnode[k][1] > y_max) {
            y_max = xnode[k][1];
        }
    }

    var max_width_figure = G_SHAPES_WIDTH - 100;

    // Then we calculate the maximum width of SVG and with that we set the scale factor
    alpha = 8 / 10 * ( max_width_figure / ( x_max - x_min ) );
    beta  = max_width_figure / 10 * ( 1 - 8 * x_min / ( x_max - x_min ) );

    var new_xnode = [];

    // Finally we apply the scale factor to the coordinates
    for ( k = 0; k < xnode.length; k++ ) {
        new_xnode[k] = [];

        if (G_DISPLACEMENTS.length > 0 && factorOfDeformation && factorOfDeformation !== 0) {
            new_xnode[k][0] = xnode[k][0] + G_DISPLACEMENTS[k][0] * factorOfDeformation;
            new_xnode[k][1] = y_max - xnode[k][1] - G_DISPLACEMENTS[k][1] * factorOfDeformation; // We need to flip de y-axis
        } else {
            new_xnode[k][0] = xnode[k][0];
            new_xnode[k][1] = y_max - xnode[k][1];
        }
        new_xnode[k][0] = new_xnode[k][0] * alpha + beta;
        new_xnode[k][1] = new_xnode[k][1] * alpha + beta;

        if (y_min_pixel > new_xnode[k][1] || !y_min_pixel) {
            y_min_pixel = new_xnode[k][1];
        }
    }

    for ( k = 0 ; k < new_xnode.length ; k++ ) {
        new_xnode[k][1] += G_HEIGHT_NAVBAR - y_min_pixel;
    }

    return new_xnode;
}

// We define our domain under an Object
var domainObject = {

    two                             : false,
    twoScale                        : false,

    xnode                           : false,
    ielem                           : false,
    currentValuesToColorise         : false,
    options                         : false,

    groupNode                       : false,
    groupElem                       : false,
    group                           : false,

    showScale                       : true,

    resetCanvas : function() {
        $("#draw-shapes-dummy").html('<g></g>');
        $("#draw-shapes").html('<div class="two-container w100p" style="height: 90vh;"></div>');
    },

    drawScale : function() {

        this.twoScale = new Two.Group();

        var min_X = G_SHAPES_WIDTH - 90;
        var min_Y = 20;

        var width = 10;

        var N_blocks = Math.max(Math.ceil(this.xnode.length / 2), 7);

        var blockHeight = this.options.localParamsTextSVG["font-size"] * 2;

        for ( kBlock = 0; kBlock < N_blocks ; kBlock++ ) {

            var y_start = min_Y + blockHeight * kBlock;
            var y_end = y_start + blockHeight;

            twoBlock = this.two.makePolygon(
                min_X, y_start,
                min_X + width, y_start,
                min_X + width, y_end,
                min_X, y_end);

            twoBlock.fill = getColorFromInterpolation(kBlock, 0, N_blocks);

            var gamma = kBlock / ( N_blocks - 1 );
            twoBlock.representedValue = (1 - gamma) * this.options.minValue + gamma * this.options.maxValue;

            paramsTextSVG = this.options.localParamsTextSVG;

            paramsTextSVG.x = min_X + width + 10;
            paramsTextSVG.y = y_start + blockHeight * 0.5 + paramsTextSVG["font-size"] * 0.5;
            paramsTextSVG["text-anchor"] = "left";
            paramsTextSVG["part-of-scale"] = true;

            addElementToSVG(getTextSVG(Utils.parseNumber(twoBlock.representedValue), paramsTextSVG));

            this.twoScale.add(twoBlock);
        }

        // This is a hack, to actually know which object in the SVG is the scale
        this.twoScale.opacity = G_SCALE_OPACITY;

        this.two.add(this.twoScale);
    },

    drawElement : function (k, isTriangle) {

        isTriangle = assignIfNecessary(isTriangle, false);

        var twoElem;
        var elem = this.ielem[k];

        if (isTriangle) {
            twoElem = this.two.makePolygon(
                this.xnode[ elem[0] - 1 ][0], this.xnode[ elem[0] - 1 ][1],
                this.xnode[ elem[1] - 1 ][0], this.xnode[ elem[1] - 1 ][1],
                this.xnode[ elem[2] - 1 ][0], this.xnode[ elem[2] - 1 ][1]
            );
        } else {
            twoElem = this.two.makePolygon(
                this.xnode[ elem[0] - 1 ][0], this.xnode[ elem[0] - 1 ][1],
                this.xnode[ elem[1] - 1 ][0], this.xnode[ elem[1] - 1 ][1],
                this.xnode[ elem[2] - 1 ][0], this.xnode[ elem[2] - 1 ][1],
                this.xnode[ elem[3] - 1 ][0], this.xnode[ elem[3] - 1 ][1]
            );
        }

        twoElem.type = 'elem';
        twoElem.k_ielem = k + 1;
        twoElem.ielem = elem;

        twoElem.currentValue = 0;
        for ( var kNode = 0 ; kNode < elem.length ; kNode++ ) {
            twoElem.currentValue += this.options.valuesToColorise[elem[kNode] - 1];
        }
        twoElem.currentValue /= elem.length;
        return twoElem;
    },

    drawElements : function () {

        this.options = assignIfNecessary(this.options, false);
        this.currentValuesToColorise = assignIfNecessary(this.currentValuesToColorise, false);

        var paramsTextSVG;

        var groupElem = new Two.Group();

        // We don't count the first col of index
        var isTriangle = (this.ielem[0].length === 3);

        // First we draw the elements
        for ( var k = 0 ; k < this.ielem.length ; k++ ) {

            // We add the polygon
            var twoElem = this.drawElement(k, isTriangle);

            var xy_gravity_center = {
                'x' : 0,
                'y' : 0
            };

            var currentValueInterpolated = 0;

            var elem = this.ielem[k];

            for ( var j = 0; j < elem.length ; j++ ) {
                xy_gravity_center.x += this.xnode[ elem[j] - 1 ][0];
                xy_gravity_center.y += this.xnode[ elem[j] - 1 ][1];

                currentValueInterpolated += this.currentValuesToColorise[ elem[j] - 1 ];
            }

            if ( this.options && this.options.localParamsTextSVG ) {
                // And we add the text over the element
                paramsTextSVG = this.options.localParamsTextSVG;

                paramsTextSVG.x = xy_gravity_center.x / elem.length;
                paramsTextSVG.y = xy_gravity_center.y / elem.length;

                addElementToSVG(getTextSVG("e" + twoElem.k_ielem, paramsTextSVG));
            }

            // And we paint the element (by interpolation between the values of the nodes)
            if (this.currentValuesToColorise && this.options) {
                twoElem.fill = getColorFromInterpolation(
                    currentValueInterpolated / elem.length,
                    this.options.minValue,
                    this.options.maxValue);

            } else {
                twoElem.fill = G_COLOR_ELEM;
            }

            twoElem.fill_original = twoElem.fill;

            groupElem.add(twoElem);
        }

        groupElem.opacity = 0.7;

        return groupElem;
    },

    drawNodes : function () {

        var twoNode;
        var paramsTextSVG;
        var groupNode = new Two.Group();

        // Then we draw the nodes
        for ( var j = 0; j < this.xnode.length; j++ ) {

            var radius = G_SHAPES_WIDTH * 0.0175;

            twoNode = this.two.makeCircle(this.xnode[j][0], this.xnode[j][1], radius);

            if (this.currentValuesToColorise && this.options) {

                twoNode.fill = getColorFromInterpolation(
                    this.currentValuesToColorise[j],
                    this.options.minValue,
                    this.options.maxValue);

            } else {
                twoNode.fill = G_COLOR_ELEM;
            }

            twoNode.fill_original = twoNode.fill;

            twoNode.type = 'node';
            twoNode.k_ielem = j + 1;
            twoNode.ielem = j;

            twoNode.currentValue = this.options.valuesToColorise[j];

            groupNode.add(twoNode);

            // And we add the text over the node
            if ( this.options && this.options.localParamsTextSVG ) {
                paramsTextSVG = this.options.localParamsTextSVG;

                paramsTextSVG.x = this.xnode[j][0];
                paramsTextSVG.y = this.xnode[j][1] + this.options.localParamsTextSVG['font-size'] * 0.25; // just for the text's vertical alignment

                addElementToSVG(getTextSVG(twoNode.k_ielem, paramsTextSVG));
            }
        }

        groupNode.opacity = 0.95;

        return groupNode;
    },

    changeFactorOfDeformation : function(xnode, factorOfDeformation) {

        this.xnode = transformCoordinates(xnode, factorOfDeformation);

        this.resetCanvas();

        this.makeElements(this.xnode, this.ielem, this.options);

        drawCurrentMatrix(this.two, this.group);
    },

    /**
     * Change the color of all the elements of the domain usign the new values passed
     *
     * @param {number[]}
     * @return {Two.group()}
     */
    changeColorDueToValues : function(options) {

        // We change first the scale
        this.drawScale();

        // We update our previous values
        this.options = assignIfNecessary(options,  this.options);
        this.currentValuesToColorise = this.options.valuesToColorise;

        // To use this inside jQuery's function we need to do this
        self = this;

        $.each(this.groupNode.children, function(idx, twoNode) {
            twoNode.currentValue = self.options.valuesToColorise[twoNode.ielem];
            twoNode.fill = getColorFromInterpolation(
                twoNode.currentValue,
                self.options.minValue,
                self.options.maxValue);

            twoNode.fill_original = twoNode.fill;
        });

        $.each(this.groupElem.children, function(idx, twoElem) {

            var xy_gravity_center = {
                'x' : 0,
                'y' : 0
            };

            var currentValueInterpolated = 0;

            for ( var j = 0; j < twoElem.ielem.length ; j++ ) {
                xy_gravity_center.x += self.xnode[ twoElem.ielem[j] - 1 ][0];
                xy_gravity_center.y += self.xnode[ twoElem.ielem[j] - 1 ][1];

                currentValueInterpolated += self.currentValuesToColorise[ twoElem.ielem[j] - 1 ];
            }

            twoElem.currentValue = currentValueInterpolated / twoElem.ielem.length;
            twoElem.fill = getColorFromInterpolation(
                twoElem.currentValue,
                self.options.minValue,
                self.options.maxValue);

            twoElem.fill_original = twoElem.fill;
        });

        this.two.update();

    },

    changeColorDueToValuesHelper : function (twoObject) {
        twoObject.fill = getColorFromInterpolation(
            this.currentValuesToColorise[j],
            this.options.minValue,
            this.options.maxValue);

        return twoObject;
    },

    /**
     * Basis function that creates the drawing of the domain in SVG
     * @return {Two.group()}
     */
    makeElements : function (xnode, ielem, options) {

        // Make an instance of two and place it on the page.
        this.two = new Two({
                width: "100%",
                height: "100%"
            }).appendTo(document.getElementById('draw-shapes').children[0]);

        this.xnode = assignIfNecessary(xnode,  this.xnode);
        this.ielem = assignIfNecessary(ielem,  this.ielem);
        this.options = assignIfNecessary(options,  this.options);

        this.currentValuesToColorise = this.options.valuesToColorise;

        // And we draw the elements
        this.groupElem = this.drawElements();
        this.groupNode = this.drawNodes();

        this.two.clear();
        this.two.add(this.groupElem);
        this.two.add(this.groupNode);

        this.group = { 'elems' : this.groupElem, 'nodes' : this.groupNode };

        // Add the scale
        if (this.showScale) {
            this.drawScale();
        }

        // Don't forget to tell two to render everything to the screen
        this.two.update();

        // Adds the text
        var drawShapes = "#draw-shapes svg";
        $(drawShapes).append(parseSVG($(G_DRAW_SHAPES_DUMMY).html()));

        svgPanZoom(drawShapes, {
            panEnabled: true,
            controlIconsEnabled: false,
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
    }
};