$(document).on("ready", () => {
  if ($(".broadcasts.show").length > 0) {
    $("#navbar").css('display', 'none')
    App.cable.subscriptions.create(
      { channel: "BroadcastChannel",
        broadcast_token: $('#broadcast-token').text()
      },
      { connected: function() {},
        disconnected: function() {},
        received: function(data) {
          $('#current-message').text(data.body)
        }
      }
    );
  }
});
