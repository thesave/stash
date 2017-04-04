var window = {};
load( "tinycolor.js" )
load( "deltae.global.min.js" )

function println( s ){
  Java.type( "java.lang.System" ).out.println( s );
}

function sortColors( colArray ){
  colArray.sort( function(colorA, colorB) {
    tcA = window.tinycolor(colorA).toHsl();
    tcB = window.tinycolor(colorB).toHsl();
    return tcA.h - tcB.h
  });
}

function addValue( vector, object ){
  vector.add( Java.type( "jolie.runtime.Value" ).create( object ) );
}

function rgbTOxyz( c ){
  var r = c.r / 255;
  var g = c.g / 255;
  var b = c.b / 255;

  // assume sRGB
  r = r > 0.04045 ? Math.pow(((r + 0.055) / 1.055), 2.4) : (r / 12.92);
  g = g > 0.04045 ? Math.pow(((g + 0.055) / 1.055), 2.4) : (g / 12.92);
  b = b > 0.04045 ? Math.pow(((b + 0.055) / 1.055), 2.4) : (b / 12.92);

  var x = (r * 0.4124) + (g * 0.3576) + (b * 0.1805);
  var y = (r * 0.2126) + (g * 0.7152) + (b * 0.0722);
  var z = (r * 0.0193) + (g * 0.1192) + (b * 0.9505);

  return [x * 100, y * 100, z * 100];
}

function rgbTOlab( c ){
  var xyz = rgbTOxyz( c );
  var x = xyz[0];
  var y = xyz[1];
  var z = xyz[2];
  var l;
  var a;
  var b;

  x /= 95.047;
  y /= 100;
  z /= 108.883;

  x = x > 0.008856 ? Math.pow(x, 1 / 3) : (7.787 * x) + (16 / 116);
  y = y > 0.008856 ? Math.pow(y, 1 / 3) : (7.787 * y) + (16 / 116);
  z = z > 0.008856 ? Math.pow(z, 1 / 3) : (7.787 * z) + (16 / 116);

  l = (116 * y) - 16;
  a = 500 * (x - y);
  b = 200 * (y - z);

  return [l, a, b];
};

function getDistance( hexC1, hexC2 ){
  c1 = window.tinycolor( hexC1 ).toRgb();
  _c1 = rgbTOlab( c1 );
  labC1 = { L: _c1[0], A: _c1[1], B: _c1[2] };
  c2 = window.tinycolor( hexC2 ).toRgb();
  _c2 = rgbTOlab( c2 );
  labC2 = { L: _c2[0], A: _c2[1], B: _c2[2] };
  return window.DeltaE.getDeltaE00( labC1, labC2 );
}

function closestColor( req ){
  var closest = {};
  closest.color = req.colors[ 0 ];
  closest.delta = getDistance( closest.color, req.target );
  for ( var i = 1; i < req.colors.length; i++ ) {
    var delta = getDistance( req.colors[ i ], req.target )
    if( delta < closest.delta ) {
      closest.color = req.colors[ i ];
      closest.delta = delta;
    }
  }
  var response = Java.type( "jolie.runtime.Value" ).create();
  response.setValue( closest.color );
  addValue( response.getChildren( "delta" ), closest.delta );
  return response;
}

function getRandomColor() {
  return window.tinycolor.random().toHex();
}

function sortHex( hexColors ) {
  var colors = [];
  for (var i = 0; i < hexColors.hexArray.length; i++) {
    var tcC = hexColors.hexArray[i];
    var tcL = ~~( window.tinycolor( tcC ).toHsl().l.toFixed( 2 ) * 10 );
    if ( colors[ tcL ] == null ) { colors[ tcL ] = []; }
    colors[ tcL ].push( tcC );
  }

  var response = Java.type( "jolie.runtime.Value" ).create();
  var hexArray = response.getChildren( "hexArray" );

  for (var i = 0; i < colors.length; i++) {
    if ( colors[i] != null ) {
      for (var j = 0; j < colors[i].length; j++) {
        addValue( hexArray, colors[i][j] );
      }
    }
  }

  return response;
};