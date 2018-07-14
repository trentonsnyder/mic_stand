$(document).on("click", "[data-behavior~=open-menu]", () => {
  $('#navbar').css('display', 'flex')
});

$(document).on("click", "[data-behavior~=close-menu]", () => {
  $('#navbar').css('display', 'none');
});

$(document).on("ready", () => {
  window.addEventListener('resize', () => {
    if (document.body.clientWidth > 768) {
      $('#navbar').css('display', 'flex')
    }
  }, true);
})