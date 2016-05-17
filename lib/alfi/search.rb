class Alfi::Search
  def initialize
    $result_list = []
    $suggestions = []
  end

  def exit_with(message)
    puts message
    exit 1
  end

  def call(search_param, searchType)
    return puts 'The search needs 3+ characters'.red if search_param.size < 3
    puts "Searching...\n"

    Alfi::Providers.all.each { |cc| cc.new(search_param, searchType).call }

    exit_with('No results'.red) if $result_list.empty? && $suggestions.empty?
    num_results = $result_list.count { |r| r.strip[0] != '#' }

    if num_results > 0
      puts "\ndependencies {\n"
      $result_list.each { |result| puts result }
      puts "}\n"
    end

    puts "\nFound: #{num_results} result#{num_results > 1?'s':''} for '#{search_param.yellow}'"

    return if $suggestions.empty?
    puts "Did you mean: #{$suggestions.join(', ').yellow}"
  end
end
