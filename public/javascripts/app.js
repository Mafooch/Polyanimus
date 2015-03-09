function empty() {
  var name = $("#nameBox").val();
  var quote = $("#quoteBox").val();
  if (name == "" || quote == "") {
    alert("You must enter a valid submission");
    return false;
  };
};

$("#submit").on("click", empty);
