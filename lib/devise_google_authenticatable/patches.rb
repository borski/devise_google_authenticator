module DeviseGoogleAuthenticator
  module Patches
    autoload :CheckGA, 'devise_google_authenticatable/patches/check_ga'

    class << self
      def apply
        Devise::SessionsController.send(:include, Patches::CheckGA)
      end
    end
  end
end
