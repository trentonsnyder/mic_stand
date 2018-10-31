class Hooks::MessagesController < Hooks::BaseController
  # consider changing name from MessagesController -> SomethingElseController
  def create
    begin
      filter_for_sms(params[:eventType])
      phone = find_phone(params[:to])
      event = find_event(phone.id)
      message = event.messages.new(from: params[:from], body: params[:text], kind: 'sms')
      unless message.save
        Rails.logger.error("MESSAGE HOOK ERROR: Problem creating message #{message.errors.full_messages.join(', ')}")
      end
    rescue StandardError => exception
      Rails.logger.error("MESSAGE HOOK ERROR: " + exception.message)
    end
    head :ok
  end

  protected

  def filter_for_sms(eventType)
    if eventType != "sms"
      raise StandardError.new("non SMS message received")
    end
  end

  def find_phone(to)
    # phone number in db should be normalized
    phone = PhoneNumber.find_by(phone_number: to)
    if phone
      phone
    else
      raise StandardError.new("Phone not in db #{to}")
    end
  end

  def find_event(phone_id)
    event = Event.current.find_by(phone_number_id: phone_id)
    if event
      event
    else
      raise StandardError.new("Event not active/not found fer phone_id: #{phone_id}")
    end
  end
end