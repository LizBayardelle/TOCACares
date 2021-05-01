class PreauthorizationMailer < ApplicationMailer
  default :from => "support@tocacares.com"

  def send_preauthorization_email(authorization)
    @authorization = authorization
    mail( :to => @authorization.email,
    :subject => 'Setting Up Your TOCA Cares Account' )
  end

end
