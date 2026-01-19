require "minitest/autorun"
require_relative 'implementation'
require_relative 'notifiers/email_notifier'
require_relative 'notifiers/sms_notifier'
require_relative 'notifiers/push_notifier'

class NotifierFactoryTest <  Minitest::Test


  def test_email_notifier_creation
    notifier = NotifierFactory.create(:email)
    assert_instance_of EmailNotifier, notifier
  end

  def test_push_notifier_creation
    notifier = NotifierFactory.create(:push)
    assert_instance_of PushNotifier, notifier
  end
  
  def test_sms_notifier_creation
    notifier = NotifierFactory.create(:sms)
    assert_instance_of SmsNotifier, notifier
  end
end
