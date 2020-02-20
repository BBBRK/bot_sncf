class ContactMailer < ApplicationMailer

    def train_amiens_ok

        mail(to: 'adresseadechet@gmail.com', subject:'Train de 16h46')
    end

    def train_amiens_delayed

        mail(to: 'adresseadechet@gmail.com', subject:'Train de 16h46')
    end

    def train_amiens_deleted

        mail(to: 'adresseadechet@gmail.com', subject:'Train de 16h46')
    end

end
