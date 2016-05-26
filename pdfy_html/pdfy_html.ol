include "console.iol"
include "file.iol"
include "exec.iol"
include "string_utils.iol"
include "../config/pdfy.iol"

outputPort Readability {
  Location: "socket://www.readability.com:443/api/content/v1"
  Protocol: https {
    .method = "get";
    .osc.parse.alias = "/parser"
    // .debug << true { .showContent = true }
  }
  RequestResponse: parse
}

main
{
  art[#art] = "http://jolie-lang.org";
  req.url -> art[i];
  req.token = token;
  for (i=0, i<#art, i++) {
    parse@Readability( req )( res );
    replaceAll@StringUtils( res.content { .replacement = "$1$2\"", .regex = "(https:\\/\\/.+?)-\\d+x\\d+(\\.png).+\"" } )( res.content );
    replaceAll@StringUtils( res.content { .replacement = "$1$2\"", .regex = "(https:\\/\\/.+?)-\\d+x\\d+(\\.png).+\"" } )( res.content );
    file.content += "<h1>" + res.title + "</h1>" + res.content + "\n";
    println@Console( "Retrieved article: " + res.title )()
  };
  file.filename = "article.html";
  outputFile = "article.pdf";

  writeFile@File( file )();
  println@Console( "Saved Temp HTML file" )();
  j=0;
  exec@Exec( "pandoc" { 
    .args[j++] = "-s",
    .args[j++] = file.filename,
    .args[j++] = "-o",
    .args[j++] = outputFile,
    .args[j++] = "--toc",
    .args[j++] = "--variable",
    .args[j++] = "urlcolor=magenta",
    .args[j++] = "-s",
    .waitFor = 1
  } )( out );
  if( is_defined( out.stderr ) ) {
    println@Console( out.stderr )()
  } else {
    delete@File( file.filename )();
    println@Console( "PDFed: " + outputFile )()
  }
}