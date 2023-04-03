# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resourse, options = {})
    puts "resourse111111111111111111111111111111111111111111111111SessionsController11111111111111111"
    puts resourse.inspect
    puts resourse
    if resourse.persisted?
      jwt_token = JWT.encode(
        { id: resourse.id, email: resourse.email, jti: resourse.jti },
        Rails.application.credentials.fetch(:secret_key_base)
      )
      puts "jwt_token11111111111111111111111"
      puts jwt_token
      cookies["auth"] = {
        :value => jwt_token,
        :expires => 1.year.from_now,
      # :domain => 'example.com'
      }
      render json: {
        status: { code: 200, message: "SignIn Done", data: current_user },
      }, status: :ok
    else
      render json: {
        status: { code: 400, message: "SignUp Invalid", errors: resourse.errors.full_messages },
      }, status: :unprocessable_entity
    end
  end

  def respond_to_on_destroy()
    cookie_name = "auth"
    # token = request.headers["Authorization"].split(" ")[1]
    token = cookies[cookie_name]
    puts "token11111111111111111111111111111111111111111"
    puts token
    jwt_payload = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base)).first
    puts "jwt_payload11111111111111111111111111111111111111"
    puts jwt_payload
    current_user = User.find(jwt_payload["id"])
    puts "current_user1111111111111111111111111111111111"
    puts current_user.inspect

    if current_user
      cookies.delete cookie_name
      render json: {
        status: { code: 200, message: "Sign OUT Done", data: current_user },
      }, status: :ok
    else
      render json: {
               status: { code: 401, message: "Sign OUT Nahi hua", data: current_user },
             }, status: :unauthorized
    end
  end
end
