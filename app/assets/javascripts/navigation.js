App.Nav = {
  classToggle() {
    const navs = document.querySelectorAll('.navbar-items')
    navs.forEach(nav => nav.classList.toggle('navbar-toggle-show'));
  }
};

$(document).on("click", "[data-behavior~=toggle-nav]", () => {
  return App.Nav.classToggle();
});
