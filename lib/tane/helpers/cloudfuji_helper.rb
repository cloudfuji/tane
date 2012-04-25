class Tane::Helpers::Cloudfuji
  include Tane::Helpers
  
  class << self
    def cloudfuji_url
      ENV['CLOUDFUJI_URL'] || "http://cloudfuji.com"
    end

    # Returns nil if credentials are invalid
    # Returns the authentication_token if credentials are valid
    def verify_credentials(email, password)
      begin
        result = JSON(RestClient.get("#{cloudfuji_url}/users/verify.json", { :params => {:email => email, :password => password }}))
        if result['errors'].nil?
          return result['authentication_token'], nil
        else
          return nil, result['errors']
        end
      rescue => e
        return nil, ["Couldn't login with those credentials!"]
      end
    end
    
    def signup(email, password)
      term.say "Contacting cloudfuji..."
      term.say "(using #{cloudfuji_url}/users/create.json)"

      begin
        result = JSON(RestClient.get("#{cloudfuji_url}/users/create.json", { :params => {:email => email, :password => password }}))

        if result['errors'].nil?
          return result['authentication_token'], nil
        else
          return nil, result['errors']
        end
      rescue => e
        if e.respond_to?(:http_body)
          return nil, [["", [JSON(e.http_body)['error']]]]
        end

        return nil
      end
    end

    def authenticate_user(email, password)
      warn_if_credentials
    end

  end
end
