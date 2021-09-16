xquery version "3.0";

(:
: Module Name: XQuery Stack
: Module Version: 0.1
: Copyright: GNU General Public License v3.0
: Proprietary XQuery Extensions Used: None
: XQuery Specification: 08 April 2014
: Module Overview: This module contains an implementation of the stack abstract
:                  data type.
:)

(:
ADD XQDOC COMMENTS HERE (SEE STYLE GUIDE P 14)
:)

module namespace stack="http://wlpotter.github.io/ns/stack";

(:
data model:

<stack>
  <element>CDATA</element>
  <element>CDATA</element>
  <element>CDATA</element>
  <element>CDATA</element>
  ...
  <element>CDATA</element>
</stack>
:)

declare function stack:initialize($seq as item()*) as node() {
  let $elSeq := for $item in $seq
    return <element>{$item}</element>
  return <stack>{$elSeq}</stack>
};

(: add error handling of empty stack :)

(: note on this function: the constraints of xquery require that the popped stack be returned and copied into the calling variable, thus this function should be called as follows:
: let $poppedValue := stack:pop($myStack)[1]
: let $myStack := stack:pop($myStack)[2]
: This ensures that the popped value is stored and that the popped stack is stored in the variable of the stack that called the pop function (note that this is technically 'copied into' a variable of the same name, so memory issues with XQuery can be problematic...)
:)
declare function stack:pop($stack as node()) as item()+ {
  let $poppedValue := $stack/element[1]/node()
  let $poppedStack := <stack>{$stack/element[position()>1]}</stack>
  return ($poppedValue, $poppedStack)
};

declare function stack:push($stack as node(), $value as item()) as node() {
  let $pushedElement := <element>{$value}</element>
  let $pushedStack := element {"stack"} {$pushedElement, $stack/element}
  return $pushedStack
};

declare function stack:length($stack as node()) as xs:integer {
  let $length := fn:count($stack/element)
  return $length
};