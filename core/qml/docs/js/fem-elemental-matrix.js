
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

/**
 * Surrounds a string of text by the tags, LaTeX style.
 * Returned example: \begin{_tag} _text \end{_tag}
 *
 * @param  {String} text Text to be covered inside tags
 * @param  {String} tag  Tag to be used in _tag
 * @return {String}      Wrapped text
 */
    wrapInTag : function (text, tag) {
        return "\\begin{" + tag + "}" + text + "\\end{" + tag + "}";
    },

/**
 * Parse a number into scientific notation (LaTeX style).
 * For example, the number 52700 would be returned as "5.2700 \times 10^{4}".
 * If the number is 0, returns "-".
 *
 * @param  {Number} number Number to be parsed
 * @return {String}        Number in scientific notation
 */
    latexfyNumber : function(number) {
        var scientific_expression = Utils.parseNumber(number).split('e');

        var latex_expression = (number === 0) ? '-' :
                scientific_expression[0] + ' \\times 10^{' + parseInt(scientific_expression[1]) + '}';

        return latex_expression;
    },

/**
 * Renders a DOM element using MathJax.
 *
 * @param  {String} elementId ID of the DOM element
 */
    loadMathJax : function(elementId) {
        MathJax.Hub.Queue(["Typeset", MathJax.Hub, document.getElementById(elementId)]);
    },

/**
 * Add the MathJax required tags for future rendering of the string passed,
 * and stores the tagged string into a DOM element.
 * For example, `5.700 \times 10^3` returns as `$${5.700 \times 10^3}$$`.
 *
 * @param {String} latexCode Latex syntax to be tagged with MathJax syntax
 * @param {String} elementId ID of the DOM element which will store the result
 */
    setMathJax : function(latexCode, elementId) {
        elementId = assignIfNecessary(elementId, 'MathOutput')

        $('#' + elementId).html('$${' + latexCode + '}$$');
        this.loadMathJax(elementId);
    },

/**
 * Receives an array of arrays, and parses them into a latexified matrix format.
 * It also transforms the numbers of the array into scientific notation.
 *
 * Example: `[[1],[2]]` becomes...
 *
 *     "\begin{bmatrix}1.0000 \times 10^{0}\\2.0000 \times 10^{0}\\\end{bmatrix}"
 *
 * @param  {Object} setOfValues Double array of values ([[a1,a2,...],[b1,...]]).
 * @return {String}             The array transformed into a matrix format
 */
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

/**
 * Put an array of arrays into the following format:
 *
 *     \\mathbf{label}extra_label = matrix_latexfied
 *
 * where matrix_latexfied is the result of parsing the variable `matrix`
 * usign `latexfyMatrix`.
 *
 * @param  {Object} matrix      Double array of values ([[a1,a2,...],[b1,...]])
 * @param  {String} label       The mathematical name of the matrix
 * @param  {String} extra_label A label
 * @return {String}             The parsed matrix
 */
    latexfyMatrixWithLabel : function(matrix, label, extra_label) {
        extra_label = assignIfNecessary(extra_label, ' ');

        return '\\mathbf{' + label + '}' + extra_label + '=' + this.latexfyMatrix(matrix);
    },

/**
 * Look for all the DOM elements with the `data-eval` attribute, and evals them.
 * The result is then put into the DOM element value. Example:
 *
 *     < span data-eval="{{Math.round(30.4)}}" ></ span > becomes...
 *     < span data-eval="{{Math.round(3.5)}}" >30</ span >
 *
 * Requires that the `data-eval` attribute had its value surrounded by double
 * parenthesis.
 */
    setAllKeywordsInParagraphsOnTabs : function() {

        var self = this;

        $.each($("[data-eval]"), function (idx, val) {
            var $this = $(this);
            var keyword = $this.attr('data-eval');

            $this.html(eval(keyword.substring(2, keyword.search("}}"))));
        });
    },

/**
 * Prints the constitutive matrix into the `ce_results` (tab "Additional Information").
 */
    printConstitutiveMatrix : function () {

        var latexfiedConstitutiveMatrix = "\\mathbf{D} =";

        this.setMathJax(latexfiedConstitutiveMatrix + this.latexfyMatrix(this.data.dmat), 'constitutiveMatrix');

        var latexfiedConstitutiveMatrixBase = "\\mathbf{D}=";

        if (this.current.problem_type == 'plane-stress') {
            latexfiedConstitutiveMatrixBase += "\\frac{E}{1-\\nu^2}" +
                this.wrapInTag("1&\\nu&0\\\\ \\nu&1&0 \\\\ 0&0&(1-\\nu)/2", 'bmatrix');
        } else if (this.current.problem_type == 'plane-strain') {
            latexfiedConstitutiveMatrixBase += "\\frac{E}{(1+\\nu)(1-2\\nu)}" +
                this.wrapInTag("1-\\nu&\\nu&0\\\\ \\nu&1-\\nu&0 \\\\ 0&0&(1-2\\nu)/2", 'bmatrix');
        } else {
            latexfiedConstitutiveMatrixBase += this.wrapInTag("k_x&0\\\\ 0&k_y", 'bmatrix');
        }

        this.setMathJax(latexfiedConstitutiveMatrixBase, 'constitutiveMatrixBase');

        // For heat we do not show the Poisson's coefficient nor the Young's Modulus
        if (this.current.problem_type === 'heat') {
            this.setMathJax("Q = " + this.latexfyNumber(this.data.heat), 'constitutiveMatrixBaseVariables');
            return;
        }

        var latexfiedVariables =
            this.wrapInTag(
                "E=" + this.latexfyNumber(this.data.young) + "&&" + "\\nu=" + this.latexfyNumber(this.data.poiss),
                'align*');

        this.setMathJax(latexfiedVariables, 'constitutiveMatrixBaseVariables');
    },

/**
 * Prints the `B` matrix into the `ce_results` (tab "Additional Information").
 */
    printBMatrix : function () {

        var latexfiedAllBMatrices = "";

        var printMoreBmatrices = false;

        var quantityOfBmats = 1;
        var appendLatexfiedBmatrix = "} &=";

        if ( this.element_nodes_idx.length === 4 ) {
            quantityOfBmats = 4;
            printMoreBmatrices = true;
        }

        for ( var kBmat = 0 ; kBmat < quantityOfBmats ; kBmat++ ) {

            appendLatexfiedBmatrix = (printMoreBmatrices) ? "}^{" + this.element_nodes_idx[kBmat] + "} &=" : appendLatexfiedBmatrix;

            var latexfiedBMatrix = "\\mathbf{B}_{"+ ( this.element_idx + 1) + appendLatexfiedBmatrix;
            latexfiedAllBMatrices += latexfiedBMatrix + this.latexfyMatrix(this.data.bmat[kBmat]);

            if ( kBmat + 1 !== this.data.bmat.length ) {
                latexfiedAllBMatrices += " \\\\ \\\\ ";
            }
        }

        this.setMathJax(this.wrapInTag(latexfiedAllBMatrices, "align*"), 'bmat');

        var latexfiedBMatrixBase = "\\mathbf{B}_i=";
        var latexfiedBMatrixPattern = ["", "", ""];

        var kBmatColMax = this.data.bmat[0][0].length / 2;

        for ( var kBmatCol = 0 ; kBmatCol <  kBmatColMax; kBmatCol++ ) {
            var Ncol = "N_{" + ( kBmatCol + 1 );
            var Ncol_x = Ncol + ", \\,x}";
            var Ncol_y = Ncol + ", \\,y}";

            latexfiedBMatrixPattern[0] += Ncol_x + " & " + 0;
            latexfiedBMatrixPattern[1] += 0      + " & " + Ncol_y;
            latexfiedBMatrixPattern[2] += Ncol_y + " & " + Ncol_x;

            if ( kBmatCol + 1 !== kBmatColMax ) {
                latexfiedBMatrixPattern[0] += " & ";
                latexfiedBMatrixPattern[1] += " & ";
                latexfiedBMatrixPattern[2] += " & ";
            }
        }

        latexfiedBMatrixBase += this.wrapInTag(latexfiedBMatrixPattern.join("\\\\"), 'bmatrix');

        this.setMathJax(latexfiedBMatrixBase, 'bmatBase');

    },

/**
 * Sets the current workspace of `ce_results`, i.e. initializes the tabs when
 * a element of the domain is clicked.
 *
 * @param {Number} selectedElementIdx Which element of the domain was selected
 */
    setWorkspace : function (selectedElementIdx) {

        this.element_idx = selectedElementIdx;
        this.element_nodes_idx = G_IELEM[selectedElementIdx];

        this.current.K_e = this.data.M[selectedElementIdx];
        this.current.f_e = this.data.f[selectedElementIdx];

        var K_e_latexfied = this.latexfyMatrixWithLabel(this.current.K_e, 'K', '^{' + ( this.element_idx + 1 ) + '}');

        this.setMathJax(K_e_latexfied);

        this.setAllKeywordsInParagraphsOnTabs();

        this.printConstitutiveMatrix();
        this.printBMatrix();


        if (this.element_nodes_idx.length === 3) {
            $(".triangular-hidden").removeClass("hidden");
        } else {
            $(".quadrangular-hidden").removeClass("hidden");
             $("a[aria-controls='stiffness']").html($("a[aria-controls='stiffness']").html().replace(/Tr/g, "Qd"));
             $("a[aria-controls='stresses']").html($("a[aria-controls='stresses']").html().replace(/Tr/g, "Qd"));
        }

        $("#buttonToggleViews").removeAttr('disabled');

    },

/**
 * Starts the variables of `globalElementalMatrixObject`, usign the information
 * stored in the `temp` folder.
 *
 * @param  {Object} elemental_data  All the information associated with the element
 * @return {Boolean}                True if it was already initialized. False if not.
 */
    initialize : function (elemental_data) {

        if (this.wasInitialized) {
            return false;
        }

        this.data = $.extend(true, {}, elemental_data);
        this.wasInitialized = true;

        if (!eval(this.data.pstrs)) {
            this.current.problem_type = 'heat';
            this.current.problem_type_text = 'Transporte de calor';
        } else {
            this.current.problem_type = parseInt(this.data.pstrs) ? 'plane-stress' : 'plain-strain';
            this.current.problem_type_text = parseInt(this.data.pstrs) ? 'Tensión Plana' : 'Deformación Plana';
        }

        return true;

    }

};
