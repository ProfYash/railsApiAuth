# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resourse, options = {})
    puts "resourse111111111111111111111111111111111111111111111111RegistrationsController11111111111111111"
    puts resourse.inspect
    puts resourse
    if resourse.persisted?
      render json: {
        status: { code: 200, message: "SignUp Done", data: resourse },
      }, status: :accepted
    else
      render json: {
        status: { code: 400, message: "SignUp Invalid", errors: resourse.errors.full_messages },
      }, status: :unprocessable_entity
    end
  end
end
