# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

    def train_amiens_ok

        ContactMailer.train_amiens_ok()

    end

end
