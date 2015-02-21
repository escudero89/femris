/**
 * Checks if an element exists.
 *
 * @param {Object} thing - The element that we are checking if it's undefined or not
 * @return {bool} - True if it is different from undefined, false otherwise
 */
 function exists(thing) {
    return (typeof thing !== 'undefined' && thing);
}

/**
 * Checks if an element exists. If not, the thing takes the value pass by thing
 * by default. If there isn't a thing by default, it takes just false.
 *
 * @param {Object} thing - The element that we are checking if it's undefined or not
 * @param {Object} thing - What are we going to put as default for the element
 * @return {Object} - The thing checked, or false if it doesn't exist nor has a default value
 */
 function assignIfNecessary(thing, thingByDefault) {

    thingByDefault = (exists(thingByDefault)) ? thingByDefault : false;

    return (exists(thing)) ? thing : thingByDefault;
}

/**
 * Get a color from a particular idx. It uses the HUE an separations of 10º,
 * and returns a color with 100% saturation and 50% lightness (i.e, RGB(255,0,0))
 *
 * @param {number} idx - Index of reference for the color
 * @param {number} alpha - For transparency
 * @return {string} - The color in format HSL ("hsl(120, 100%, 50%, alpha)")
 */
 function getColorFromIdx(idx, alpha) {

    // We get the color in jumps of 13º
    var huePos = ( idx * 43 ) % 360;
    var typeSchema = exists(alpha) ? 'hsla' : 'hsl';
    var alphaValue = exists(alpha) ? (', ' + alpha) : '';

    return typeSchema + '(' + huePos + ', 100%, 50%' + alphaValue + ')';
}


/**
 * Get a color from a particular value, having a max and a min for comparison.
 * Returns a color with 100% saturation and 50% lightness (i.e, RGB(255,0,0))
 *
 * @param {number} current - current value
 * @param {number} min - min value (blue)
 * @param {number} max - max value (red)
 * @param {number} alpha - For transparency
 * @return {string} - The color in format HSL ("hsl(120, 100%, 50%, alpha)")
 */
 function getColorFromInterpolation(current, min, max, alpha) {

    var hsl = [ 0, 0 ];

    var hue = [];
    var sat = [];
    var lgt = [];

    switch (G_CURRENT_COLOR_SCHEME) {

        case "monochromatic":
            hue = [0, 0];
            sat = [0, 0];
            lgt = [0, 100];
            break;

        case "monochromatic-cyan":
            hue = [175, 175];
            sat = [29, 6];
            lgt = [24, 87];
            break;

        case "cyan-orange":
            hue = [175, 101, 28];
            sat = [45, 0, 47];
            lgt = [50, 95, 65];
            break;

        case "monochromatic-blue":
            hue = [217, 218];
            sat = [33, 13];
            lgt = [31, 99];
            break;

        case "blue-red":
            hue = [210, 280, 351];
            sat = [69, 0, 53];
            lgt = [70, 95, 80];
            break;

        case "rainbow": default:
            hue = [0, 240];
            sat = [100, 100];
            lgt = [65, 65];
    }

    hsl = getGradientFromInterpolation(current, min, max, hue, sat, lgt)

    // Add the opacity (if exists)
    var typeSchema = exists(alpha) ? 'hsla' : 'hsl';
    var alphaValue = exists(alpha) ? (', ' + alpha) : '';

    // We get the notation for the values of HSL
    var hueValue = hsl[0];
    var satValue = hsl[1] + '%';
    var lgtValue = hsl[2] + '%';

    return typeSchema + '(' + [hueValue, satValue, lgtValue].join(',') + alphaValue + ')';
}

/**
 * Gets a color from a particular value, having a max and a min for comparison.
 * Returns a color with an interpolated value of Hue, Saturation and Lightness.
 * It can interpolate between two or three points (given by the args of HSL).
 *
 * @param {number} current - current value
 * @param {number} min - min value (blue)
 * @param {number} max - max value (red)
 * @param {Object} hueVariation - sets the hue [ hue_start, (hue_mid_optional), hue_end ]
 * @param {Object} saturationVariation - sets the saturation [ sat_start, (sat_mid_optional), sat_end ]
 * @param {Object} lightVariation - sets the light [ lgt_start, (lgt_mid_optional), lgt_end ]

 * @return {Object} - The color in format HSL as array [ hue, saturation, lightness ]
 */
function getGradientFromInterpolation(current, min, max, hueVariation, saturationVariation, lightVariation) {

    // If sizes are not equal, we return hsl = [ 0,0,0 ]
    if (hueVariation.length + saturationVariation.length !== lightVariation.length * 2) {
        return [ 0, 0, 0 ];
    }

    // Get type of gradient to work with

    var typeOfGradient = "2-points";

    if (hueVariation.length === 3) {
        typeOfGradient = "3-points";
    }

    // Get the scale factor

    var gamma = 1;

    if ( (max -min) > G_EPSILON_OF_PRECISION ) { // To avoid division by zero
        gamma = (current - min) / (max - min);
    }

    // Now we get the HSL value

    var huePos = hueVariation[ hueVariation.length - 1 ];
    var satPos = saturationVariation[ saturationVariation.length - 1 ];
    var lgtPos = lightVariation[ lightVariation.length - 1 ];

    switch (typeOfGradient) {

        case "3-points":
            gamma *= 2;

            // Interpolation of first and second value, otherwise second and last
            if ( gamma  < 1 ) {
                huePos = ( 1 - gamma ) * hueVariation[0] + gamma * hueVariation[1];
                satPos = ( 1 - gamma ) * saturationVariation[0] + gamma * saturationVariation[1];
                lgtPos = ( 1 - gamma ) * lightVariation[0] + gamma * lightVariation[1];

            } else {
                gamma -= 1;

                huePos = ( 1 - gamma ) * hueVariation[1] + gamma * hueVariation[2];
                satPos = ( 1 - gamma ) * saturationVariation[1] + gamma * saturationVariation[2];
                lgtPos = ( 1 - gamma ) * lightVariation[1] + gamma * lightVariation[2];
            }

            break;

        case "2-points": default:
            huePos = ( 1 - gamma ) * hueVariation[0] + gamma * hueVariation[1];
            satPos = ( 1 - gamma ) * saturationVariation[0] + gamma * saturationVariation[1];
            lgtPos = ( 1 - gamma ) * lightVariation[0] + gamma * lightVariation[1];
    }


    return [ huePos , satPos, lgtPos ];

}

/**
 * Here we have two functions: `parseNumber`, which returns a number in a format
 * like `10 => 1.0000e+1`. Then `setCurrentValues` uses the previous function to set
 * the value in the HTML of `currentValue`, which stores the current value represented
 * by the node above the mouse of the user.
 *
 * @type {Object}
 */
var Utils = {
    parseNumber : function (number) {
        return parseFloat(number).toExponential(4);
    },

    setCurrentValue : function (value) {
        this.$currentValue = $("span#currentValue");
        this.$currentValue.html(this.parseNumber(value));
    }
};
