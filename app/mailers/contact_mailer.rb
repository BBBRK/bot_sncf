class ContactMailer < ApplicationMailer

    def train_amiens_ok

        mail(to: 'adresseadechet0212@gmail.com', subject:'Train de 16h46')
    end

    def train_amiens_delayed

        mail(to: 'adresseadechet0212@gmail.com', subject:'Train de 16h46')
    end

    def train_amiens_deleted

        mail(to: 'adresseadechet0212@gmail.com',
             subject:'Train de 16h46',
             from: 'jimmy.bbbrk@gmail.com',
             track_opens: 'true')
    end

end
