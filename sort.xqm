xquery version "3.0";

(:
: Module Name: XQuery Sort
: Module Version: 0.1
: Copyright: GNU General Public License v3.0
: Proprietary XQuery Extensions Used: None
: XQuery Specification: 08 April 2014
: Module Overview: This module contains XQuery implementations of popular
:                  sorting algorithsm. 
:)
module namespace sort="http://wlpotter.github.io/ns/sort";
import module namespace functx="http://www.functx.com";



(:----------------
  Merge Sort
------------------:)

declare function sort:merge-sort($toSort as item()+, $length as xs:integer)
as item()+
{
  if ($length = 1) then
    $toSort
  else 
  (: left is 1, count(seq)/2; right is count(seq)/2+:)
    let $mid := xs:integer($length div 2)
    let $left := $toSort[position() = (1 to $mid)]
    let $right := $toSort[position() = (($mid + 1) to $length)]
    
    let $left := sort:merge-sort($left, count($left))
    let $right := sort:merge-sort($right, count($right))
    return sort:merge($left, $right, ())
};

declare function sort:merge($left as item()*, $right as item()*, $ordered as item()*)
as item()+
{
  (: base case, no items left to merge :)
  if(empty($left) and empty($right)) then
    $ordered
  (: if one of the two arrays is empty, add the remaining items from the non-empty
     array as these will all be greater than what's in ordered :)
  else if(empty($left)) then
    ($ordered, $right)
  else if (empty($right)) then
    ($ordered, $left)
  (: otherwise, compare the first element of the left and right arrays
     'pop' the lower one and append it to the ordered array :)
  else
    if($left[1] < $right[1]) then
      let $ordered := ($ordered, $left[1])
      let $left := subsequence($left, 2, count($left))
      return sort:merge($left, $right, $ordered)
    else
      let $ordered := ($ordered, $right[1])
      let $right := subsequence($right, 2, count($right))
      return sort:merge($left, $right, $ordered)
};

(:------------------
  END Merge Sort
  ------------------:)
  
  (: Additional sorting algorithms TBD :)
  
(:-----------------
  Useful comparison functions
  -----------------:)
  
(:
: Numerically compares number strings (normal 'order by' or fn:sort treats numerical strings as strings, so '100' precedes '99').
: Useful for numerically comparing numerical subsections (e.g., 1.1.1 vs 1.1.2)
: the $separator parameter controls what divides portions of a multi-sectioned number (e.g., '.')
:)
declare function sort:numeric-compare-deep($x as xs:string, $y as xs:string, $separator as xs:string)
as xs:string
{
  let $xNow := functx:substring-before-if-contains($x, $separator)
  let $xRest := substring-after($x, $separator)
  let $yNow :=  functx:substring-before-if-contains($y, $separator)
  let $yRest := substring-after($y, $separator)
  return 
    if ($xNow = "" or $yNow = "") then "one or more parameters are empty"
    else if(xs:integer($xNow) < xs:integer($yNow)) then "less than"
    else if (xs:integer($xNow) > xs:integer($yNow)) then "greater than"
    else if(xs:integer($xNow) = xs:integer($yNow)) then
      if ($xRest = "" and $yRest = "") then "equal to"
      else if($xRest = "" and $yRest != "") then "less than"
      else if($xRest != "" and $yRest = "") then "greater than"
      else sort:numeric-compare-deep($xRest, $yRest, $separator)
  else()
};

(: returns true() if the left parameter is smaller than the right paramater, according
   to the logic of the sort:numerical-comparison-deep function. :)
declare function sort:numeric-le-deep($x as xs:string, $y as xs:string, $separator as xs:string)
as xs:boolean
{
  sort:numeric-compare-deep($x, $y, $separator) = "less than"
};

(: returns true() if the left parameter is larger than the right paramater, according
   to the logic of the sort:numerical-comparison-deep function. :)
declare function sort:numeric-ge-deep($x as xs:string, $y as xs:string, $separator as xs:string)
as xs:boolean
{
  sort:numeric-compare-deep($x, $y, $separator) = "greater than"
};

(: returns true() if the left parameter is equal to the right paramater, according
   to the logic of the sort:numerical-comparison-deep function. :)
declare function sort:numeric-eq-deep($x as xs:string, $y as xs:string, $separator as xs:string)
as xs:boolean
{
  sort:numeric-compare-deep($x, $y, $separator) = "equal to"
};