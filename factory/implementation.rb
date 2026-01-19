require_relative 'notifiers/email_notifier'
require_relative 'notifiers/sms_notifier'
require_relative 'notifiers/push_notifier'

class NotifierFactory
  NOTIFIERS = {
    email: EmailNotifier,
    sms: SmsNotifier,
    push: PushNotifier
  }

  def self.create(type)
    notifier_class = NOTIFIERS[type]
    raise "Notifier type #{type} not supported." unless notifier_class

    notifier_class.new
  end
end

NotifierFactory.create(:email).send(message: 'Hello via Email!')