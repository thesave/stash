include "console.iol"
include "file.iol"
include "json_utils.iol"

type HexArrayType: void {
  .hexArray*: string
}

type ClosestColorType: void {
  .colors*:string
  .target: string
}

interface SortColor {
  RequestResponse: 
  sortHex( HexArrayType )( HexArrayType ),
  closestColor( ClosestColorType )( string ),
}

outputPort JSUtils {
  Location: "local"
  Interfaces: SortColor
}

embedded {
  JavaScript: "sort_color.js" in JSUtils
}

main
{
  chosenColor = "#843179";
  readFile@File( {.filename = "langs.json" } )( langs );
  getJsonValue@JsonUtils( langs )( langs );
  html = "<html><head><style>div.box { width: 30px; height: 30px; float: left; }</style></head><body><div style='overflow: auto;'>";
  color -> langs.( lang ).color;
  foreach ( lang : langs ) {
    if ( is_defined( color ) ){
      colors.hexArray[ #colors.hexArray ] = color
    }
  };
  sortHex@JSUtils( colors )( colors );
  clReq.colors << colors.hexArray;
  clReq.target = chosenColor;
  closestColor@JSUtils( clReq )( closest );
  for ( color in colors.hexArray ) {
    html += "<div class='box' style='background-color:" + color + "'></div>"
  };
  html += "</div><div class='box' style='float:right; background-color:" + chosenColor + "'>Jolie</div>";
  html += "</div><div class='box' style='float:right; background-color:" + closest + "'>Closest</div>";
  writeFile@File( {.filename = "colors.html", .content = html } )()
}
