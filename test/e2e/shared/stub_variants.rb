# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##
module ConvenientService
  module E2E
    module StubVariants
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        ##
        # @return [Enumerator]
        #
        def variants
          ::Thread.current.remove_instance_variable(:@convenient_service_stub_variant_name) if ::Thread.current.instance_variable_defined?(:@convenient_service_stub_variant_name)

          ::Enumerator.new do |collection|
            [
              "stub/unstub",
              "register/unregister",
              # "register with block"
            ].each do |variant_name|
              ::Thread.current.instance_variable_set(:@convenient_service_stub_variant_name, variant_name)

              collection << variant_name
            end
          ensure
            ::Thread.current.remove_instance_variable(:@convenient_service_stub_variant_name)
          end
        end

        ##
        # @param name [String]
        # @param block [Proc]
        # @return [void]
        #
        def variant(name, &block)
          yield if ::Thread.current.instance_variable_get(:@convenient_service_stub_variant_name) == name
        end
      end
    end
  end
end
