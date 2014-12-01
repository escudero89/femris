
var globalElementalMatrixObject = {

    original_html_content : {},
    
    wasInitialized : false,

    data : false,
    element_idx : false,

    element_nodes_idx : false,

    current : {
        K_e : false,
        f_e : false,

        problem_type : false,
        problem_type_text : false,
    },

    wrapInTag : function (text, tag) {
        return "\\begin{" + tag + "}" + text + "\\end{" + tag + "}";

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

    setMathJax : function(latexCode, elementId) {
        elementId = assignIfNecessary(elementId, 'MathOutput')
        
        $('#' + elementId).html('$${' + latexCode + '}$$');
        this.loadMathJax(elementId);
    },

    latexfyMatrix : function(setOfValues) {

        var self = this;

        var numberOfColumns = setOfValues[0].length;
        var notAMatrix = false;

        var matrixInLatex = "";

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

        matrixInLatex = this.wrapInTag(matrixInLatex, 'bmatrix');

        if (notAMatrix) {
            return false;
        } else {
            return matrixInLatex;
        }

    },

    latexfyMatrixWithLabel : function(matrix, label, extra_label) {
        extra_label = assignIfNecessary(extra_label, ' ');

        return '\\mathbf{' + label + '}' + extra_label + '=' + this.latexfyMatrix(matrix);
    },

    setAllKeywordsInParagraphsOnTabs : function() {

        var self = this;

        $.each($("[role='tabpanel'] p"), function (idx, value) {
            var content = $(value).html();
            var regex = /{{[\w\.\+\[\]\(\)]+}}/;

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

    printConstitutiveMatrix : function () {

        var latexfiedConstitutiveMatrix = 
            "\\mathbf{D} = " /*+ this.wrapInTag("d_{11}&d_{12}&0\\\\d_{21}&d_{22}&0\\\\0&0&d_{33}", 'bmatrix') + "="*/;

        this.setMathJax(latexfiedConstitutiveMatrix + this.latexfyMatrix(this.data.dmat), 'constitutiveMatrix');

        var latexfiedConstitutiveMatrixBase = "\\mathbf{D}=";

        if (this.current.problem_type == 'plane-stress') {
            latexfiedConstitutiveMatrixBase += "\\frac{E}{1-\\nu^2}" +
                this.wrapInTag("1&\\nu&0\\\\ \\nu&1&0 \\\\ 0&0&(1-\\nu)/2", 'bmatrix');
        } else {
            latexfiedConstitutiveMatrixBase += "\\frac{E}{(1+\\nu)(1-2\\nu)}" +
                this.wrapInTag("1-\\nu&\\nu&0\\\\ \\nu&1-\\nu&0 \\\\ 0&0&(1-2\\nu)/2", 'bmatrix');
        }

        this.setMathJax(latexfiedConstitutiveMatrixBase, 'constitutiveMatrixBase');

        var latexfiedVariables =
            this.wrapInTag(
                "E=" + this.latexfyNumber(this.data.young) + "&&" + "\\nu=" + this.latexfyNumber(this.data.poiss),
                'align*');

        this.setMathJax(latexfiedVariables, 'constitutiveMatrixBaseVariables');
    },

    setWorkspace : function (selectedElementIdx) {

        this.element_idx = selectedElementIdx;
        this.element_nodes_idx = G_IELEM[selectedElementIdx];

        this.current.K_e = this.data.M[selectedElementIdx];
        this.current.f_e = this.data.f[selectedElementIdx];

        var K_e_latexfied = this.latexfyMatrixWithLabel(this.current.K_e, 'K', '^{' + ( this.element_idx + 1 ) + '}');
        var f_e_latexfied = this.latexfyMatrixWithLabel(this.current.f_e, 'f', '^{' + ( this.element_idx + 1 ) + '}');

        this.setMathJax(K_e_latexfied + "\\; \\; \\;" + f_e_latexfied);

        this.setAllKeywordsInParagraphsOnTabs();

        $("#buttonToggleViews").removeAttr('disabled');
        
    },

    initialize : function (elemental_data) {

        if (this.wasInitialized) {
            return false;
        }

        this.data = $.extend(true, {}, elemental_data);
        this.wasInitialized = true;

        this.current.problem_type = parseInt(this.data._pstrs) ? 'plane-stress' : 'plain-strain';
        this.current.problem_type_text = parseInt(this.data._pstrs) ? 'Tensión Plana' : 'Deformación Plana';

        this.printConstitutiveMatrix();

        return true;

    }

};