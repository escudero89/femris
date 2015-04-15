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

    var color_begin = "{" + inBrackets("color", G_COLOR_ELEM_HIGH);
    var color_end = "}"

    var k = 0;
    var j = 0;

    if (!$.isArray(toColor) || !$.isArray(nodes)) {
        throw new Error("getValuesColorised(): The args must be an array.");
    }

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
