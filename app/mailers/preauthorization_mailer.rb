class PreauthorizationMailer < ApplicationMailer
  default :from => "admin@tocacares.com"

  def send_preauthorization_email(authorization)
    @authorization = authorization
    mail( :to => @authorization.email,
    :subject => 'Setting Up Your TOCA Cares Account' )
  end

end
