# frozen_string_literal: true

module Auth
  extend ActiveSupport::Concern

  private

  # Override auth_param if you ever need to use a different method for token retrieval.
  # Default is the 'Authorization' header as recommended by the JWT pattern.
  def auth_param
    request.headers['Authorization'].split(' ')[1]
  end

  def encode_token(payload)
    JWT.encode(payload, ENV.fetch('JWT_SIGN_SECRET', 'defaultsecret'))
  end

  def decoded_token
    return unless auth_param

    token = auth_param

    begin
      # TODO: Remove ENV.fetch: replace with more elegant fetch of secret.
      @decoded_token ||= begin
        decoded_token_hash = JWT.decode(token, ENV.fetch('JWT_SIGN_SECRET', 'defaultsecret'), true,
                                        algorithm: 'HS256').first
        # Validate not-expired token
        expire_time = Time.zone.parse decoded_token_hash.fetch('expire')
        return decoded_token_hash if expire_time > Time.zone.now

        # Fallback to nil return (deny-first)
        nil
      end
    rescue JWT::DecodeError
      logger.warn 'Decode Error: Could not decode token.'
      nil
    end
  end

  def current_user
    @current_user ||= if decoded_token
                        user_id = decoded_token['id']
                        user = User.find_by(id: user_id)

                        if user.nil?
                          # This should ideally never happen (but did happen during testing, deleted without invalidating)
                          logger.warn "Valid token with missing User:#{user_id}."
                          logger.warn "This could signify someone signing tokens with the same secret --\
                            \n or the user has been deleted and a token was still active."

                          return nil
                        end

                        user
                      end
  end

  def logged_in?
    !!current_user
  end

  def ensure_authorized
    # Do nothing if the user is logged in.
    return if logged_in?

    add_error(401, 'Please log in.')
    render_response(:unauthorized)
  end
end
