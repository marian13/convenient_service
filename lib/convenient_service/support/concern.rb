# frozen_string_literal: true

module ConvenientService
  module Support
    module Concern
      def self.included(klass)
        klass.extend Dependencies::Extractions::ActiveSupportConcern::Concern
      end
    end
  end
end
