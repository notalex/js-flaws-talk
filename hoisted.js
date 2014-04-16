//--
function foo(){
  function bar() { return val; }
  var val
  val = 'value'
  return bar()
}


function foo(){
  function bar() { return val; }
  var val
  return bar()
  val = 'value'
}


function foo(){
  var val
  var b
  return bar()
  bar = function() { return val; }
}
