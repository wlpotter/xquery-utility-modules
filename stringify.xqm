xquery version "3.1";

(:
: Module Name: Stringify XQuery
: Module Version: 0.1
: Copyright: GNU General Public License v3.0
: Proprietary XQuery Extensions Used: None
: XQuery Specification: 08 April 2014
: Module Overview: This module contains functions for converting XML nodes into
:                  their string representations. Useful for sharing 
:)

module namespace strfy="http://wlpotter.github.io/ns/strfy";

import module namespace functx="http://www.functx.com";
(:
: @param $node is a well-formed XML node. This function returns a string
: representation of that node, escaping the angle brackets and other reserved
: characters
:)

declare function strfy:stringify-node($node as node())
as xs:string
{
  
  let $nodeName := name($node)
  let $attrString := if($node/@*) then 
    for $attr in $node/@*
    return name($attr)||"='"||string($attr)||"'"
    else ""
  let $attrString := " "||string-join($attrString, " ")
  let $descendantString := 
    for $child in $node/child::node()
    return switch(functx:node-kind($child))
      case "text" return $child
      case "element" return strfy:stringify-node($child)
      case "comment" return $child
      default return ""
  let $descendantString := string-join($descendantString)
  return "&lt;"||$nodeName||$attrString||"&gt;"||$descendantString||"&lt;/"||$nodeName||"&gt;"
};