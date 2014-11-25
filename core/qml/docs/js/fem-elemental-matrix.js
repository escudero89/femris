
var globalElementalMatrixObject = {

    original_html_content : {},

    elemental_data : false,
    element_idx : false,

    element_nodes_idx : false,

    current : {
        K_e : false,
        f_e : false
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

    setAllKeywordsInParagraphsOnTabs : function() {

        var self = this;

        $.each($("[role='tabpanel'] p"), function (idx, value) {
            var content = $(value).html();
            var regex = /{{[\w\.\+\[\]]+}}/;

            var encoded_idx = btoa(content.substr(0, 14));

            if (typeof(self.original_html_content[encoded_idx]) === 'undefined') {
                self.original_html_content[encoded_idx] = content;
            } else {
                content = self.original_html_content[encoded_idx];
            }

            while (content.search(regex) !== -1) {
                var keyword = content.match(regex)[0];
                keyword = keyword.substring(2, keyword.search("}}"));

                content = content.replace(regex, eval(keyword));
                $(value).html(content);
            }
        });
    },

    setWorkspace : function (elemental_data, selectedElementIdx) {

        this.elemental_data = elemental_data;
        this.element_idx = selectedElementIdx;
        this.element_nodes_idx = G_IELEM[selectedElementIdx];

        this.current.K_e = this.elemental_data.M[selectedElementIdx];
        this.current.f_e = this.elemental_data.f[selectedElementIdx];

        var K_e_latexfied = this.latexfyMatrixWithLabel(this.current.K_e, 'K', '^{' + ( this.element_idx + 1 ) + '}');
        var f_e_latexfied = this.latexfyMatrixWithLabel(this.current.f_e, 'f', '^{' + ( this.element_idx + 1 ) + '}');

        this.setMathJax(K_e_latexfied + "\\; \\; \\;" + f_e_latexfied);

        this.setAllKeywordsInParagraphsOnTabs();

        $("#buttonToggleViews").removeAttr('disabled');
    }

};