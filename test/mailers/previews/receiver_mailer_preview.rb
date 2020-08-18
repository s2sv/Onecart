# Preview all emails at http://localhost:3000/rails/mailers/receiver_mailer
class ReceiverMailerPreview < ActionMailer::Preview
    def receiver_email
        ReceiverMailer.with(user: User.first).receiver_email
      end
end
