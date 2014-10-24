// We define some variables for the colors
var G_COLOR_NODE_HIGH = "#d9534f";
var G_COLOR_ELEM_HIGH = "#d9534f";

function drawCurrentMatrix(two, group) {

    //@TODO Optimizar el index de elementos. Podria crear un vector que mapee el id de Two con el ielem

    var groupSystem = globalMatrixObject.setMatrixDrawing('draw-matrix', 'draw-matrix-dummy', G_XNODE, G_IELEM);

    $.each(group, function(index, value) {
        $.each(group[index].children, function(idx, currentElem) {
            $(currentElem._renderer.elem)
                .css('cursor', 'pointer')
                .on('mouseenter', function(e) {
                    currentElem.fill = G_COLOR_ELEM_HIGH;

                    // We set the color of  the cells of the matrix
                    coloriseDueToMouse(groupSystem, currentElem, true);

                    globalMatrixObject.TwoMatrix.update();
                    two.update();

                }).on('mouseleave', function(e) {

                    currentElem.fill = currentElem.fill_original;

                    // We clear the color of  the cells of the matrix
                    coloriseDueToMouse(groupSystem, currentElem, false);

                    globalMatrixObject.TwoMatrix.update();
                    two.update();
                }).on('click', function (e){
                    
                    if (currentElem.type === 'elem') {

                        var currentXnode = [];

                        for ( var kNode = 0 ; kNode < currentElem.ielem.length ; kNode++ ) {
                            currentXnode.push(
                                [
                                    G_XNODE[currentElem.ielem[kNode] - 1][0],
                                    G_XNODE[currentElem.ielem[kNode] - 1][1]
                                ]
                            );

                            currentElem.ielem[kNode] = kNode + 1;
                        }

                        var $drawElementalMatrix = $('#draw-elemental-matrix');
                        var $drawMatrix = $("#draw-matrix");

                        $drawElementalMatrix.css('width', $drawMatrix.css('width'));
                        $drawElementalMatrix.css('height', $drawMatrix.css('height'));

                        $drawMatrix.fadeOut(400, function () {
                            $drawElementalMatrix.removeClass('hidden');
                            
                            elementalMatrixObject.setMatrixDrawing(
                                'draw-elemental-matrix', 
                                'draw-elemental-matrix-dummy', 
                                currentXnode,
                                [currentElem.ielem]
                            );

                            $drawElementalMatrix.fadeIn();
                        });
                    }
                });
        });
    });

    $.each(groupSystem, function(index, value) {
        $.each(groupSystem[index].children, function(idx, currentCell) {
            $(currentCell._renderer.elem)
                .css('cursor', 'pointer')
                .on('mouseenter', function(e) {

                    currentCell.fill = G_COLOR_ELEM_HIGH;
                    currentCell.stroke = currentCell.fill;

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

                    globalMatrixObject.TwoMatrix.update();
                    two.update();

                }).on('mouseleave', function(e) {

                    currentCell.fill = currentCell.fill_original;
                    currentCell.stroke = currentCell.stroke_original;

                    $.each(group.nodes.children, function(idx, currentNode) {
                        currentNode.fill = currentNode.fill_original;
                    });

                    $.each(group.elems.children, function(idx, currentElem) {
                        currentElem.fill = currentElem.fill_original;
                    });

                    // We clear the color of  the cells of the matrix
                    //coloriseDueToMouse(groupSystem, currentElem, false);

                    globalMatrixObject.TwoMatrix.update();
                    two.update();
                });
        });
    });

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

    singleColumnArrayPassed = assignIfNecessary(singleColumnArrayPassed, false);
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

function getOptions(xnode, ielem, params) {

    params = assignIfNecessary(params, false);

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
        params = {
            valuesToColorise : params.valuesToColorise,
            minValue : params.valuesToColorise[0],
            maxValue : params.valuesToColorise[0],
            localParamsTextSVG : localParamsTextSVG
        };

        for ( k = 0 ; k < params.valuesToColorise.length ; k++ ) {
            if (params.valuesToColorise[k] > params.maxValue) {
                params.maxValue = params.valuesToColorise[k];
            }
            if (params.valuesToColorise[k] < params.minValue) {
                params.minValue = params.valuesToColorise[k];
            }
        }

        $("p#minValue").html(params.minValue);
        $("p#maxValue").html(params.maxValue);
    }

    return params;
}


$(document).ready(function() {

    var options = {
        valuesToColorise : getSingleColFromCurrentDomain('displacements', 1)
    };

    // We transform the original coordinates so they can fit better in the SVG
    G_XNODE = transformCoordinates(G_XNODE);
    G_XNODE_ORIGINAL = G_CURRENT_DOMAIN.coordinates;

    params = getOptions(G_XNODE, G_IELEM, options);

    domainObject.makeElements(G_XNODE, G_IELEM, params);

    //domainObject.changeFactorOfDeformation(G_XNODE_ORIGINAL, 30000);

    //domainObject.changeColorDueToValues(params);

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
        };

        params = getOptions(G_XNODE, G_IELEM, options);
        domainObject.changeColorDueToValues(params);
    });

    drawCurrentMatrix(domainObject.two, domainObject.group);

    // If the window changes its size, we reload the page
  //  $(window).resize(function() {
  //      document.location.reload();
  //  });

    
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
