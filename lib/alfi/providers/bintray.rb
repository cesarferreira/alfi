class Alfi::Providers::Bintray < Alfi::Providers::Base
  PROVIDERS_TEXTS = {
    'maven' => 'mavenCentral()',
    'jcenter' => 'jcenter()'
  }
  def query_url(query)
    "https://api.bintray.com/search/packages?name=#{query}"
  end

  def request_extensions
    return add_to_list "  # Bintray isn't authenticated".red unless $bintray_auth
    @http.use_ssl = true
    @request.basic_auth $bintray_auth[:user_name], $bintray_auth[:api_key]
  end

  def call
    begin
      response = @http.request(@request)
    rescue SocketError
      puts "Internet Connection not available".red
      exit 1
    end

    return if response.code != '200'
    response_json = JSON.parse(response.body || '{}')

    add_to_list "  # #{'-'*20}Bintray#{'-'*20}" if response_json.size > 0

    response_json.group_by { |package| package['repo'] }.each do |provider, repositories|
      add_to_list "  # #{PROVIDERS_TEXTS[provider]}"
      repositories.each do |repo|
        add_repo_to_list "#{repo['system_ids'][0]}:#{repo['latest_version']}" if repo['system_ids'].size > 0
      end
    end
  end
end
