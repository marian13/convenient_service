# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module E2E
    module Shared
      module StubVariants
        ##
        # @return [Array<String>]
        #
        def available_variant_names
          [
            "stub/unstub",
            "register/unregister",
            "register(&block)"
          ]
        end

        ##
        # @return [Enumerator]
        #
        def variants
          ::Thread.current.remove_instance_variable(:@convenient_service_stub_variant_name) if ::Thread.current.instance_variable_defined?(:@convenient_service_stub_variant_name)

          ::Enumerator.new do |collection|
            available_variant_names.each do |variant_name|
              ::Thread.current.instance_variable_set(:@convenient_service_stub_variant_name, variant_name)

              collection << variant_name
            end
          ensure
            ::Thread.current.remove_instance_variable(:@convenient_service_stub_variant_name)
          end
        end

        ##
        # @param name [String]
        # @param block [Proc, nil]
        # @return [void]
        #
        # @internal
        #   NOTE: Use without block form for debugging, for example:
        #     bb if variant "stub/unstub"
        #     bb if variant "register/unregister"
        #     bb if variant "register(&block)"
        #
        def variant(name, &block)
          current_name = ::Thread.current.instance_variable_get(:@convenient_service_stub_variant_name)

          raise "No current variant name" unless current_name
          raise "Invalid variant name" unless available_variant_names.include?(name)

          if current_name == name
            block ? yield : true
          else
            false
          end
        end

        ##
        # @param callback [Proc, nil]
        # @return [Proc, nil]
        #
        # @internal
        #   NOTE: Minitest does NOT have its own native `around`. This one is created just for the testing (behaviour verification) purposes.
        #
        #   NOTE: Before the custom `around` method introduction, `variant` looked like the following with too many technical details.
        #     variant "register with block" do
        #       def should(name, &block)
        #         decorated_block =
        #           proc do |*args|
        #             @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
        #               instance_exec(*args, &block)
        #             end
        #           end
        #
        #         super(name, &decorated_block)
        #       end
        #     end
        #
        #   NOTE: After the custom `around` method introduction, `variant` looks like the following with almost no technical details.
        #     variant "register with block" do
        #       around do |test|
        #         @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
        #           test.call
        #         end
        #       end
        #     end
        #
        #   NOTE: Or even shorter.
        #     variant "register with block" do
        #       around do |test|
        #         @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register(&test)
        #       end
        #     end
        #
        def around(&callback)
          callback ? @around = callback : @around
        end

        ##
        # @param args [Array<Object>]
        # @param kwargs [Hash{Symbol => Object}]
        # @param block [Proc]
        # @return [void]
        #
        # @internal
        #   NOTE: `around_callback = around` is required for closure, otherwise `decorated_block` has no access to `around_callback`.
        #
        def should(*args, **kwargs, &block)
          around_callback = around

          decorated_block =
            if around_callback
              proc do |*args|
                test = proc { instance_exec(*args, &block) }

                instance_exec(test, &around_callback)
              end
            else
              block
            end

          super(*args, **kwargs, &decorated_block)
        end
      end
    end
  end
end
