module Offer
  def self.packages
    [
      {
        name:  "a-package",
        display_name: "Good",
        worth: 1,
        amount: 2,
        pence:  200
      },
      {
        name: "b-package",
        display_name: "Better",
        worth: 5,
        amount: 8,
        pence:  800
      },
      {
        name: "c-package",
        display_name: "Best",
        worth: 10,
        amount: 12,
        pence:  1200
      },
    ]
  end
end
