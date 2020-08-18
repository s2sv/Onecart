# Preview all emails at http://localhost:3000/rails/mailers/sender_mailer
class SenderMailerPreview < ActionMailer::Preview
    def sender_email
        SenderMailer.with(user: User.first).sender_email
      end
end
