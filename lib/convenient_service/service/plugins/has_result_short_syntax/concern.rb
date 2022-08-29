# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultShortSyntax
        module Concern
          include Support::Concern

          class_methods do
            ##
            # NOTE: Delegates to `result' instead of aliasing in order to have an ability
            # to use the same RSpec stubs for short and usual syntax.
            #
            # For example:
            #
            #   allow(Service).to receive(:result).with(foo: :bar)and_call_original
            #
            # works for both `Service.result(foo: :bar)' and `Service[foo: :bar]'.
            #
            def [](**kwargs)
              result(**kwargs)
            end
          end
        end
      end
    end
  end
end
