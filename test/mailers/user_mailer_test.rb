require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "reset_password_email" do
    mail = UserMailer.reset_password_email(users(:susan))
    assert_equal "Your password has been reset", mail.subject
    assert_equal [users(:susan).email], mail.to
    assert_equal ["from@example.com"], mail.from
  end

end
