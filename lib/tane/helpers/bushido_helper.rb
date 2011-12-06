class Tane::Helpers::Bushido
  class << self
    # Returns nil if credentials are invalid
    # Returns the authentication_token if credentials are valid
    def verify_credentials(email, password)
      return "abc123" if email == 's@bushi.do' && password == 'x'
      return false
    end

    def signup(email, password)
      return 'momomo' if email == 's' && password == 'y'
    end
  end
end
