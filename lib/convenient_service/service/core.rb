# frozen_string_literal: true

module ConvenientService
  module Service
    module Core
      include Support::Concern

      included do
        include ::ConvenientService::Core
      end
    end
  end
end
