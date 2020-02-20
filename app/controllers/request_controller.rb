class RequestController < ApplicationController

    def get_train

        t = Time.now

        puts t

        puts t.day
        puts t.year
        puts t.month



        response = HTTParty.get("https://api.sncf.com/v1/coverage/sncf/journeys",
            query:{
                to: "admin:fr:2691", #saint-quentin
                from: "admin:fr:80021", #amiens
                datetime_represents: "departure",
                datetime: "20200212T164600",
                disruption_active: "true",
                data_freshness: "realtime"

                },
            headers:{
                "Authorization" => ENV["SNCF"]
                }
            )


            isDisruption = response["disruptions"].present?

            if isDisruption == true

                puts "train en retard"

                cause = response["disruptions"][0]["messages"].first['text']

                puts "cause du retard : #{cause}"


                amendedArrivalTime = response["disruptions"][0]["impacted_objects"].first["impacted_stops"].last["amended_arrival_time"]
                baseArrivalTime = response["disruptions"][0]["impacted_objects"].first["impacted_stops"].last["base_arrival_time"]


                #isolate hours
                amendedArrivalTimeHours = amendedArrivalTime[0...2].to_i
                baseArrivalTimeHours = baseArrivalTime[0...2].to_i

                #isolate minutes
                amendedArrivalTimeMinutes = amendedArrivalTime[2...-2].to_i
                baseArrivalTimeMinutes = baseArrivalTime[2...-2].to_i


                now = DateTime.now
                amendedArrival = Time.new(now.year, now.month, now.day, amendedArrivalTimeHours, amendedArrivalTimeMinutes, 0)
                baseArrival = Time.new(now.year, now.month, now.day, baseArrivalTimeHours, baseArrivalTimeMinutes, 0)

                # calc final delay in minutes
                delayInMinutes = (amendedArrival - baseArrival)/60


                puts "Le train aura #{delayInMinutes} minutes de retard"

                # MAIL retard

            end

            if isDisruption == false

                response2 = HTTParty.get("https://api.sncf.com/v1/coverage/sncf/journeys",
                    query:{
                        to: "admin:fr:2691", #saint-quentin
                        from: "admin:fr:80021", #amiens
                        datetime_represents: "departure",
                        datetime: "20200212T164600",
                        disruption_active: "true",
                        data_freshness: "base_schedule"

                        },
                    headers:{
                        "Authorization" => ENV["SNCF"]
                        }
                    )

                    isDisruption2 = response2["disruptions"].present?

                    puts isDisruption2



                    if isDisruption2 == true

                        puts response2["disruptions"][0]["severity"]["effect"]

                        if response2["disruptions"][0]["severity"]["effect"] === "NO_SERVICE"
                            isDeleted = true
                        else
                            isDeleted = false
                        end

                        if isDeleted == true
                            ContactMailer.train_amiens_deleted().deliver_now

                        else
                            puts "traino k"

                        end
                    end


                    render :json => response2["disruptions"][0]

            end






            #
            # if response["disruptions"][0].present?
            #
            #     render :json => response["disruptions"][0]
            #
            # else
            #
            #     render :json => response["journeys"][0]
            #
            # end


    end
end
