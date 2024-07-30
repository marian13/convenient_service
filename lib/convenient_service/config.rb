# frozen_string_literal: true

module ConvenientService
  module Config
    def self.included(klass)
      klass.extend Dependencies::Extractions::ActiveSupportConcern::Concern
    end
  end
end
