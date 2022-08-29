# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CachesConstructorParams
        module Concern
          include Support::Concern

          ##
          # TODO: `internals.cache[:constructor_params] || Entities::NullConstructorParams.new'
          #
          instance_methods do
            def constructor_params
              internals.cache[:constructor_params]
            end
          end
        end
      end
    end
  end
end
