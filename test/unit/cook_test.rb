require 'test_helper'

class CookTest < ActiveSupport::TestCase
  
  test "should create auth_key when created" do
    packer = Cook.create!(username: "testing", email: "email@test.com", password: "test", password_confirmation: "test")
    assert_not_nil packer.auth_key
  end
  
  test "Cook.generate_auth_key should generate a random, unique 40-character authentication key containing mixed case alphanumeric and special characters" do
    assert_match Cook::AUTH_KEY_PATTERN, Cook.generate_auth_key
  end
  
end
