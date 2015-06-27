// We define some variables for the colors
var G_COLOR_NODE_HIGH = "#d9534f";
var G_COLOR_ELEM_HIGH = "#d9534f";

var G_CURRENT_PANEL_STATE = "default";

function enableChangeColorScheme() {
    $("ul[name='color-schemes'] a").click(function(e) {
        e.preventDefault();
        var colorScheme = $(this).parent().attr("name");

        G_CURRENT_COLOR_SCHEME = colorScheme;
        domainObject.changeColorDueToValues();

        $("ul[name='color-schemes'] li").removeClass('active');
        $(this).parent().addClass('active');
    });
}

function togglePanels(runAgain) {

    var leftPanel = $("div#leftColumnResults");
    var rightPanel = $("div#rightColumnResults");

    var colDefault = "col-xs-6";

    var colBig = "col-xs-9";
    var colSmall = "col-xs-3";

    var colHuge = "col-xs-12";
    var colNone = "hide";

    // First we set the next value
    switch (G_CURRENT_PANEL_STATE) {
        case "big-left": G_CURRENT_PANEL_STATE = "huge-left"; break;
        case "huge-left": G_CURRENT_PANEL_STATE = "big-right"; break;
        case "big-right": G_CURRENT_PANEL_STATE = "huge-right"; break;
        case "huge-right": G_CURRENT_PANEL_STATE = "default"; break;
        default: G_CURRENT_PANEL_STATE = "big-left";
    }

    // Then we set the changes
    switch (G_CURRENT_PANEL_STATE) {

        case "big-left":
            leftPanel.removeClass(colDefault);
            leftPanel.addClass(colBig);

            rightPanel.removeClass(colDefault);
            rightPanel.addClass(colSmall);
            break;

        case "huge-left":
            leftPanel.removeClass(colBig);
            leftPanel.addClass(colHuge);

            rightPanel.removeClass(colSmall);
            rightPanel.addClass(colNone);
            break;

        case "big-right":
            leftPanel.removeClass(colHuge);
            leftPanel.addClass(colSmall);

            rightPanel.removeClass(colNone);
            rightPanel.addClass(colBig);
            break;

        case "huge-right":
            leftPanel.removeClass(colSmall);
            leftPanel.addClass(colNone);

            rightPanel.removeClass(colBig);
            rightPanel.addClass(colHuge);
            break;

        default:
            leftPanel.removeClass(colNone);
            leftPanel.addClass(colDefault);

            rightPanel.removeClass(colHuge);
            rightPanel.addClass(colDefault);

    }

}

function toggleViews(setElementalView) {

    setElementalView = assignIfNecessary(setElementalView, false);

    var $matrixSVG = $('#matrixSVG');
    var $box = $('#box');

    if ($box.hasClass('hidden') || setElementalView) {
        $matrixSVG.addClass('hidden');
        $box.removeClass('hidden');

    } else {
        $matrixSVG.removeClass('hidden');
        $box.addClass('hidden');
    }

}

function toggleScale() {
    domainObject.toggleScale();
}

function viewGlobalStiffnessMatrix() {
    var modalBody = $('#modalStiffnessMatrix').find('.output');

    var globalK = globalElementalMatrixObject.latexfyMatrixWithLabel(G_CURRENT_ELEMENTAL_DATA.stiffness_matrix, 'K\\cdot \\phi');
    var globalPhi = globalElementalMatrixObject.latexfyMatrix(G_CURRENT_ELEMENTAL_DATA.u);
    var globalF = globalElementalMatrixObject.latexfyMatrixWithLabel(G_CURRENT_ELEMENTAL_DATA.f, 'f');

    modalBody.html('$${\\begin{align*}' +  globalK + globalPhi + "&&" + globalF + '\\end{align*}}$$');

    $('#modalStiffnessMatrix').modal();
    setTimeout(globalElementalMatrixObject.loadMathJax('#modalStiffnessMatrix'), 5);
}

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

                    Utils.setCurrentValue(currentElem.currentValue);

                }).on('mouseleave', function(e) {

                    currentElem.fill = currentElem.fill_original;

                    // We clear the color of  the cells of the matrix
                    coloriseDueToMouse(groupSystem, currentElem, false);

                    globalMatrixObject.TwoMatrix.update();
                    two.update();

                }).on('click', function (e){

                    if (currentElem.type === 'elem') {
                        toggleViews(true);
                        globalElementalMatrixObject.setWorkspace(currentElem.k_ielem - 1);
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
        for ( k = 0 ; k < G_CURRENT_DOMAIN[variable].length ; k++ ) {
            singleColArray.push(G_CURRENT_DOMAIN[variable][k][col_idx]);
        }
    }

    return singleColArray;

}

function getOptions(xnode, ielem, params) {

    params = assignIfNecessary(params, false);

    var localParamsTextSVG = {          // These are the text's params shared locally
        'alignment'      : 'center',
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
            maxValue : params.valuesToColorise[0]
        };

        for ( var k = 0 ; k < params.valuesToColorise.length ; k++ ) {
            if (params.valuesToColorise[k] > params.maxValue) {
                params.maxValue = params.valuesToColorise[k];
            }
            if (params.valuesToColorise[k] < params.minValue) {
                params.minValue = params.valuesToColorise[k];
            }
        }

        $("#minValue").html(Utils.parseNumber(params.minValue));
        $("#maxValue").html(Utils.parseNumber(params.maxValue));
    }

    params.localParamsTextSVG = localParamsTextSVG;

    return params;
}

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

$(document).ready(function() {
    var $body = $(".row");
    $body.html($body.html().replace(/{{femris}}/g, "<span class='femris'><tt>FEMRIS</tt></span>"));

    var params = {
        valuesToColorise : getSingleColFromCurrentDomain('displacements', eval($("ul[name='displacements'] > li.active").attr("name")))
    };

    params.valuesToColorise = (params.valuesToColorise.length > 0) ? params.valuesToColorise : false;

    // We transform the original coordinates so they can fit better in the SVG
    G_XNODE = transformCoordinates(G_XNODE);
    G_XNODE_ORIGINAL = G_CURRENT_DOMAIN.coordinates;

    options = getOptions(G_XNODE, G_IELEM, params);

    domainObject.makeElements(G_XNODE, G_IELEM, options);

    $("nav.navbar-fixed-top .visualization li").on('click', function(e) {
        var $this = $(this);

        $(".visualization li").removeClass("active");
        $this.addClass("active");

        var whichVariable = $this.parent().attr('name');
        var indexColumn = $this.attr('name');

        if (indexColumn.search(',') > 0) {
            indexColumn = eval(indexColumn);
        }

        params = {
            valuesToColorise : getSingleColFromCurrentDomain(whichVariable, indexColumn)
        };

        params.valuesToColorise = (params.valuesToColorise.length > 0) ? params.valuesToColorise : false;

        options = getOptions(G_XNODE, G_IELEM, params);
        domainObject.changeColorDueToValues(options);
    });

    drawCurrentMatrix(domainObject.two, domainObject.group);

    // If the window changes its size, we reload the page
    $(window).resize(function() {
        //document.location.reload();
    });

    /////////////////////////////////////////////////////////////////////////////////////////////

    globalElementalMatrixObject.initialize(G_CURRENT_ELEMENTAL_DATA);
});

