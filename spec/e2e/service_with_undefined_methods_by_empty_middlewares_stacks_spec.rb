# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Service with undefined methods by empty middlewares stacks", type: [:standard, :e2e] do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config

      def method_defined_before_middlewares_stack_configuration
        "method_defined_before_middlewares_stack_configuration"
      end

      middlewares :method_defined_before_middlewares_stack_configuration do
      end

      middlewares :method_defined_before_middlewares_stack_configuration do
      end

      def method_defined_after_middlewares_stack_configuration
        "method_defined_after_middlewares_stack_configuration"
      end
    end
  end

  example_group "Service" do
    example_group "class methods" do
      describe ".middlewares" do
        context "when `name` is `:method_defined_before_middlewares_stack_configuration`" do
          it "returns NO middlewares" do
            expect(service_class.middlewares(:method_defined_before_middlewares_stack_configuration).none?).to eq(true)
          end

          specify do
            expect { service_class.middlewares(:method_defined_before_middlewares_stack_configuration) }.not_to cache_its_value
          end
        end

        context "when `name` is `:method_defined_after_middlewares_stack_configuration`" do
          it "returns NO middlewares" do
            expect(service_class.middlewares(:method_defined_after_middlewares_stack_configuration).none?).to eq(true)
          end

          specify do
            expect { service_class.middlewares(:method_defined_after_middlewares_stack_configuration) }.not_to cache_its_value
          end
        end
      end
    end

    example_group "instance methods" do
      let(:service) { service_class.new }

      describe "#method_defined_before_middlewares_stack_configuration" do
        it "is NOT undefined" do
          expect(service.method_defined_before_middlewares_stack_configuration).to eq("method_defined_before_middlewares_stack_configuration")
        end
      end

      describe "#method_defined_after_middlewares_stack_configuration" do
        it "is NOT undefined" do
          expect(service.method_defined_after_middlewares_stack_configuration).to eq("method_defined_after_middlewares_stack_configuration")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
