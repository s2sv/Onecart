# Preview all emails at http://localhost:3000/rails/mailers/from_mailer
class FromMailerPreview < ActionMailer::Preview
    def fromtracking_email
        FromMailer.with(user: User.first).fromtracking_email
      end
end
