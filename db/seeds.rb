phone_bank = [
  "+15555551231",
  "+15555551232",
  "+15555551233",
  "+15555551234",
  "+15555551235",
]

@time_ago_bank = [
  2.hours.ago,
  12.hours.ago,
  1.week.ago,
  4.days.ago,
  12.years.ago,
  1.year.ago
]

def random_duration
  [30, 60, 120, 600].sample * 60
end

def generate_messages(event)
  rand(5..25).times do
    event.messages.create(from: Faker::PhoneNumber.cell_phone, body: Faker::Hipster.sentence)
  end
end

def generate_event(user)
  credit = user.available_credits.last
  event = user.events.create(
    name: Faker::Pokemon.name,
    phone_number_id: PhoneNumber.all.sample.id,
    session_expiry: @time_ago_bank.sample,
    duration: random_duration(),
    credit_id: credit.id
  )
  generate_messages(event)
end

def generate_current_event(user)
  credit = user.available_credits.first
  duration = random_duration()
  event = user.events.create(
    name: Faker::Pokemon.name,
    session_expiry: Time.zone.at(Time.current.to_i + duration).utc,
    phone_number_id: PhoneNumber.all.sample.id,
    duration: duration,
    credit_id: credit.id
  )
  generate_messages(event)
end

user  = User.create(email: 'user@example.com', password: 'password')
admin = User.create(email: 'admin@example.com', password: 'password', role: 'admin')

phone_bank.each { |phone| PhoneNumber.create(phone_number: phone) }

purchase1 = user.purchases.create(worth: 7)
purchase2 = user.purchases.create(worth: 1)

Coupon.new(worth: 1).register
Coupon.new(worth: 2).register
Coupon.new(worth: 3).register

Coupon.claim(user, Coupon.first.code)

# passed events
generate_event(user)
generate_event(user)
generate_event(user)

# current events
generate_current_event(user)
generate_current_event(user)
