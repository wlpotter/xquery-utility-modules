xquery version "3.0";

(:
: Module Name: Unit Testing for an XQuery Stack Implementation
: Module Version: 0.1
: Copyright: GNU General Public License v3.0
: Proprietary XQuery Extensions Used: None
: XQuery Specification: 08 April 2014
: Module Overview: This module contains unit tests for developing a stack data type.
:)

module namespace stack-test="http://wlpotter.github.io/ns/stack-test";

import module namespace stack="http://wlpotter.github.io/ns/stack" at "stack.xqm";

declare variable $stack-test:cdata-stack := 
<stack>
  <element>1</element>
  <element>2</element>
  <element>elephant</element>
  <element>3</element>
</stack>;

declare variable $stack-test:cdata-stack-popped := 
<stack>
  <element>2</element>
  <element>elephant</element>
  <element>3</element>
</stack>;

declare variable $stack-test:cdata-stack-pushed-with-test := 
<stack>
  <element>test</element>
  <element>1</element>
  <element>2</element>
  <element>elephant</element>
  <element>3</element>
</stack>;

declare variable $stack-test:node-stack := 
<stack>
  <element>
    <item/>
  </element>
  <element>
    <msItem>
      <msItem/>
    </msItem>
    <secondMsItem/>
  </element>
  <element><item/></element>
</stack>;

declare %unit:test function stack-test:initialize-stack-of-cdata() {
  unit:assert-equals(stack:initialize(("1", "2", "elephant", "3")), $stack-test:cdata-stack)
};

declare %unit:test function stack-test:initialize-empty-stack() {
  unit:assert-equals(stack:initialize(()), <stack/>)
};

(: test initialize on stack of stacks and on stack of elements :)

declare %unit:test function stack-test:pop-stack-of-cdata-returned-value() {
  unit:assert-equals(xs:string(stack:pop($stack-test:cdata-stack)[1]), "1")
};

declare %unit:test function stack-test:pop-stack-of-cdata-returned-stack() {
  unit:assert-equals(stack:pop($stack-test:cdata-stack)[2], $stack-test:cdata-stack-popped)
};

declare %unit:test function stack-test:push-stack-of-cdata-with-cdata() {
  unit:assert-equals(stack:push($stack-test:cdata-stack, "test"), $stack-test:cdata-stack-pushed-with-test)
};

declare %unit:test function stack-test:length-of-cdata-stack() {
  unit:assert-equals(stack:length($stack-test:cdata-stack), 4)
};