class Mailer < ActionMailer::Base
  default :from => 'any_from_address@example.com'

  # send a signup email to the vet, pass in the vet object that   contains the vets's email address
  def send_email(vet)
    @vet = vet
    mail( :to => @vet.email,
    :subject => "Welcome #{vet.name}")
  end

   def send_welcome_email(vet)
    @vet = vet
    mail( :to => @vet.email,
    :subject => "Succcessfully registered!")
  end
end
