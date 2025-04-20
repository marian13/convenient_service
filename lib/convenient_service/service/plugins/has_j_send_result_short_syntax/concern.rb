# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @internal
            #   NOTE: Delegates to `result` instead of aliasing in order to have an ability
            #   to use the same RSpec stubs for short and usual syntax.
            #
            #   For example:
            #
            #     allow(Service).to receive(:result).with(foo: :bar).and_call_original
            #
            #   works for both `Service.result(foo: :bar)` and `Service[foo: :bar]`.
            #
            def [](...)
              result(...)
            end
          end
        end
      end
    end
  end
end
