namespace :request do
    desc "Sending status of my trains"

    task check_amiens: :environment do
        CheckAmiensJob.perform_now
    end

    task check_Saint_Quentin: :environment do
        CheckSaintQuentinJob.perform_now
    end
end
