// TODO: fix clear timeout stuff.
App.Flash = {
  successTimer() {
    window.setTimeout(function() { $('#success-flash').hide() }, 5000)
  },
  errorTimer() {
    window.setTimeout(function() { $('#error-flash').hide() }, 5000)
  },
  timeoutFlash() {
    App.Flash.successTimer()
    App.Flash.errorTimer()
  },
  clearFlash() {
    App.Flash.clearTimeouts()
    $('#success-flash').hide();
    $('#error-flash').hide();
  },
  dismissFlash(elem) {
    App.Flash.clearTimeouts()
    elem.hide()
  },
  clearTimeouts() {
    window.clearTimeout(App.Flash.successTimer)
    window.clearTimeout(App.Flash.errorTimer)
  }
};

$(document).on("turbolinks:load", () => App.Flash.timeoutFlash() );
$(document).on("turbolinks:before-render", () => App.Flash.clearFlash() );

$(document).on("click", "[data-behavior~=dismiss-error-flash]", () => {
  return App.Flash.dismissFlash($('#error-flash'));
});

$(document).on("click", "[data-behavior~=dismiss-success-flash]", () => {
  return App.Flash.dismissFlash($('#success-flash'));
});