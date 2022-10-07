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