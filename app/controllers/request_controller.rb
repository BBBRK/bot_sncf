class RequestController < ApplicationController

    def get_train

        # render plain: 'TESTTTTT'
        #
        #
        #
        # # response = RestClient.get 'https://api.sncf.com/v1/coverage/sncf/journeys?to=stop_area%3AOCE%3ASA%3A87313874&from=admin%3Afr%3A2691&datetime_represents=departure&datetime=20200219T071600&'
        # api_result = RestClient::Request.execute(method: :get,
        #                                                   url: "https://api.sncf.com/v1/coverage/sncf/journeys?to=stop_area%3AOCE%3ASA%3A87313874&from=admin%3Afr%3A2691&datetime_represents=departure&datetime=20200219T071600&",
        #                                                   headers: {params: {
        #                                                      #:phrase => phrase,
        #                                                    # :start_date => start_date,
        #                                                    # :end_date => end_date,
        #                                                    # :page => 0,
        #                                                    :apikey => ENV['SNCF']}},
        #                                 timeout: 10)


        response = HTTParty.get("https://api.sncf.com/v1/coverage/sncf/journeys",
            #https://api.sncf.com/v1/coverage/sncf/journeys?to=admin%3Afr%3A2691&from=admin%3Afr%3A80021&datetime_represents=departure&datetime=20200220T164600&disruption_active=true&
            query:{
                to: "admin:fr:2691",
                from: "admin:fr:80021",
                datetime_represents: "departure",
                datetime: "20200218T164600",
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


                amendedArrivalTime = amendedArrivalTime[0...-2].to_i
                baseArrivalTime = baseArrivalTime[0...-2].to_i

                puts amendedArrivalTime
                # puts baseArrivalTime[0...-2]

                # delay = amendedArrivalTime - baseArrivalTime

                # puts delay
                # p test.is_a?(String)
                #
                # test.to_i
                #
                # p test.is_a?(Integer)


            else
                puts "train ok"
            end

            if response["disruptions"][0].present?

                render :json => response["disruptions"][0]

            else

                render :json => response["journeys"][0]

            end


    end
end
