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

type ClosestColorTypeRes: string {
  .delta: undefined
}

interface SortColor {
  RequestResponse: 
  sortHex( HexArrayType )( HexArrayType ),
  closestColor( ClosestColorType )( ClosestColorTypeRes ),
  getRandomColor( void )( string )
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
  bestColors[ #bestColors ] = "aefde1";  
  bestColors[ #bestColors ] = "360a1c";
  bestColors[ #bestColors ] = "2ff5ee";
  bestColors[ #bestColors ] = "b5fde2";
  bestColors[ #bestColors ] = "380219";
  clReq.target -> chosenColor;
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
  for ( color in colors.hexArray ) {
    html += "<div class='box' style='background-color:" + color + "'></div>"
  };
  html += "</div>";

  // for ( i=0, i<10000, i++ ) {
  for ( i=-1, i < #bestColors, i++ ) {
    if( i>=0 ) {
      // getRandomColor@JSUtils()( chosenColor )
      chosenColor = bestColors[ i ]
    };
    closestColor@JSUtils( clReq )( closest );
    // if( closest.delta > 13 ) {
      html += "<div style='overflow: auto;'>";
      html += "<div style='float:right;'>Proposed</div>";
      html += "<div class='box' style='float:right; background-color:" + chosenColor + "'></div>";
      html += "<div class='box' style='float:right; background-color:" + closest + "'></div>";
      html += "<div style='float:right;margin-right:5px;'>Closest</div>";
      html += "<div style='float:right;margin-right:10px;'>Delta: " + closest.delta + " </div>";
      html += "</div>"
    // }
  };
  writeFile@File( {.filename = "colors.html", .content = html } )()
}
