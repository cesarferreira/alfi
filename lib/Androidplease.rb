require 'AndroidPlease/version'
require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'colorize'

module AndroidPlease

  class SearchModel

    def self.query_url (query)
      "http://search.maven.org/solrsearch/select?q=#{query}&rows=350&wt=json"
    end

    def self.fetch_results(query)
      uri = URI.parse(query_url(query))


      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)

      if response.code == '200'
        result = JSON.parse(response.body)

        num_results = result['response']['numFound']

        result_list = Array.new #=> []


        result['response']['docs'].each do |doc|
          output = "compile '#{doc['id']}:#{doc['latestVersion']}'"
          result_list.push(output)
        end

        return num_results, result_list
      else
        puts 'ERROR!!!'.red
      end
    end

    def self.query_offline_reps(query)

    end


    def self.initialize (param)

      puts param?.lenght

      if param == nil
        puts 'Missing query parameter'.red
      else
        num_results, result_list = fetch_results(param)

        puts "Found: #{num_results} results for '#{param}'"

        result_list.each do |result|
          puts result.green
        end

        # se o resultado for 0 mostrar as sugestoes
        #Did you mean: quick quickr quickvisu quickhull quickgeo ?
        #
        #  compile 'com.android.support:appcompat-v7:21.0.3'
        #  compile 'com.android.support:cardview-v7:21.0.3'
        #  compile 'com.android.support:gridlayout-v7:21.0.3'
        #  compile 'com.android.support:leanback-v17:21.0.3'
        #  compile 'com.android.support:mediarouter-v7:21.0.3'
        #  compile 'com.android.support:palette-v7:21.0.3'
        #  compile 'com.android.support:recyclerview-v7:21.0.3'
        #  compile 'com.android.support:support-annotations:21.0.3'
        #  compile 'com.android.support:support-v13:21.0.3'
        #  compile 'com.android.support:support-v4:21.0.3'

        #com.google.android.gms:play-services-wearable:6.5.87
        #com.google.android.gms:play-services:6.5.87

      end

    end
  end
end
