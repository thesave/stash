var imports = new JavaImporter( java.lang.System );

function urldecode( request ){ 
  with( imports ){
    return decodeURI( request.text ); 
  } 
}

String.prototype.matchAll = function(regexp) {
  var matches = [];
  this.replace(regexp, function() {
    var arr = ([]).slice.call(arguments, 0);
    var extras = arr.splice(-2);
    arr.index = extras[0];
    arr.input = extras[1];
    matches.push(arr);
  });
  return matches.length ? matches : null;
};

function findImages( request ){
  with( imports ){
    var response = [];
    var regExp = /src="([\w\W]+?)"/g;
    images = request.html.matchAll( regExp );
    for( var i = 0; images !== null && i < images.length; i++ ) {
      response[ i ] = images[ i ][ 1 ];
    }
    return response;
  }
}