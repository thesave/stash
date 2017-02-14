include "console.iol"
include "file.iol"
include "exec.iol"
include "string_utils.iol"
include "config.iol"

outputPort Readability {
  Location: "socket://mercury.postlight.com:443"
  Protocol: https {
    .method = "get";
    .osc.parse.alias = "parser?url=%!{url}";
    .contentType = "application/json";
    .addHeader.header[0] << "x-api-key" { .value = API_KEY }
    // ;.debug << true { .showContent = true }
  }
  RequestResponse: parse
}

outputPort JS_service {
  RequestResponse: urldecode, findImages
}

embedded {
  JavaScript: "utils.js" in JS_service
}

main
{
  art[#art] = "https://...";
  art[#art] = "https://...";
  art[#art] = "https://...";
  req.url -> art[urlIdx];
  for (urlIdx=0, urlIdx<#art, urlIdx++) {
    parse@Readability( req )( res );
    // replaceAll@StringUtils( res.content { .replacement = "$1$2\"", .regex = "(https:\\/\\/.+?)-\\d+x\\d+(\\.png).+\"" } )( res.content );
    // replaceAll@StringUtils( res.content { .replacement = "$1$2\"", .regex = "(https:\\/\\/.+?)-\\d+x\\d+(\\.png).+\"" } )( res.content );
    // urldecode@JS_service( { .text = res.content } )( res.content );
    // unescapeHTML@HTMLUtils( res.content )( res.content );
    println@Console( "Retrieved article: " + res.title )();
    
    file.filename = "tmp_article.html";
    file.content = "<h1>" + res.title + "</h1>" + res.content + "\n";
    writeFile@File( file )();

    multiImageRegEx = "src=\"https?:\\/\\/[-a-zA-Z0-9@:%_\\+.~#?&\\/\\/=]+,(%20https?:\\/\\/[-a-zA-Z0-9@:%_\\+.~#?&\\/\\/=,]+)+\"";
    replaceAll@StringUtils( res.content { .replacement = "", .regex = multiImageRegEx } )( res.content );

    findImages@JS_service( { .html = res.content } )( images );

    for ( image in images._ ) {
      newImgName = "image_" + y++;
      println@Console( "retrieving image: " + image )();
      exec@Exec( "wget" {
        .args[j++] = image,
        .args[j++] = "-O",
        .args[j++] = newImgName,
        .waitFor = 1
      } )();
      j=0;
      replaceAll@StringUtils( image { .replacement = "\\\\$0", .regex = "([-[\\\\]{}()*+?.,\\^$|#\\s])" } )( image );
      replaceAll@StringUtils( res.content { .replacement = newImgName, .regex = image } )( res.content )
    }; y=0;                                                             

    // valueToPrettyString@StringUtils( response )( t );
    // println@Console( t )();
    
    file.content = "<h1>" + res.title + "</h1>" + res.content + "\n";
    outputFile = res.title + ".pdf";
    writeFile@File( file )();
    println@Console( "Saved Temp HTML file" )();
    exec@Exec( "pandoc" {
      .args[j++] = "-s",
      .args[j++] = file.filename,
      .args[j++] = "-o",
      .args[j++] = outputFile,
      .args[j++] = "--latex-engine=xelatex",
      .args[j++] = "--variable",
      .args[j++] = "urlcolor=magenta",
      // .args[j++] = "-s",
      .waitFor = 1
    } )( out ); j=0;
    if( is_defined( out.stderr ) ) {
      println@Console( out.stderr )()
    } else {
      delete@File( file.filename )();
      for ( image in images._ ) { 
        delete@File( "image_" + z++ )()
      }; z = 0;
      println@Console( "PDFed: " + outputFile )()
    }
  }
}