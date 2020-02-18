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
            query:{
                to: "admin:fr:2691",
                from: "admin:fr:80021",
                datetime_represents: "departure",
                datetime: "20200219T174600"

                },
            headers:{
                "Authorization" => ENV["SNCF"]
                }
            )



        render :json => response["journeys"][0]["arrival_date_time"]

        response["journeys"][0]["arrival_date_time"]

        puts response





    end
end
