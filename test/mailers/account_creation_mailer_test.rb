require 'test_helper'

class AccountCreationMailerTest < ActionMailer::TestCase
  test "create_an_account_email" do
    mail = AccountCreationMailer.create_an_account_email
    assert_equal "Create an account email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
