// DRAW >>>>>>>>>

var G_COLOR_NODE = "#428bca";
var G_COLOR_ELEM = "#428bca";

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
 * @param {number} factorOfDeformation - How much is scaled the deformation (if any)
 * @return {Number[]} xnode - The array scaled
 */
function transformCoordinates(xnode, factorOfDeformation) {

    factorOfDeformation = assignIfNecessary(factorOfDeformation, 0); //38747.4

    var x_min = xnode[0][0];    // minimum x coordinate
    var x_max = x_min;          // maximum x coordinate

    var y_max = xnode[0][1];

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

        if (xnode[k][0] > y_max) {
            y_max = xnode[k][1]
        }
    }

    // Then we calculate the maximum width of SVG and with that we set the scale factor
    alpha = 8 / 10 * ( G_SHAPES_WIDTH / ( x_max - x_min ) );
    beta  = G_SHAPES_WIDTH / 10 * ( 1 - 8 * x_min / ( x_max - x_min ) );

    var new_xnode = [];

    // Finally we apply the scale factor to the coordinates
    for ( k = 0; k < xnode.length; k++ ) {
        //xnode[k][0] = alpha * xnode[k][0] + beta;
        //xnode[k][1] = alpha * ( y_max - xnode[k][1] ) + beta; // We need to flip de y-axis
        new_xnode[k] = [];
        new_xnode[k][0] = alpha * ( xnode[k][0] + G_DISPLACEMENTS[k][0] * factorOfDeformation ) + beta;
        new_xnode[k][1] = alpha * ( y_max - xnode[k][1] - G_DISPLACEMENTS[k][1] * factorOfDeformation) + beta; // We need to flip de y-axis

        new_xnode[k][1] += G_HEIGHT_NAVBAR;
    }

    return new_xnode;
}

// We define our domain under an Object
var domainObject = {

    two                             : false,
    xnode                           : false,
    ielem                           : false,
    currentValuesToColorise         : false,
    options                         : false,

    groupNode                       : false,
    groupElem                       : false,
    group                           : false,

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

            twoNode = this.two.makeCircle(this.xnode[j][0], this.xnode[j][1], G_SHAPES_WIDTH * 0.0175);

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

        $("#draw-shapes-dummy").html('<g></g>');
        $("#draw-shapes").html('<div class="two-container w100p" style="height: 93vh;"></div>');
        
        this.makeElements(this.xnode, this.ielem, this.options);

        this.two.update();
    },

    /**
     * Change the color of all the elements of the domain usign the new values passed
     *
     * @param {number[]}
     * @return {Two.group()}
     */
    changeColorDueToValues : function(options) {

        // We update our previous values
        this.currentValuesToColorise = options.valuesToColorise;
        this.options = options;

        // To use this inside jQuery's function we need to do this
        local = this;

        $.each(this.groupNode.children, function(idx, twoNode) {
            twoNode.fill = getColorFromInterpolation(
                options.valuesToColorise[twoNode.ielem], 
                options.minValue, 
                options.maxValue);

            twoNode.fill_original = twoNode.fill;
        });

        $.each(this.groupElem.children, function(idx, twoElem) {

            var xy_gravity_center = {
                'x' : 0,
                'y' : 0
            };

            var currentValueInterpolated = 0;

            for ( var j = 0; j < twoElem.ielem.length ; j++ ) {
                xy_gravity_center.x += local.xnode[ twoElem.ielem[j] - 1 ][0];
                xy_gravity_center.y += local.xnode[ twoElem.ielem[j] - 1 ][1];

                currentValueInterpolated += local.currentValuesToColorise[ twoElem.ielem[j] - 1 ];
            }

            twoElem.fill = getColorFromInterpolation(
                currentValueInterpolated / twoElem.ielem.length, 
                options.minValue, 
                options.maxValue);

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

        this.xnode = xnode;
        this.ielem = ielem;

        this.currentValuesToColorise = options.valuesToColorise;

        this.options = options;

        // And we draw the elements
        this.groupElem = this.drawElements();
        this.groupNode = this.drawNodes();

        this.two.add(this.groupElem);
        this.two.add(this.groupNode);

        this.group = { 'elems' : this.groupElem, 'nodes' : this.groupNode };

        // Don't forget to tell two to render everything to the screen
        this.two.update();

        // Adds the text
        $("#draw-shapes svg").append(parseSVG($G_DRAW_SHAPES_DUMMY.html()));
    }

};