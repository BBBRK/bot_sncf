class RequestController < ApplicationController

    def get_train_amiens

        test = get_today()
        day = test[0]
        year = test[1]
        month = test[2]



        response = HTTParty.get("https://api.sncf.com/v1/coverage/sncf/journeys",
            query:{
                to: "admin:fr:2691", #saint-quentin
                from: "admin:fr:80021", #amiens
                datetime_represents: "departure",
                datetime: "#{year}#{month}#{day}T164600",
                # datetime: "20200220T164600",
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
                ContactMailer.train_amiens_delayed(cause, delayInMinutes).deliver_now

            end

            if isDisruption == false

                response2 = HTTParty.get("https://api.sncf.com/v1/coverage/sncf/journeys",
                    query:{
                        to: "admin:fr:2691", #saint-quentin
                        from: "admin:fr:80021", #amiens
                        datetime_represents: "departure",
                        datetime: "#{year}#{month}#{day}T164600",
                        # datetime: "20200220T164600",
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
                        cause = response2["disruptions"][0]["messages"].first['text']
                        ContactMailer.train_amiens_deleted(cause).deliver_now
                    end
                else
                    puts "train ok"
                    ContactMailer.train_amiens_ok().deliver_now
                end
                render :json => response2["disruptions"][0]
            end

    end


    def get_train_saint_quentin

        test = get_today()
        day = test[0]
        year = test[1]
        month = test[2]



        response = HTTParty.get("https://api.sncf.com/v1/coverage/sncf/journeys",
            query:{
                to: "admin:fr:80021", #amiens
                from: "admin:fr:2691", #saint-quentin
                datetime_represents: "departure",
                datetime: "#{year}#{month}#{day}T071600",
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

                cause = response["disruptions"][0]["messages"].first['text']
                ContactMailer.train_saint_quentin_delayed(cause, delayInMinutes).deliver_now
            end

            if isDisruption == false

                response2 = HTTParty.get("https://api.sncf.com/v1/coverage/sncf/journeys",
                    query:{
                        to: "admin:fr:80021", #amiens
                        from: "admin:fr:2691", #saint-quentin
                        datetime_represents: "departure",
                        datetime: "#{year}#{month}#{day}T071600",
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
                        cause = response2["disruptions"][0]["messages"].first['text']
                        ContactMailer.train_saint_quentin_deleted(cause).deliver_now
                    else
                        puts "train ok"
                    end
                else

                    ContactMailer.train_saint_quentin_ok().deliver_now
                end
                render :json => response2["disruptions"][0]
            end

    end


private

    def get_today

        t = Time.now

        day = t.day
        year = t.year
        if t.month < 10
            month = t.month
            month = month.to_s
            month = "0" + month
        end

        return day, year, month

    end

end
