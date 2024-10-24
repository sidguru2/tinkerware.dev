function toggleTopNav() {
  var x = document.getElementById("links");
  if (x.style.display === "flex") {
    x.style.display = "none";
  } else {
    x.style.display = "flex";
  }
}

function closeTopNav(ev) {
  var x = document.getElementById("links");
  x.style.display = "none";
  return true;
}
