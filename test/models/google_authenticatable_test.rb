require 'test_helper'
require 'model_tests_helper'

class GoogleAuthenticatableTest < ActiveSupport::TestCase

	def setup
		new_user
	end

	test 'new users have a non-nil secret set' do
		assert_not_nil User.find(1).gauth_secret
	end

	test 'new users should have gauth_enabled disabled by default' do
		assert_equal false, User.find(1).gauth_enabled
	end

	test 'get_qr method works' do
		assert_not_nil User.find(1).get_qr
	end

	test 'updating gauth_enabled to true' do
		User.find(1).set_gauth_enabled(:gauth_enabled => true)
		assert_equal true, User.find(1).gauth_enabled
	end

	test 'updating gauth_enabled back to false' do
		User.find(1).set_gauth_enabled(:gauth_enabled => false)
		assert_equal false, User.find(1).gauth_enabled
	end

	test 'updating the gauth_tmp key' do
		User.find(1).assign_tmp

		assert_not_nil User.find(1).gauth_tmp
		assert_not_nil User.find(1).gauth_tmp_datetime

		sleep(1)

		old_tmp = User.find(1).gauth_tmp
		old_dt = User.find(1).gauth_tmp_datetime

		User.find(1).assign_tmp

		assert_not_equal old_tmp, User.find(1).gauth_tmp
		assert_not_equal old_dt, User.find(1).gauth_tmp_datetime
	end

	test 'testing class method for finding by tmp key' do
		assert User.find_by_gauth_tmp('invalid').nil?
		assert !User.find_by_gauth_tmp(User.find(1).gauth_tmp).nil?
	end

	test 'testing token validation' do
		assert !User.find(1).validate_token('1')
		assert !User.find(1).validate_token(ROTP::TOTP.new(User.find(1).get_qr).at(Time.now))

		User.find(1).assign_tmp

		assert !User.find(1).validate_token('1')
		assert User.find(1).validate_token(ROTP::TOTP.new(User.find(1).get_qr).at(Time.now))
	end

end