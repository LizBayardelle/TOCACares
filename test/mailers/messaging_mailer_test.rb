require 'test_helper'

class MessagingMailerTest < ActionMailer::TestCase
  test "new_message_email" do
    mail = MessagingMailer.new_message_email
    assert_equal "New message email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "new_response_email" do
    mail = MessagingMailer.new_response_email
    assert_equal "New response email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
