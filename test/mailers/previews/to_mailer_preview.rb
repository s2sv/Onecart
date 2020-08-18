# Preview all emails at http://localhost:3000/rails/mailers/to_mailer
class ToMailerPreview < ActionMailer::Preview
    def totracking_email
        ToMailer.with(user: User.first).totracking_email
      end
end
