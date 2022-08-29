# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasConstructor
        module Concern
          include Support::Concern

          instance_methods do
            def initialize(*args, **kwargs, &block)
            end
          end
        end
      end
    end
  end
end
