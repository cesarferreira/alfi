# require 'alfi/providers/base'
class Alfi::Providers::Offline < Alfi::Providers::Base
  def initialize(query, searchType)
    @query = query
  end

  def call
    google_libs = [
      'com.android.support:appcompat-v7',
      'com.android.support:cardview-v7',
      'com.android.support:gridlayout-v7',
      'com.android.support:leanback-v17',
      'com.android.support:mediarouter-v7',
      'com.android.support:palette-v7',
      'com.android.support:support-annotations',
      'com.android.support:support-v4',
      'com.android.support:support-v13',
      'com.google.android.gms:play-services-wearable',
      'com.google.android.gms:play-services',
      'com.android.support:recyclerview-v7'
    ]
    results = google_libs.map { |lib| "#{lib}:+" if lib.include?(@query) }.compact
    return unless results.size > 0
    add_to_list '  # Google'
    results.each { |library| add_repo_to_list(library) }
  end
end
