# frozen_string_literal: true

module ConvenientService
  module Configs
    module Custom
      include Support::Concern

      included do
        include Core
      end
    end
  end
end
