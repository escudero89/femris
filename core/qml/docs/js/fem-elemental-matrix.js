
var globalElementalMatrixObject = {

    setMathJax : function(latexCode) {

        $('#MathOutput').html('$${' + latexCode + '}$$');
        MathJax.Hub.Queue(["Typeset", MathJax.Hub, document.getElementById("MathOutput")]);
        
    },

    latexfyMatrix : function(setOfValues) {

        var numberOfColumns = setOfValues[0].length;
        var notAMatrix = false;

        var matrixInLatex = "\\begin{bmatrix}";

        $.each(setOfValues, function (rowIdx, rowValue) {

            if (rowValue.length !== numberOfColumns) {
                notAMatrix = true;
                return false;
            }

            $.each(rowValue, function (colIdx, colValue) {

                matrixInLatex += colValue;
                matrixInLatex += (colIdx !== rowValue.length - 1) ? "&" : "\\\\";

            });
        });

        matrixInLatex += "\\end{bmatrix}";

        if (notAMatrix) {
            return false;
        } else {
            return matrixInLatex;
        }

    },


};