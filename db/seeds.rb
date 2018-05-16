user  = User.create(email: 'user@example.com', password: 'password')
admin = User.create(email: 'admin@example.com', password: 'password', role: 'admin')

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

@time_from_now_bank = [
  1.hour.from_now,
  2.hours.from_now,
  14.hours.from_now,
  30.minutes.from_now,
]

phone_bank.each { |phone| PhoneNumber.create(phone_number: phone) }

purchase1 = user.purchases.create(worth: 7)
purchase2 = user.purchases.create(worth: 1)

coupon1 = Coupon.create(worth: 1)
coupon2 = Coupon.create(worth: 2)
coupon3 = Coupon.create(worth: 3)

Coupon.claim(user, coupon2.code)


def generate_event(user)
  credit = user.credits.first
  event = user.events.create(name: Faker::Pokemon.name, phone_number_id: PhoneNumber.all.sample.id, session_expiry: @time_ago_bank.sample, duration: 1800, credit_id: credit.id)
  generate_messages(event)
end

def generate_messages(event)
  event.messages.create(from: Faker::PhoneNumber.cell_phone, body: Faker::Hipster.sentence)
end

def generate_current_event(user)
  credit = user.credits.first
  time = @time_from_now_bank.sample.to_time
  duration = time.to_i - Time.now.to_i
  event = user.events.create(name: Faker::Pokemon.name, session_expiry: time, phone_number_id: PhoneNumber.all.sample.id, duration: duration, credit_id: credit.id)
  generate_messages(event)
end

# passed events
generate_event(user)
generate_event(user)
generate_event(user)

# current events
generate_current_event(user)
generate_current_event(user)


