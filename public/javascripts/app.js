function empty() {
  var title = $("#titleBox").val();
  var name = $("#nameBox").val();
  var quote = $("#quoteBox").val();
  if (title == "" || name == "" || quote == "") {
    alert("You must enter a valid submission");
    return false;
  };
};

$("#submit").on("click", empty);

$("#random_thought").on("click", function() {
  $.get("/thought.json", function(newThought) {
    $("#title_header").text(newThought.title);
    $("#thinker_header").text(newThought.thinker);
    $("#quote_text").text(newThought.thought);
  });
});
