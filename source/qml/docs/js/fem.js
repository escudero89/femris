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

    var xnode = [
            [1, 1],
            [2, 1],
            [3, 1],
            [1, 2],
            [2, 2],
            [3, 2],
            [1, 3],
            [2, 3],
            [3, 3]
        ];

    var ielem = [
            [0, 1, 4, 3],
            [1, 2, 5, 4],
            [3, 4, 7, 6],
            [4, 5, 8, 7]
        ];

    var xnode = [
            [1, 1],
            [3, 1],
            [1, 2],
            [3, 2],
            [2, 1],
            [2, 2]
        ];

    var ielem = [
            [2, 5, 4, 0],
            [5, 3, 1, 4]
        ];


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

    var groupSystem = setMatrixDrawing(xnode, ielem);
    var groupMatrix = groupSystem.groupMatrix;

    $.each(group, function(index, value) {
        $.each(group[index].children, function(idx, val) {
            $(val._renderer.elem)
                .css('cursor', 'pointer')
                .on('mouseenter', function(e) {
                    var currentElem = group[index].children[idx];

                    currentElem.fill = G_COLOR_ELEM_HIGH;
                    //UpdateMath(coloredMatrix[currentElem.k_ielem]);

                    // We set the color of  the cells of the matrix
                    $.each(groupMatrix.children, function(idxMat, valMat) {
                        var currentCell = groupMatrix.children[idxMat];
                        if ($.inArray(currentCell.id_row, currentElem.ielem) >= 0 &&
                            $.inArray(currentCell.id_col, currentElem.ielem) >= 0) {
                            currentCell.fill = getColorFromIdx(currentElem.k_ielem - 1, 0.7);
                            currentCell.stroke = getColorFromIdx(currentElem.k_ielem - 1);
                            currentCell.opacity = 1;
                        }

                        if (currentElem.type === 'node' &&
                            (currentCell.id_row === currentElem.k_ielem ||
                             currentCell.id_col === currentElem.k_ielem)) {
                            currentCell.fill = getColorFromIdx(currentElem.k_ielem - 1, 0.7);
                            currentCell.stroke = getColorFromIdx(currentElem.k_ielem - 1);
                            currentCell.opacity = 1;
                        }
                    });

                    // We set the color of  the cells of the vector
                    $.each(groupSystem.groupVectorPhi.children, function(idxVecPhi, valVecPhi) {
                        var currentCell = groupSystem.groupVectorPhi.children[idxVecPhi];
                        if ($.inArray(currentCell.id_row, currentElem.ielem) >= 0) {
                            currentCell.fill = getColorFromIdx(currentElem.k_ielem - 1, 0.7);
                            currentCell.stroke = getColorFromIdx(currentElem.k_ielem - 1);
                            currentCell.opacity = 1;
                        }
                    });

                    $.each(groupSystem.groupVectorF.children, function(idxVecF, valVecF) {
                        var currentCell = groupSystem.groupVectorF.children[idxVecF];
                        if ($.inArray(currentCell.id_row, currentElem.ielem) >= 0) {
                            currentCell.fill = getColorFromIdx(currentElem.k_ielem - 1, 0.7);
                            currentCell.stroke = getColorFromIdx(currentElem.k_ielem - 1);
                            currentCell.opacity = 1;
                        }
                    });

                    G_TWO_MATRIX.update();
                    two.update();

                }).on('mouseleave', function(e) {
                    group[index].children[idx].fill = G_COLOR_ELEM;

                    $.each(groupMatrix.children, function(idxMat, valMat) {
                        var currentCell = groupMatrix.children[idxMat];

                        if (currentCell.fill_original === G_COLOR_EMPTY) {
                            currentCell.fill = G_COLOR_EMPTY;
                            currentCell.stroke = G_COLOR_EMPTY;
                        }

                        if (currentCell.fill !== currentCell.fill_original) {
                            currentCell.opacity = 0.4;
                        }
                    });

                    // We set the color of  the cells of the vector
                    $.each(groupSystem.groupVectorPhi.children, function(idxVecPhi, valVecPhi) {
                        var currentCell = groupSystem.groupVectorPhi.children[idxVecPhi];

                        if (currentCell.fill_original === G_COLOR_EMPTY) {
                            currentCell.fill = G_COLOR_EMPTY;
                            currentCell.stroke = G_COLOR_EMPTY;
                        }

                        if (currentCell.fill !== currentCell.fill_original) {
                            currentCell.opacity = 0.4;
                        }
                    });

                    $.each(groupSystem.groupVectorF.children, function(idxVecF, valVecF) {
                        var currentCell = groupSystem.groupVectorF.children[idxVecF];

                        if (currentCell.fill_original === G_COLOR_EMPTY) {
                            currentCell.fill = G_COLOR_EMPTY;
                            currentCell.stroke = G_COLOR_EMPTY;
                        }

                        if (currentCell.fill !== currentCell.fill_original) {
                            currentCell.opacity = 0.4;
                        }
                    });

                    //UpdateMath(cleanMatrix);

                    G_TWO_MATRIX.update();
                    two.update();
                });
        });
    });

    // If the window changes its size, we reload the page
    $(window).resize(function() {
        document.location.reload();
    });

    $("#draw-shapes svg").append(parseSVG($G_DRAW_SHAPES_DUMMY.html()));
});
