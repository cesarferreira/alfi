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

      begin
        response = http.request(request)
      rescue SocketError
        puts "Internet Connection not available".red
        exit 1
      end


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

        # query google reps
        result_list = query_offline_reps(query)

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

    # QUERY OFFLINE REPOSITORIES (google)
    def self.query_offline_reps(query)

      google_libs = Array.new
      google_libs << 'com.android.support:appcompat-v7'
      google_libs << 'com.android.support:cardview-v7'
      google_libs << 'com.android.support:gridlayout-v7'
      google_libs << 'com.android.support:leanback-v17'
      google_libs << 'com.android.support:mediarouter-v7'
      google_libs << 'com.android.support:palette-v7'
      google_libs << 'com.android.support:recyclerview-v7'
      google_libs << 'com.android.support:support-annotations'
      google_libs << 'com.android.support:support-v4'
      google_libs << 'com.android.support:support-v13'
      google_libs << 'com.google.android.gms:play-services-wearable'
      google_libs << 'com.google.android.gms:play-services'


      found_libs = Array.new

      # is there anything?
      google_libs.each do |lib|

        if lib.include?(query)
          found_libs << "  compile '#{lib}:+'"
        end
      end

      return found_libs

    end

    # INIT
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
