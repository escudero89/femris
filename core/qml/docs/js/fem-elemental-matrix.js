
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

        $.each($("[data-eval]"), function (idx, val) {
            var $this = $(this);
            var keyword = $this.attr('data-eval');

            $this.html(eval(keyword.substring(2, keyword.search("}}"))));
        });
    },

    printConstitutiveMatrix : function () {

        var latexfiedConstitutiveMatrix = "\\mathbf{D} =";

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

    printBMatrix : function () {

        var latexfiedAllBMatrices = "";

        for ( var kBmat = 0 ; kBmat < this.data.bmat.length ; kBmat++ ) {
            var latexfiedBMatrix = "\\mathbf{B}_{"+ ( kBmat + 1) + "} &=";
            latexfiedAllBMatrices += latexfiedBMatrix + this.latexfyMatrix(this.data.bmat[kBmat]);

            if ( kBmat + 1 !== this.data.bmat.length ) {
                latexfiedAllBMatrices += " \\\\ \\\\ ";
            }
        }

        this.setMathJax(this.wrapInTag(latexfiedAllBMatrices, "align*"), 'bmat');

        var latexfiedBMatrixBase = "\\mathbf{B}_i=";
        var latexfiedBMatrixPattern = ["", "", ""];

        for ( var kBmatCol = 0 ; kBmatCol < this.data.bmat[0].length ; kBmatCol++ ) {
            var Ncol = "N_{" + ( kBmatCol + 1 );
            var Ncol_x = Ncol + ", \\,x}";
            var Ncol_y = Ncol + ", \\,y}";

            latexfiedBMatrixPattern[0] += Ncol_x + " & " + 0;
            latexfiedBMatrixPattern[1] += 0      + " & " + Ncol_y;
            latexfiedBMatrixPattern[2] += Ncol_y + " & " + Ncol_x;

            if ( kBmatCol + 1 !== this.data.bmat[0].length ) {
                latexfiedBMatrixPattern[0] += " & ";
                latexfiedBMatrixPattern[1] += " & ";
                latexfiedBMatrixPattern[2] += " & ";
            }
        }

        latexfiedBMatrixBase += this.wrapInTag(latexfiedBMatrixPattern.join("\\\\"), 'bmatrix');

        this.setMathJax(latexfiedBMatrixBase, 'bmatBase');

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
        this.printBMatrix();

        return true;

    }

};