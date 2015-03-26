require 'alfi/version'
require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'colorize'

module Alfi

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

        # Amount of results
        num_results = result['response']['numFound']

        suggestions = nil

        # Possible suggestions
        if num_results==0
          suggestions = result['spellcheck']['suggestions'].last['suggestion']
        end

        # Init the result list
        result_list = Array.new

        # Iterate the libraries
        result['response']['docs'].each do |doc|
          output = "  compile '#{doc['id']}:#{doc['latestVersion']}'"
          result_list << output
        end

        return num_results, result_list, suggestions
      else
        puts 'Unknown ERROR!!!\n(are you even connected to the internet brah?)'.red
      end
    end

    def self.query_offline_reps(query)
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

    def self.initialize (param)

      if param == nil
        puts "Missing query parameter\n\tusage: alfi SEARCH_QUERY\n".red
      else
        if param.size>=3

          puts "Searching..."

          num_results, result_list, suggestions = fetch_results(param)


          # Iterate to print results
          result_list.each do |result|
            puts result.green
          end

          puts "Found: #{num_results} result#{num_results>1?'s':''} for '#{param}'"


          # handle the suggestions
          if suggestions!=nil

            output = ''

            # iterate the suggestions
            suggestions.each do |suggestion|
              output += "#{suggestion} ".yellow
            end
            puts "Did you mean: #{output}"
          end
        else
          puts 'The search needs 3+ characters'.red

        end
      end
    end
  end
end
