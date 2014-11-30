// We define some variables for the colors

function getOptions(xnode, ielem, params) {

    params = assignIfNecessary(params, []);

    var localParamsTextSVG = {          // These are the text's params shared locally
        'fill'           : 'black',
        'font-family'    : 'Georgia',
        'pointer-events' : 'none',
        'style'          : 'cursor:pointer',
        'text-anchor'    : 'middle',
        'font-size'      : 0.10 * Math.abs( xnode[ ielem[0][2] - 1 ][1] - xnode[ ielem[0][0] - 1 ][1] )
    };

    if (localParamsTextSVG['font-size'] === 0) {
        localParamsTextSVG['font-size'] = 0.15 * Math.abs( xnode[ ielem[0][1] - 1 ][1] - xnode[ ielem[0][0] - 1 ][1] );
    }

    params["localParamsTextSVG"] = localParamsTextSVG;

    return params;
}


$(document).ready(function() {

    // We transform the original coordinates so they can fit better in the SVG
    G_XNODE = transformCoordinates(G_XNODE);
    G_XNODE_ORIGINAL = G_CURRENT_DOMAIN.coordinates;

    options = getOptions(G_XNODE, G_IELEM);

    domainObject.makeElements(G_XNODE, G_IELEM, options);

    // If the window changes its size, we reload the page
    $(window).resize(function() {
        document.location.reload();
    });

    
});