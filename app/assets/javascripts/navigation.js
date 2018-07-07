$(document).on("click", "[data-behavior~=open-menu]", () => {
  $('#navbar').css('display', 'flex')
});

$(document).on("click", "[data-behavior~=close-menu]", () => {
  $('#navbar').css('display', 'none');
});
