var Color = function Color(hexVal) {
  this.hex = hexVal;
};

constructColor = function(colorObj){
  var hex = colorObj.hex.substring(1);
  /* Get the RGB values to calculate the Hue. */
  var r = parseInt(hex.substring(0, 2), 16) / 255;
  var g = parseInt(hex.substring(2, 4), 16) / 255;
  var b = parseInt(hex.substring(4, 6), 16) / 255;

  /* Getting the Max and Min values for Chroma. */
  var max = Math.max.apply(Math, [r, g, b]);
  var min = Math.min.apply(Math, [r, g, b]);


  /* Variables for HSV value of hex color. */
  var chr = max - min;
  var hue = 0;
  var val = max;
  var sat = 0;


  if (val > 0) {
    /* Calculate Saturation only if Value isn't 0. */
    sat = chr / val;
    if (sat > 0) {
      if (r == max) {
        hue = 60 * (((g - min) - (b - min)) / chr);
        if (hue < 0) {
          hue += 360;
        }
      } else if (g == max) {
        hue = 120 + 60 * (((b - min) - (r - min)) / chr);
      } else if (b == max) {
        hue = 240 + 60 * (((r - min) - (g - min)) / chr);
      }
    }
  }
  colorObj.chroma = chr;
  colorObj.hue = hue;
  colorObj.sat = sat;
  colorObj.val = val;
  colorObj.luma = 0.3 * r + 0.59 * g + 0.11 * b;
  colorObj.red = parseInt(hex.substring(0, 2), 16);
  colorObj.green = parseInt(hex.substring(2, 4), 16);
  colorObj.blue = parseInt(hex.substring(4, 6), 16);
  return colorObj;
};

sortColorsByHue = function (colors) {
  return colors.sort(function (a, b) {
    return a.hue - b.hue;
  });
};

function sortHex( hexColors ) {
  var colors = [];
  for (var i = 0; i < hexColors.hexArray.length; i++) {
    var color = new Color( hexColors.hexArray[ i ] );
    constructColor(color);
    colors.push(color);
  };

  sortColorsByHue( colors );

  
  var response = Java.type( "jolie.runtime.Value" ).create();
  var hexArray = response.getChildren( "hexArray" );
  
  for ( var i = 0; i < colors.length; i++ ) {
    hexArray.add( Java.type( "jolie.runtime.Value" ).create( colors[ i ].hex ) );
  }
  return response;
};