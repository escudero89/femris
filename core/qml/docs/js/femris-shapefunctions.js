function equationParser(equation, val) {
    
    var PI;

    var expr = Parser.parse(equation);
    var value = { 'x' : val, 'PI' :  PI };

    if (typeof(val) === 'object') {
        value = val;
        value['PI'] = PI;
    }

    return expr.evaluate(value);
}

function miniLoader(callback) {
    $("#miniLoader > div > img").css({'opacity':0}).animate({'opacity':1}).queue(function() {
        callback();
        $(this).dequeue();
    }).delay(500).css({'opacity':1}).animate({'opacity':0});;
}

function getLagrangeInterpolationString(quantityOfNodes, idx_position) {

    var lagrangeString = "";
    var isTheFirst = true;    

    for ( var i = 1 ; i <= quantityOfNodes ; i ++ ) {
        var xi = "x" + i;
        var xj = "x" + idx_position;

        if (i !== idx_position ) {
            var lagrangeTerm = "((x - " + xi + ") / (" + xj + " - " + xi + "))";
            
            if (isTheFirst) {
                lagrangeString += lagrangeTerm;
                isTheFirst = false;
            } else {
                lagrangeString += " * " + lagrangeTerm;
            }
        }
    }

    return lagrangeString;
}

function drawShapeFunction(board, N, positionsForPolynomial, kFunction, elementColor) {

    var x_vector = [];

    for ( var k = 0; k < positionsForPolynomial.length ; k++ ) {
        x_vector.push(positionsForPolynomial[k]);
    }

    // Variables for our eval
    var x1 = x_vector[0];
    var x2 = x_vector[1];

    var x3 = (x_vector.length > 2) ? x_vector[2] : 0;
    var x4 = (x_vector.length > 3) ? x_vector[3] : 0;
    var x5 = (x_vector.length > 4) ? x_vector[4] : 0;

    var x_ini = x_vector[0];
    var x_fin = x_vector[ x_vector.length - 1 ];
    
    board.create(
        'functiongraph', 
        function(x) { 
            return equationParser(N[kFunction + 1], {
                x: x, 
                x1: x1, 
                x2: x2, 
                x3: x3, 
                x4: x4, 
                x5: x5, 
                x_ini: x_ini, 
                x_fin: x_fin
            });
        }, 
        {
            strokeColor: elementColor
    });
}

function updateInputs(quantityOfNodes) {

    var stepForNodesLocation = 1 / ( quantityOfNodes - 1 );
    
    $("#innerNodes input").attr("placeholder", function (idx, val) {

        var returnedPlaceholder = '0.0';

        if (idx < quantityOfNodes - 2) {
            returnedPlaceholder = Math.round(( idx + 1) * stepForNodesLocation * 100000) / 100000;
            $(this).removeAttr('disabled');
        } else {
            $(this).attr('disabled', 'disabled');
        }

        return returnedPlaceholder;
    });

    $("#shapeFunctions").children().addClass('hidden');
    for ( var k = 0 ; k < quantityOfNodes ; k++ ) {
        $("#shapeFunctions .form-group:eq(" + k + ")").removeClass('hidden');
    }

    var selectedOption = $("#shapeFunctionChose input:checked").val();
    var selectedShapeFunctionInput;

    $.each($("#shapeFunctions .form-group"), function(idx, val) {

        selectedShapeFunctionInput = $("#shapeFunctions input:eq(" + idx + ")");

        if (selectedOption === 'lagrange') {
            selectedShapeFunctionInput.val(getLagrangeInterpolationString(quantityOfNodes, idx + 1));
            selectedShapeFunctionInput.attr('disabled', 'disabled');

        } else if (selectedOption === 'custom') {
            selectedShapeFunctionInput.removeAttr('disabled');
        }
    });
}

/**
 * Gets all the variables needed for the rest of the operations from the inputs
 *
 * @return {Object}
 */
function getInputsFromUpdate() {

    var $innerNodes = $("#innerNodes input");
    var innerNodesValues = [];

    $.each($innerNodes, function(idx, val) {
        innerNodesValues.push($(this).val());
    });

    var input = {
        innerNodesValues : innerNodesValues,
        quantityOfNodes : $("#quantityOfNodes").val()
    };

    return input;
}

/**
 * Gets all the shape functions updated N (from 1 to 5)
 *
 * @return {Object}
 */
function getShapeFunctionFromInputUpdated() {

    // Shape functions (notice the lack of index 0)
    var N = [];

    N[1] = $("#N1").val();
    N[2] = $("#N2").val();
    N[3] = $("#N3").val();
    N[4] = $("#N4").val();
    N[5] = $("#N5").val();

    return N;
}


function updateShapeFunction(firstTime) {
    if (firstTime) {
        updateShapeFunctionHelper();
    } else {
        miniLoader(updateShapeFunctionHelper);
    }
}

function updateShapeFunctionHelper() {

    // We get the information from the inputs
    var input = getInputsFromUpdate();

    var board = JXG.JSXGraph.initBoard('singleShapeFunction', {
        boundingbox: [-0.1, 1.5, 1.1, -0.5],
        axis: true,
        grid: true,
        showCopyright: false
    });

    var positionsForPolynomial = [];
    var currentPointPosition = { 
        'x' : 0,
        'y' : 0
    };

    var nodeOptions = {
        size: '4',
        fixed: true,
        name: ''
    };

    var nodeFace = ['o','[]','x','+','^'];

    var elementColor;

    var stepForNodesLocation = 1 / ( input.quantityOfNodes - 1 );

    updateInputs(input.quantityOfNodes);
    var N = getShapeFunctionFromInputUpdated();

    // The outer loop is for each equation, and the inner loop is for each node
    for ( var kFunction = 0 ; kFunction < input.quantityOfNodes ; kFunction++ ) {

        positionsForPolynomial = [];

        elementColor = getColorFromIdx(kFunction, 0.9);
        nodeOptions['color'] = elementColor;
        nodeOptions['face'] = nodeFace[kFunction];

        for ( var kQuantity = 0 ; kQuantity < input.quantityOfNodes ; kQuantity++ ) {

            currentPointPosition.x = kQuantity * stepForNodesLocation;
            currentPointPosition.y = (kFunction === kQuantity) ? 1 : 0;

            if ( kQuantity !== 0 && kQuantity !== input.quantityOfNodes - 1 ) {

                var currentInnerNodeValue = input.innerNodesValues[kQuantity - 1];

                if (currentInnerNodeValue !== '') {
                    currentPointPosition.x = currentInnerNodeValue;
                }
            }

            positionsForPolynomial.push(currentPointPosition.x);

            // And we draw points for the polynomial
            board.create(
                'point', 
                [currentPointPosition.x, currentPointPosition.y], 
                nodeOptions
            );
        }

        /// Code for the label
        var nodeLabelXPosition = kFunction * stepForNodesLocation;
        if ( kFunction > 0 && 
             kFunction < input.quantityOfNodes - 1 && 
             input.innerNodesValues[kFunction - 1] !== '') {

            nodeLabelXPosition = input.innerNodesValues[kFunction - 1];
        }

        board.create(
            'point', 
            [ nodeLabelXPosition, 0], 
            { name: 'X<sub>' + (kFunction+1) + '</sub>', fixed: true, size: 0});

        // And finally we draw the function
        drawShapeFunction(board, N, positionsForPolynomial, kFunction, elementColor);
    }

}

function updateGraph(firstTime) {

    if (firstTime) {
        updateGraphHelper();
    } else {
        miniLoader(updateGraphHelper);
    }
}

function updateGraphHelper() {

    var Y_MIN = parseFloat( $("input#rangeFrom").val() );
    var Y_MAX = parseFloat( $("input#rangeTo").val() );

    Y_MIN = assignIfNecessary(Y_MIN, false);
    Y_MAX = assignIfNecessary(Y_MAX, false);

    var X_MIN = parseFloat( $("input#domainFrom").val() );
    var X_MAX = parseFloat( $("input#domainTo").val() );

    var QUANTITY_OF_ELEMENTS = $("#quantityOfElements").val();
    var QUANTITY_OF_NODES = $("#quantityOfNodes").val();

    var BASE_FUNCTION = {
        equation : $("#baseFunction").val(),
        min_y : false,
        max_y : false
    };

    var $innerNodesInputEq0 = $("#innerNodes input:eq(0)");
    var $innerNodesInputEq1 = $("#innerNodes input:eq(1)");
    var $innerNodesInputEq2 = $("#innerNodes input:eq(2)");

    // From x3 to x5
    var X_custom = [
        {
            value : $innerNodesInputEq0.val(),
            placeholder : $innerNodesInputEq0.attr('placeholder')
        },
        {
            value : $innerNodesInputEq1.val(),
            placeholder : $innerNodesInputEq1.attr('placeholder')
        },
        {
            value : $innerNodesInputEq2.val(),
            placeholder : $innerNodesInputEq2.attr('placeholder')
        }
    ];

    function getStepsFromArray(nodesLocation) {

        var steps = [];

        for ( var k = 0 ; k < nodesLocation.length - 1 ; k++ ) {
            steps.push(nodesLocation[k + 1] - nodesLocation[k]);
        }

        return steps;
    }

    function getNodesInLocation() {

        var nodesLocation = [0, 1];

        if (QUANTITY_OF_NODES > 2) {

            // Inserts the new node X2 in the middle
            var nodeX2 = ( X_custom[0].value !== '' ) ? X_custom[0].value : X_custom[0].placeholder;
            nodesLocation.splice(1, 0, nodeX2);

            if (QUANTITY_OF_NODES > 3) {
                var nodeX3 = ( X_custom[1].value !== '' ) ? X_custom[1].value : X_custom[1].placeholder;
                nodesLocation.splice(2, 0, nodeX3);

                if (QUANTITY_OF_NODES > 4) {
                    var nodeX4 = ( X_custom[2].value !== '' ) ? X_custom[2].value : X_custom[2].placeholder;
                    nodesLocation.splice(3, 0, nodeX4);
                }
            }
        }

        return nodesLocation;
    }

    function getPointsFromQuantityOfElements() {

        var lengthElement = (X_MAX - X_MIN) / QUANTITY_OF_ELEMENTS;

        var newStepsArray = getStepsFromArray(getNodesInLocation());
        
        var loopStepsValue = [];
        var kLoop = 1;

        for ( ; kLoop < QUANTITY_OF_NODES ; kLoop++ ) {
            loopStepsValue.push( lengthElement * newStepsArray[kLoop - 1]);
        }

        var currentPosition = X_MIN;

        var points = [];

        // For the precision error
        var epsilon = 1e-10;

        kLoop = 0;
        while (currentPosition <= X_MAX + epsilon) {
            points.push(currentPosition);
            currentPosition += loopStepsValue[kLoop];

            kLoop++;
            kLoop = (kLoop >= QUANTITY_OF_NODES - 1) ? 0 : kLoop;
        }

        return points;
    }

    function getValuesForInterpolation(pointsForElement) {
        
        var phi_m = [];

        $.each(pointsForElement, function(idx, val) {
            phi_m.push(baseFunction(val));
        });

        return phi_m;

    };

    var baseFunctionForBoard = function(x) {
        var equationSolved = baseFunction(x);

        if (!BASE_FUNCTION.min_y || BASE_FUNCTION.min_y > equationSolved) {
            BASE_FUNCTION.min_y = equationSolved;
        }

        if (!BASE_FUNCTION.max_y || BASE_FUNCTION.max_y < equationSolved) {
            BASE_FUNCTION.max_y = equationSolved;
        }

        return equationSolved;
    };

    var baseFunction = function(x) {
        return equationParser(BASE_FUNCTION.equation, x);
    };

    var board = JXG.JSXGraph.initBoard(
        'box', 
        {
            boundingbox: [X_MIN, 1.5, X_MAX, -0.9], 
            axis: true, 
            grid: true
        }
    );
    
    var boardShapeFunctions = JXG.JSXGraph.initBoard(
        'boxShapeFunctions', 
        {
            boundingbox: [X_MIN, 1.5, X_MAX, -0.9], 
            axis: true,
            grid: true,
            showCopyright: false,
            showNavigation: false
        }
    );

    var basegraph = board.create('functiongraph', [baseFunctionForBoard], {strokeColor:'#AAAAAA', strokeWidth:2});

    Y_MAX = BASE_FUNCTION.max_y;
    Y_MIN = BASE_FUNCTION.min_y;
    Y_DELTA = Math.abs(Y_MAX - Y_MIN) * .2;
    board.setBoundingBox([X_MIN, Y_MAX + Y_DELTA, X_MAX, Y_MIN - Y_DELTA]);

    var pointsForElement = getPointsFromQuantityOfElements();
    var valuesForPoints = getValuesForInterpolation(pointsForElement);

    boardShapeFunctions.suspendUpdate();

    var kElem = 0;

    var N = [];
    
    N[1] = $("#N1").val();
    N[2] = $("#N2").val();
    N[3] = $("#N3").val();
    N[4] = $("#N4").val();
    N[5] = $("#N5").val();

    var phi = "";

    for ( var k = 0; k < QUANTITY_OF_NODES ; k++ ) {
        phi += "+ (" + N[k + 1] + ") * phi_" +  k + " ";
    }

    var errorRMS = 0;
    var nErrorRms = 0;
    
    while (kElem < QUANTITY_OF_ELEMENTS) {

        var counterOfSidesDone = QUANTITY_OF_NODES;

        var phi_vector = [];
        var x_vector = [];

        for ( var k = 0; k < QUANTITY_OF_NODES ; k++ ) {
            phi_vector.push(valuesForPoints[k + ( QUANTITY_OF_NODES - 1) * kElem]);
            x_vector.push(pointsForElement[k + ( QUANTITY_OF_NODES - 1 ) * kElem]);
        }

        // Variables for our eval
        var x1 = x_vector[0];
        var x2 = x_vector[1];

        var x3 = (x_vector.length > 2) ? x_vector[2] : 0;
        var x4 = (x_vector.length > 3) ? x_vector[3] : 0;
        var x5 = (x_vector.length > 4) ? x_vector[4] : 0;

        var x_ini = x_vector[0];
        var x_fin = x_vector[ x_vector.length - 1 ];

        for ( ; counterOfSidesDone > 0 ; counterOfSidesDone-- ) {

            boardShapeFunctions.create('functiongraph', [
                function(x) { 

                    var value = 0;

                    if (x >= x_ini && x <= x_fin) {
                        value = equationParser(N[counterOfSidesDone], {
                            x: x, 
                            x1: x1, 
                            x2: x2, 
                            x3: x3, 
                            x4: x4, 
                            x5: x5, 
                            x_ini: x_ini, 
                            x_fin: x_fin
                        });
                    }

                    return value;
                }, x_ini, x_fin], 
                {strokeColor: getColorFromIdx(kElem)}

            );
        }

        board.create('functiongraph', [
            function(x) {
                var value = 0;

                value = equationParser(phi, {
                    x: x, 
                    x1: x1, 
                    x2: x2, 
                    x3: x3, 
                    x4: x4, 
                    x5: x5, 
                    x_ini: x_ini, 
                    x_fin: x_fin,
                    phi_0: phi_vector[0],
                    phi_1: phi_vector[1],
                    phi_2: phi_vector[2],
                    phi_3: phi_vector[3],
                    phi_4: phi_vector[4],
                });

                // for calculating the root-mean-square error
                errorRMS += Math.pow(baseFunction(x) - value, 2);
                nErrorRms ++;

                return value;
            }, x_ini, x_fin],
            {strokeColor: getColorFromIdx(kElem), dash: 1, strokeWidth: 2});

        kElem++;
    }

    errorRMS = Math.sqrt(errorRMS/nErrorRms);

    $("#errorValue").html("Root Mean Square: " + Math.round(errorRMS * 10000) / 100 + "%");

    var kPoint = 0;

    for ( ; kPoint < pointsForElement.length ; kPoint++ ) {
        var cPoint = pointsForElement[kPoint];

        board.create(
            'point', 
            [cPoint, baseFunction(cPoint)], 
            { color: getColorFromIdx(Math.floor(kPoint / ( QUANTITY_OF_NODES - 1 ))), name: '', fixed: true}
        );
    }

}