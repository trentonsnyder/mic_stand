App.Nav = {
  openMenu() {
    $('#hamburger').click(function(){
      $('#navbar').css('display', 'flex');
    });
  },
  closeMenu() {
    $('#close').click(function(){
      $('#navbar').css('display', 'none');
    });
  }
};

$(document).on("click", "[data-behavior~=open-menu]", () => {
  return App.Nav.openMenu();
});

$(document).on("click", "[data-behavior~=close-menu]", () => {
  return App.Nav.closeMenu();
});
