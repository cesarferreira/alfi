require 'spec_helper'

describe Alfi do
  it 'Test the query_url' do
    str = Alfi::Providers::Maven.new('picasso', Array.new).query_url('picasso')
    expect(str).to eq 'http://search.maven.org/solrsearch/select?q=picasso&rows=350&wt=json'
  end

  it 'Test search with repository' do
    maven = Alfi::Search.new
    maven.call('sPref', Array.new(1, "maven"))
    expect(maven.total_results).to be >= 1
  end

  context 'suggestions' do
    it 'should return 0 suggestions' do
      VCR.use_cassette('search_active_android_with_no_suggestions') do
        maven_provider = Alfi::Providers::Maven.new('active-android', Array.new)

        expect(maven_provider).to_not receive(:add_suggestions)
        maven_provider.call
      end
    end

    it 'should return suggestions' do
      VCR.use_cassette('search_picassoa_with_suggestions') do
        maven_provider = Alfi::Providers::Maven.new('picassoa', Array.new)

        expect(maven_provider).to receive(:add_suggestions).with(array_including('picasso', 'piccolo'))
        maven_provider.call
      end
    end
  end
end
