function gosubTerm(output) {
  window.popup = window.open('', 'height=640,width=480');
  
  function run(output) {
    window.gosub.run(output);
  }
  
  function popup() {
    return $(window.popup.document.body);
  }
  
  window.green = function(args) {
    popup().append($('<p style="color: green">').text(""+args));
  }
  
  window.write = function(text) {
    popup().append($('<pre>').text(""+text));
  }
  
  function cls() {
    popup().html('<h3>gosub</h3>')
  }
  
  cls();
  run(output);
};