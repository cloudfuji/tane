class Tane::Helpers::Bushido
  class << self
    def bushido_url
      ENV['BUSHIDO_URL'] || "http://bushi.do"
    end

    # Returns nil if credentials are invalid
    # Returns the authentication_token if credentials are valid
    def verify_credentials(email, password)
      begin
        result = JSON(RestClient.get("#{bushido_url}/users/verify.json", { :params => {:email => email, :password => password }}))
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
      begin
        term.say "Contacting bushido..."
        term.say "(using #{bushido_url}/users/create.json)"
        result = JSON(RestClient.get("#{bushido_url}/users/create.json", { :params => {:email => email, :password => password }}))

        if result['errors'].nil?
          return result['authentication_token'], nil
        else
          return nil, result['errors']
        end
      rescue => e
        if e.responds_to?(:http_body)
          return nil, JSON(e.http_body)['errors']
        end

        return nil
      end
    end

    def authenticate_user(email, password)
      warn_if_credentials
      
    end

  end
end
