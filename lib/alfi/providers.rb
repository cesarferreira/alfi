module Alfi::Providers
  # To get all defined providers
  def self.all
    (Alfi::Providers.constants - [:Base]).map { |class_name| const_get "Alfi::Providers::#{class_name}" }
  end
end
