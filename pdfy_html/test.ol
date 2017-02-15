include "console.iol"
include "string_utils.iol"
include "file.iol"

main
{
  readFile@File( { .filename = "tmp_article.html" } )( content );
  // match@StringUtils( content { .regex = "src=\"https?:\\/\\/[-a-zA-Z0-9@:%_\\+.~#?&\\/\\/=,]+\"" } )( content );
  replaceAll@StringUtils( content { .replacement = "", .regex = "src=\"https?:\\/\\/[-a-zA-Z0-9@:%_\\+.~#?&\\/\\/=,]+\"" } )( content );
  println@Console( content )()
}