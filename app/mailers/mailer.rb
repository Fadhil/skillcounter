class Mailer < ActionMailer::Base
  default :from => 'skillcounter@codemalaysia.com'

  # send a signup email to the vet, pass in the vet object that   contains the vets's email address
  def send_email(vet)
    @vet = vet
    mail( :to => @vet.email,
    :subject => "Welcome #{vet.name}")
  end

   def send_welcome_email(vet, generated_password)
    @vet = vet
    @generated_password = generated_password
    mail( :to => @vet.email,
    :subject => "Succcessfully registered!")
  end

  def organizer_welcome_email(organizer)
    @organizer = organizer
    mail( to: @organizer.email, subject: "Welcome to our platform!")
  end
end
