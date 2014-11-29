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

    var huePos = 240;

    if ( (max -min) !== 0) {
        huePos = (1 - (current - min) / (max - min)) * 240;
    }

    var typeSchema = exists(alpha) ? 'hsla' : 'hsl';
    var alphaValue = exists(alpha) ? (', ' + alpha) : '';

    return typeSchema + '(' + huePos + ', 100%, 50%' + alphaValue + ')';
}


var Utils = {
    parseNumber : function (number) {
        return parseFloat(number).toExponential(4);
    },

    $currentValue : $("#currentValue"),
    setCurrentValue : function (value) {
        this.$currentValue.html(this.parseNumber(value));
    }
};


var Queue = (function(){

    function Queue() {};

    Queue.prototype.running = false;

    Queue.prototype.queue = [];

    Queue.prototype.add_function = function(callback) { 
        var _this = this;
        //add callback to the queue
        this.queue.push(function(){
            var finished = callback();
            if(typeof finished === "undefined" || finished) {
               //  if callback returns `false`, then you have to 
               //  call `next` somewhere in the callback
               _this.next();
            }
        });

        if(!this.running) {
            // if nothing is running, then start the engines!
            this.next();
        }

        return this; // for chaining fun!
    };

    Queue.prototype.next = function(){
        this.running = false;
        //get the first element off the queue
        var shift = this.queue.shift(); 

        if(shift) { 
            this.running = true;
            console.log('#', shift);
            setTimeout(shift(), 5); 
        }
    };

    return Queue;

})();