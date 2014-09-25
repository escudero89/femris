// We define some variables for the colors
var G_COLOR_NODE = "#428bca";
var G_COLOR_ELEM = "#428bca";
var G_COLOR_NODE_HIGH = "#d9534f";
var G_COLOR_ELEM_HIGH = "#d9534f";

// We set the SVG as a global variable
var $draw_shapes = $("#draw-shapes");
// We get in this variable the width of the SVG that contains the drawing
var G_SVG_WIDTH = parseInt($draw_shapes.css("width"));

//
//  Use a closure to hide the local variables from the
//  global namespace
//
(function () {
  var QUEUE = MathJax.Hub.queue;  // shorthand for the queue
  var math = null, box = null;    // the element jax for the math output, and the box it's in

  //
  //  Hide and show the box (so it doesn't flicker as much)
  //
  var HIDEBOX = function () { box.style.visibility = "hidden"; };
  var SHOWBOX = function () { box.style.visibility = "visible"; };

  //
  //  Get the element jax when MathJax has produced it.
  //
  QUEUE.Push(function () {
    math = MathJax.Hub.getAllJax("MathOutput")[0];
    box = document.getElementById("box");
    SHOWBOX(); // box is initially hidden so the braces don't show
  });

  //
  //  The onchange event handler that typesets the math entered
  //  by the user.  Hide the box, then typeset, then show it again
  //  so we don't see a flash as the math is cleared and replaced.
  //
  window.UpdateMath = function (TeX) {
    QUEUE.Push(HIDEBOX,["Text",math,"\\displaystyle{"+TeX+"}"],SHOWBOX);
  }
})();


$(document).ready(function() {

    var vals = [
        [0.587445, 0.484894, 0.245598, 0.604323, 0.129146, 0.458100, 0.713108, 0.747160, 0.516963],
        [0.881006, 0.532887, 0.300065, 0.837708, 0.518044, 0.071721, 0.654554, 0.298611, 0.903679],
        [0.536209, 0.035956, 0.723490, 0.461836, 0.167532, 0.976723, 0.230542, 0.502724, 0.718038],
        [0.015075, 0.125571, 0.393736, 0.983757, 0.560972, 0.346201, 0.713542, 0.561844, 0.849061],
        [0.757630, 0.024854, 0.522397, 0.819440, 0.634520, 0.371704, 0.248686, 0.473830, 0.402779],
        [0.794432, 0.992714, 0.021068, 0.054128, 0.589138, 0.060303, 0.642738, 0.192282, 0.289880],
        [0.126489, 0.229472, 0.404732, 0.137177, 0.482097, 0.224747, 0.815592, 0.793930, 0.541828],
        [0.587169, 0.846094, 0.974844, 0.665319, 0.246566, 0.866242, 0.315658, 0.776319, 0.672187],
        [0.776183, 0.530135, 0.633979, 0.672511, 0.243535, 0.146311, 0.384157, 0.532671, 0.542968]
    ];

    var xnode = [[1,1], [2, 1], [3, 1], [1, 2], [2, 2], [3, 2], [1, 3], [2, 3], [3, 3]];
    var inode = [[0, 1, 4, 3], [1, 2, 5, 4], [3, 4, 7, 6], [4, 5, 8, 7]];
    var value = [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ];

    // Make an instance of two and place it on the page.
    var elem = document.getElementById('draw-shapes').children[0];

    var params = { width: "100%", height: "100%" };
    var two = new Two(params).appendTo(elem);

    var group = makeElements(two, xnode, inode);
    var groupElem = group.elems;

    // Don't forget to tell two to render everything
    // to the screen
    two.update();

    var cleanMatrix = getMatrixFromArray(vals);
    var coloredMatrix = {};
    var k = 0;

    /// @@TODO Emparejar nodos con colores. Crear elementos para todas las matrices
    /// y simplemente visualizar aquella que pongas el mouse arriba, mas que renderizar una a una.
    /// Y POR ZEUS FIJASE COMO ACHICAR ESE MATHJAX

    for ( k = 0 ; k < inode.length ; k++ ) {
        coloredMatrix[k] = getMatrixFromArray(getValuesColorised(vals, inode[k]));
    }

    $.each(group, function(index, value) {
        $.each(group[index].children, function(idx, val) {
            $(val._renderer.elem)
                .css('cursor', 'pointer')
                .on('mouseenter', function(e) {
                    var currentElem = group[index].children[idx];

                    currentElem.fill = G_COLOR_ELEM_HIGH;
                    UpdateMath(coloredMatrix[currentElem.k_inode]);

                    two.update();

                }).on('mouseleave', function(e) {
                    group[index].children[idx].fill = G_COLOR_ELEM;

                    UpdateMath(cleanMatrix);
                    console.log("exited");

                    two.update();
                });
        });
    });

    $("#zoom-in").on('click', function(e) {
        //UpdateMath(getMatrixFromArray(getValuesColorised(vals, [1,2])));
        UpdateMath(getMatrixFromArray(vals));
    });

    $("#zoom-out").on('click', function(e) {
        $.each(group, function(idx, val) {
            group[idx].scale *= 0.5;
        });
        two.update();
    });

    // If the window changes its size, we recalculate G_SVG_WIDTH
    $(window).resize(function() {
        var new_SVG_width = parseInt($draw_shapes.css("width"));

        $.each(group, function(idx, val) {
            group[idx].scale = (new_SVG_width / G_SVG_WIDTH);
        });

        two.update();
    });




    //fsetInterval(function() {UpdateMath(getMatrixFromArray(vals))}, 500);
});

/**
 * Puts the arg passed in brackets LaTeX style
 *
 * @param {string} bracket - The type of bracket (i.e, "begin")
 * @param {string} value - The string to be put in brackets
 * @return {string} value - The string enclosed (i.e., \\begin{value})
 */
function inBrackets(bracket, value) {
    return "\\" + bracket + "{" + value + "}";
}

/**
 * Puts color brackets in the values (as in LaTeX style), all rows and cols that
 * coincide with the nodes' index passed.
 *
 * @param {number[]} toColor - Array of values (i.e, [[a11, ..., a1N], ...])
 * @param {number[]} nodes - Array of nodes' index (i.e, [a1, a2, ..., aN])
 * @return {string} values - The array transformed into latex code
 */
function getValuesColorised(toColor, nodes) {

    var toColor = [
        [0.587445, 0.484894, 0.245598, 0.604323, 0.129146, 0.458100, 0.713108, 0.747160, 0.516963],
        [0.881006, 0.532887, 0.300065, 0.837708, 0.518044, 0.071721, 0.654554, 0.298611, 0.903679],
        [0.536209, 0.035956, 0.723490, 0.461836, 0.167532, 0.976723, 0.230542, 0.502724, 0.718038],
        [0.015075, 0.125571, 0.393736, 0.983757, 0.560972, 0.346201, 0.713542, 0.561844, 0.849061],
        [0.757630, 0.024854, 0.522397, 0.819440, 0.634520, 0.371704, 0.248686, 0.473830, 0.402779],
        [0.794432, 0.992714, 0.021068, 0.054128, 0.589138, 0.060303, 0.642738, 0.192282, 0.289880],
        [0.126489, 0.229472, 0.404732, 0.137177, 0.482097, 0.224747, 0.815592, 0.793930, 0.541828],
        [0.587169, 0.846094, 0.974844, 0.665319, 0.246566, 0.866242, 0.315658, 0.776319, 0.672187],
        [0.776183, 0.530135, 0.633979, 0.672511, 0.243535, 0.146311, 0.384157, 0.532671, 0.542968]
    ];

    var color_begin = "{" + inBrackets("color", G_COLOR_ELEM_HIGH);
    var color_end = "}"

    var k = 0;
    var j = 0;

    if (!$.isArray(toColor) || !$.isArray(nodes)) {
        throw new Error("getValuesColorised(): The args must be an array.");
    }
console.log(nodes);
    // We made a double loop, to cover all the cols and rols related to the indexs
    for ( k = 0; k < nodes.length; k++ ) {
        for ( j = 0; j < nodes.length; j++ ) {

            pos_idx_k = nodes[k];
            pos_idx_j = nodes[j];

            toColor[pos_idx_k][pos_idx_j]  =
                    color_begin +
                    toColor[pos_idx_k][pos_idx_j] +
                    color_end;
        }
    }

    return toColor;
}

/**
 * Transforms an array into LaTeX code. Warning: escaping "\".
 *
 * @param {number[]} values - Array of values (i.e, [[a11, ..., a1N], ...])
 * @return {string} bmatrix - The array transformed into latex code
 */
function getMatrixFromArray(values) {

    var bmatrix = inBrackets("begin", "bmatrix");
    var bmatrix_end = inBrackets("end", "bmatrix");

    var k = 0;
    var j = 0;

    if (!$.isArray(values)) {
        throw new Error("getMatrixFromArray(): The arg must be an array.");
    }

    for ( k = 0; k < values.length; k++ ) {
        for ( j = 0; j < values[k].length; j++ ) {

            bmatrix += values[k][j];

            // If we haven't reach the last element
            if ( j < values[k].length - 1 ) {
                bmatrix += " & ";
            }
        }
        // And finally we add the breakline
        bmatrix += "\\\\ ";
    }

    bmatrix += bmatrix_end;

    return bmatrix;
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
    alpha = 8 / 10 * ( G_SVG_WIDTH / ( x_max - x_min ) );
    beta  = G_SVG_WIDTH / 10 * ( 1 - 8 * x_min / ( x_max - x_min ) );

    // Finally we apply the scale factor to the coordinates
    for ( k = 0; k < xnode.length; k++ ) {
        xnode[k][0] = alpha * xnode[k][0] + beta;
        xnode[k][1] = alpha * xnode[k][1] + beta;
    }

    return xnode;
}

// Crea una serie de elementos y los agrupa, en base a un xnod = [x1 y1; x2 y2; ... ; xN yN]
// y un icone = [nodoA1 nodoA2 nodoA3 nodoA4 ; nodoN1 nodoN2 nodoN3 nodoN4]
// (el icone comienza con indice 0, no 1)
function makeElements(two, xnode, inode) {

    var groupElem = new Two.Group();
    var groupNode = new Two.Group();

    var k, j, elem, twoElem, twoNode;

    // We transform the original coordinates so they can fit better in the SVG
    xnode = transformCoordinates(xnode);

    for ( k = 0 ; k < inode.length ; k++ ) {
        elem = inode[k];

        // Elemento rectangular
        twoElem = two.makePolygon(
            xnode[elem[0]][0], xnode[elem[0]][1],
            xnode[elem[1]][0], xnode[elem[1]][1],
            xnode[elem[2]][0], xnode[elem[2]][1],
            xnode[elem[3]][0], xnode[elem[3]][1]
        );

        twoElem.fill = G_COLOR_ELEM;

        twoElem.k_inode = k;
        twoElem.inode = elem;

        for ( j = 0; j < elem.length; j++ ) {
            twoNode = two.makeCircle(xnode[elem[j]][0], xnode[elem[j]][1], G_SVG_WIDTH * 0.02);
            twoNode.fill = G_COLOR_NODE;

            twoNode.k_inode = elem[k];
            twoNode.inode = elem[j];

            groupNode.add(twoNode);
        }

        groupElem.add(twoElem);
    }

    groupNode.opacity = 0.95;
    groupElem.opacity = 0.7;

    two.add(groupElem);
    two.add(groupNode);

    return { 'elems' : groupElem, 'nodes' : groupNode };
}
