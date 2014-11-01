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
            return eval(N[kFunction + 1]);
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


function updateShapeFunction(input) {

    // We get the information from the inputs
    input = getInputsFromUpdate();

    var board = JXG.JSXGraph.initBoard('singleShapeFunction', {
        boundingbox: [-0.1, 1.5, 1.1, -0.5],
        axis: true,
        grid: false,
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
    N = getShapeFunctionFromInputUpdated();

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