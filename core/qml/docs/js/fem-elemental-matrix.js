
var globalElementalMatrixObject = {

    elemental_data : false,
    element_idx : false,

    current : {
        K_e : false
    },

    latexfyNumber : function(number) {
        var scientific_expression = Utils.parseNumber(number).split('e');

        var latex_expression = (number !== 0) ?
                scientific_expression[0] + ' \\times 10^{' + parseInt(scientific_expression[1]) + '}' :
                '-';

        return latex_expression;
    },

    loadMathJax : function(elementId) {
        MathJax.Hub.Queue(["Typeset", MathJax.Hub, document.getElementById(elementId)]);
    },

    setMathJax : function(latexCode) {
        $('#MathOutput').html('$${' + latexCode + '}$$');
        this.loadMathJax("MathOutput");
    },

    latexfyMatrix : function(setOfValues) {

        var self = this;

        var numberOfColumns = setOfValues[0].length;
        var notAMatrix = false;

        var matrixInLatex = "\\begin{bmatrix}";

        $.each(setOfValues, function (rowIdx, rowValue) {

            if (rowValue.length !== numberOfColumns) {
                notAMatrix = true;
                return false;
            }

            $.each(rowValue, function (colIdx, colValue) {

                matrixInLatex += self.latexfyNumber(colValue);
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

    latexfyMatrixWithLabel : function(matrix, label, extra_label) {
        extra_label = assignIfNecessary(extra_label, '');
        label = '\\mathbf{' + label + '}' + extra_label + '=';

        return label + this.latexfyMatrix(matrix);
    },

    setWorkspace : function (elemental_data, selectedElementIdx) {

        this.elemental_data = elemental_data;
        this.element_idx = selectedElementIdx;

        this.current.K_e = this.elemental_data.f[selectedElementIdx];

        this.setMathJax(this.latexfyMatrixWithLabel(this.current.K_e, 'K', '^{' + this.element_idx + '}'));
    }

};