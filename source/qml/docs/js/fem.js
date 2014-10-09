$(document).ready(function() {

    var vals = G_VALS;
    var xnode = G_XNODE;
    var ielem = G_IELEM;

    var value = [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ];

    // Make an instance of two and place it on the page.
    var elem = document.getElementById('draw-shapes').children[0];

    var params = { width: "100%", height: "100%" };
    var two = new Two(params).appendTo(elem);

    var group = makeElements(two, xnode, ielem);
    var groupElem = group.elems;

    // Don't forget to tell two to render everything
    // to the screen
    two.update();

    /*
    var cleanMatrix = getMatrixFromArray(vals);
    var coloredMatrix = {};
    var k = 0;

    /// @@TODO Emparejar nodos con colores. Crear elementos para todas las matrices
    /// y simplemente visualizar aquella que pongas el mouse arriba, mas que renderizar una a una.
    /// Y POR ZEUS FIJASE COMO ACHICAR ESE MATHJAX

    for ( k = 0 ; k < ielem.length ; k++ ) {
        coloredMatrix[k] = getMatrixFromArray(getValuesColorised(vals, ielem[k]));
    }
    */

    if (typeof(setMatrixDrawing) === 'function') {

        var groupSystem = setMatrixDrawing(xnode, ielem);
        var groupMatrix = groupSystem.groupMatrix;

        $.each(group, function(index, value) {
            $.each(group[index].children, function(idx, currentElem) {
                $(currentElem._renderer.elem)
                    .css('cursor', 'pointer')
                    .on('mouseenter', function(e) {
                        currentElem.fill = G_COLOR_ELEM_HIGH;
                        //UpdateMath(coloredMatrix[currentElem.k_ielem]);

                        // We set the color of  the cells of the matrix
                        coloriseDueToMouse(groupSystem, currentElem, true);

                        G_TWO_MATRIX.update();
                        two.update();

                    }).on('mouseleave', function(e) {

                        currentElem.fill = G_COLOR_ELEM;

                        // We clear the color of  the cells of the matrix
                        coloriseDueToMouse(groupSystem, currentElem, false);

                        //UpdateMath(cleanMatrix);

                        G_TWO_MATRIX.update();
                        two.update();
                    });
            });
        });

    }

    // If the window changes its size, we reload the page
    $(window).resize(function() {
        document.location.reload();
    });

    $("#draw-shapes svg").append(parseSVG($G_DRAW_SHAPES_DUMMY.html()));
});


function coloriseDueToMouse(groupSystem, currentElem, isEntering) {

    isEntering = assignIfNecessary(isEntering, false);

    // We set the color of  the cells of the matrix and the vector
    $.each(groupSystem, function(idxGroupChildren, valGroupChildren) {

        $.each(valGroupChildren.children, function(idx, currentCell) {

            if (isEntering === true) {
                coloriseDueToMouseHelper(currentElem, currentCell);
            } else {
                discolorDueToMouseHelper(currentElem, currentCell);
            }

        });

    });
}

function coloriseDueToMouseHelper(currentElem, currentCell) {

    var isEmptyCell = (currentCell.fill_original === G_COLOR_EMPTY);
    var needsColor = false;

    if (!isEmptyCell) {
        if (currentElem.type === 'elem') {
            var isInRow = ($.inArray(currentCell.id_row, currentElem.ielem) >= 0);
            var isInCol = ($.inArray(currentCell.id_col, currentElem.ielem) >= 0);

            if (currentCell.isMatrix) {
                needsColor = isInRow && isInCol;
            } else {
                needsColor = isInRow || isInCol;
            }

        } else {
            if (currentCell.id_row === currentElem.k_ielem ||
                currentCell.id_col === currentElem.k_ielem) {
                needsColor = true;
            }
        }
    }

    if (needsColor) {
        currentCell.fill = getColorFromIdx(currentElem.k_ielem - 1, 0.7);
        currentCell.stroke = getColorFromIdx(currentElem.k_ielem - 1);
        currentCell.opacity = 1;
    }

}

function discolorDueToMouseHelper(currentElem, currentCell, clearAll) {

    if (currentCell.fill_original === G_COLOR_EMPTY || assignIfNecessary(clearAll, false)) {
        currentCell.fill = G_COLOR_EMPTY;
        currentCell.stroke = G_COLOR_EMPTY;
    }

    if (currentCell.fill !== currentCell.fill_original) {
        currentCell.opacity = 0.2;
    }

}
