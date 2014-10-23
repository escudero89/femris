var GROUP;

function drawCurrentMatrix(two, group) {

    if (typeof(setMatrixDrawing) === 'function') {

        var groupSystem = setMatrixDrawing(G_XNODE, G_IELEM);

        $.each(group, function(index, value) {
            $.each(group[index].children, function(idx, currentElem) {
                $(currentElem._renderer.elem)
                    .css('cursor', 'pointer')
                    .on('mouseenter', function(e) {
                        currentElem.fill = G_COLOR_ELEM_HIGH;

                        // We set the color of  the cells of the matrix
                        coloriseDueToMouse(groupSystem, currentElem, true);

                        G_TWO_MATRIX.update();
                        two.update();

                    }).on('mouseleave', function(e) {

                        currentElem.fill = currentElem.fill_original;

                        // We clear the color of  the cells of the matrix
                        coloriseDueToMouse(groupSystem, currentElem, false);

                        G_TWO_MATRIX.update();
                        two.update();
                    });
            });
        });

        $.each(groupSystem, function(index, value) {
            $.each(groupSystem[index].children, function(idx, currentCell) {
                $(currentCell._renderer.elem)
                    .css('cursor', 'pointer')
                    .on('mouseenter', function(e) {

                        currentCell.fill = G_COLOR_ELEM_HIGH;

                        $.each(group.nodes.children, function(idx, currentNode) {
                            if (currentNode.k_ielem === currentCell.id_row) {
                                currentNode.fill = G_COLOR_ELEM_HIGH;
                            } else {
                                currentNode.fill = currentNode.fill_original;
                            }
                        });

                        $.each(group.elems.children, function(idx, currentElem) {
                            if ($.inArray(currentCell.id_row, currentElem.ielem) !== -1) {
                                currentElem.fill = G_COLOR_ELEM_HIGH;
                            } else {
                                currentElem.fill = currentElem.fill_original;
                            }
                        });

                        // We set the color of  the cells of the matrix
                        //coloriseDueToMouse(groupSystem, currentElem, true);

                        G_TWO_MATRIX.update();
                        two.update();

                    }).on('mouseleave', function(e) {

                        currentCell.fill = currentCell.fill_original;

                        $.each(group.nodes.children, function(idx, currentNode) {
                            currentNode.fill = currentNode.fill_original;
                        });

                        $.each(group.elems.children, function(idx, currentElem) {
                            currentElem.fill = currentElem.fill_original;
                        });

                        // We clear the color of  the cells of the matrix
                        //coloriseDueToMouse(groupSystem, currentElem, false);

                        G_TWO_MATRIX.update();
                        two.update();
                    });
            });
        });

    }
}

function getSingleColFromCurrentDomain(variable, col_idx) {

    var singleCol = [];

    if ($.isArray(col_idx)) {

        $.each(col_idx, function(idx, val) {
            if (singleCol.length > 0) {
                singleCol = getSingleColFromCurrentDomainHelper(variable, val, singleCol);
            } else {
                singleCol = getSingleColFromCurrentDomainHelper(variable, val);
            }
        });

        $.each(singleCol, function(idx, val) {
            singleCol[idx] = Math.sqrt(val);
        });

    } else {
        singleCol = getSingleColFromCurrentDomainHelper(variable, col_idx);
    }

    return singleCol;

}

function getSingleColFromCurrentDomainHelper(variable, col_idx, singleColumnArrayPassed) {

    if (!exists(G_CURRENT_DOMAIN[variable])) {
        throw new Error("getSingleColFromCurrentDomain() : Invalid variable [" + variable + "]")
    }

    assignIfNecessary(singleColumnArrayPassed, false);
    var singleColArray = (singleColumnArrayPassed) ? singleColumnArrayPassed : [];

    if (singleColumnArrayPassed) {
        for ( var k = 0 ; k < G_CURRENT_DOMAIN[variable].length ; k++ ) {
            singleColArray[k] = Math.pow(singleColArray[k], 2) + Math.pow(G_CURRENT_DOMAIN[variable][k][col_idx], 2);
        }
    } else {
        for ( var k = 0 ; k < G_CURRENT_DOMAIN[variable].length ; k++ ) {
            singleColArray.push(G_CURRENT_DOMAIN[variable][k][col_idx]);
        }
    }

    return singleColArray;

}

function drawCurrentDomain(two, xnode, ielem, params) {

    assignIfNecessary(params, false);
    var options = false;

    var localParamsTextSVG = {          // These are the text's params shared locally
        'fill'           : 'black',
        'font-family'    : 'Georgia',
        'pointer-events' : 'none',
        'style'          : 'cursor:pointer',
        'text-anchor'    : 'middle',
        'font-size'      : 0.125 * Math.abs( xnode[ ielem[0][2] - 1 ][1] - xnode[ ielem[0][0] - 1 ][1] )
    };

    if (localParamsTextSVG['font-size'] === 0) {
        localParamsTextSVG['font-size'] = 0.25 * Math.abs( xnode[ ielem[0][1] - 1 ][1] - xnode[ ielem[0][0] - 1 ][1] );
    }

    localParamsTextSVG['font-size'] = 12;

    if (params.valuesToColorise) {

        // For the colors
        options = {
            minValue : params.valuesToColorise[0],
            maxValue : params.valuesToColorise[0],
            localParamsTextSVG : localParamsTextSVG
        };

        for ( k = 0 ; k < params.valuesToColorise.length ; k++ ) {
            if (params.valuesToColorise[k] > options.maxValue) {
                options.maxValue = params.valuesToColorise[k];
            }
            if (params.valuesToColorise[k] < options.minValue) {
                options.minValue = params.valuesToColorise[k];
            }
        }

    }

    return makeElements(two, G_XNODE, G_IELEM, params.valuesToColorise, options);

}


$(document).ready(function() {

    // Make an instance of two and place it on the page.
    var elem = document.getElementById('draw-shapes').children[0];

    var params = { width: "100%", height: "100%" };
    var two = new Two(params).appendTo(elem);

    var options = {
        valuesToColorise : getSingleColFromCurrentDomain('displacements', 1)
    }

    // We transform the original coordinates so they can fit better in the SVG
    G_XNODE = transformCoordinates(G_XNODE);

    var group = drawCurrentDomain(two, G_XNODE, G_IELEM, options);

    // Don't forget to tell two to render everything
    // to the screen
    two.update();

    $(".visualization li").on('click', function(e) {
        var $this = $(this);

        $(".visualization li").removeClass("active");
        $this.addClass("active");

        var whichVariable = $this.parent().attr('name');
        var indexColumn = $this.attr('name');

        if (indexColumn.search(',') > 0) {
            indexColumn = indexColumn.split(',');
        }

        options = {
            valuesToColorise : getSingleColFromCurrentDomain(whichVariable, indexColumn)
        }

        two.clear();

        GROUP = drawCurrentDomain(two, G_XNODE, G_IELEM, options);

        two.update();
    });

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

    drawCurrentMatrix(two, group);

    // If the window changes its size, we reload the page
  //  $(window).resize(function() {
  //      document.location.reload();
  //  });

    // Adds the text
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
        currentCell.fill = currentCell.fill_original;
        currentCell.stroke = currentCell.stroke_original;
    }

}
