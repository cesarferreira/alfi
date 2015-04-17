require 'spec_helper'

describe Alfi do

  it 'Test the query_url' do
    str = Alfi::SearchModel.query_url('picasso')
    expect(str).to eq 'http://search.maven.org/solrsearch/select?q=picasso&rows=350&wt=json'
  end

  it 'Request the webservice MOCK' do
    str = Alfi::SearchModel.query_url("quickutils")
    expect(str).to eq 'http://search.maven.org/solrsearch/select?q=quickutils&rows=350&wt=json'
  end

  context 'suggestions' do

    it 'should return 0 suggestions' do
      VCR.use_cassette('search_active_android_with_no_suggestions') do
        num_results, results, suggestions = Alfi::SearchModel.fetch_results('active-android')

        expect(suggestions).to be_nil
      end
    end

    it 'should return suggestions' do
      VCR.use_cassette('search_picassoa_with_suggestions') do
        num_results, results, suggestions = Alfi::SearchModel.fetch_results('picassoa')

        expect(suggestions.length).to be > 0
      end
    end

  end

end
