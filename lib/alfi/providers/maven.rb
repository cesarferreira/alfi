class Alfi::Providers::Maven < Alfi::Providers::Base
  def query_url(query)
    "http://search.maven.org/solrsearch/select?q=#{query}&rows=350&wt=json"
  end

  def call
    if @search_type.empty? || @search_type.include?('m')
      begin
        response = @http.request(@request)
      rescue SocketError
        puts "Internet Connection not available".red
        exit 1
      end

      if response.code == '200'
        result = JSON.parse(response.body)

        num_results = result['response']['numFound']

        if num_results == 0
          suggestions = (result['spellcheck']['suggestions'].last || {})['suggestion']
          add_suggestions(suggestions) if suggestions
        else
          add_to_list "  # #{'-'*20}Maven.org#{'-'*20}"
          add_to_list '  # mavenCentral()'
        end
        result['response']['docs'].each { |doc| add_repo_to_list "#{doc['id']}:#{doc['latestVersion']}" }
      else
        puts "Error: #{response.code}\n#{response}".red
        exit 1
      end
    end
  end
end
