class ContactMailer < ApplicationMailer

    def train_amiens_ok

        mail(to: 'jimg@laposte.net', subject:'Train de 16h46')
    end

    def train_amiens_delayed(cause, delay)

        @delay = delay
        @cause = cause
        mail(to: 'jimg@laposte.net', subject:'Train de 16h46')
    end

    def train_amiens_deleted(cause)

        @cause = cause
        mail(to: 'jimg@laposte.net', subject:'Train de 16h46')
    end

    def train_saint_quentin_ok

        mail(to: 'jimg@laposte.net', subject:'Train de 7h16')
    end

    def train_saint_quentin_delayed(cause, delay)

        @delay = delay
        @cause = cause
        mail(to: 'jimg@laposte.net', subject:'Train de 7h16')
    end

    def train_saint_quentin_deleted(cause)

        @cause = cause
        mail(to: 'jimg@laposte.net', subject:'Train de 7h16')
    end

end
