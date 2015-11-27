class Alfi::Providers::Bintray < Alfi::Providers::Base
  PROVIDERS_TEXTS = {
    'maven' => 'mavenCentral()',
    'jcenter' => 'jcenter()'
  }
  ALFI_BINTRAY_CREDS = [
    {
      user_name: 'alfi',
      api_key: '5bfa2bedc8d2f5abb8a3fdff49a8599d6ebe7bef'
    },
    {
      user_name: 'alfi2',
      api_key: '98ebb0e5c0fb45c03a1d747da5532b294e01f77e'
    },
    {
      user_name: 'alfi3',
      api_key: 'd506539a493ede165e6497269bea4b0f822fdb6a'
    },
    {
      user_name: 'alfi4',
      api_key: '3da11d361aa52d5d46ee5fd320838f7a5592d9e1'
    }
  ]

  def query_url(query)
    "https://api.bintray.com/search/packages?name=#{query}"
  end

  def request_extensions
    unless $bintray_auth
      add_to_list "  # Bintray using random credentials".yellow
      $bintray_auth = ALFI_BINTRAY_CREDS.sample
    end
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
