namespace :sim_message do
  desc "simulates bandwitdth callback"
  task :send, [:ngrok, :from, :to] => :environment do |_t, args|
    # rake sim_message:send[http://8034613f.ngrok.io,+15559095555,+14242396328]
    message_bank = [
      "Revenge is a dish best served cold.",
      "I'm going to make him an offer he can't refuse.",
      "It's a Sicilian message. It means Luca Brasi sleeps with the fishes.",
      "Goddamn FBI don't respect nothin'.",
      "Leave the gun. Take the cannoli.",
      "In Sicily, women are more dangerous than shotguns.",
      "It's not personal Sonny, It's strictly bussiness.",
      "Never hate your enemies, it affects your judgement.",
      "The lawyer with the briefcase can steal more money than the man with the gun.",
      "Accidents don't happen to people who take accidents as a personal insult.",
      "Time erodes gratitude more quickly than it does beauty!",
      "Forgive. Forget. Life is full of misfortunes.",
      "Only don't tell me that you're innocent. Because it insults my intelligence and it makes me very angry.",
      "Fredo, you're my older brother, and I love you. But don't ever take sides with anyone against the family again.",
      "What you think this is the army where you shoot them a mile away, you got to get them close like this and Bada-Bing!"
    ]
    HTTParty.post("#{args[:ngrok]}/hooks/messages",
      body: {
        "eventType": "sms",
        "direction": "in",
        "messageId": "156333",
        "messageUri": "www.example.com",
        "from": args[:from],
        "to": args[:to],
        "text": message_bank.sample,
        "applicationId": "ABCD",
        "time": Time.current.to_s,
        "state": "received"
      }.to_json,
      headers: {'content-type' => 'application/json'})
  end
end