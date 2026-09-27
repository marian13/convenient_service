# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass
RSpec.describe "Dynamic skip of Dry Validation", type: [:dry, :e2e] do
  include ConvenientService::RSpec::Matchers::Results

  example_group "Service" do
    example_group "instance methods" do
      describe "#result" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(skip_validations) do |skip_validations|
              include ConvenientService::Standard::Config.with({name: :dry_validation, enabled: true, skip_validations: skip_validations})

              attr_reader :foo, :bar, :baz

              contract do
                params do
                  required(:foo).filled(:string)
                  required(:bar).filled(:string)
                  required(:baz).filled(:string)
                end
              end

              class << self
                def name
                  "Service"
                end
              end

              def initialize(foo:, bar:, baz:)
                @foo = foo
                @bar = bar
                @baz = baz
              end

              def result
                success(foo: foo, bar: bar, baz: baz)
              end
            end
          end
        end

        let(:service_instance) { service_class.new(**kwargs) }
        let(:kwargs) { {foo: "foo", bar: "", baz: "baz"} }

        context "when `skip_validations` option is `false`" do
          let(:skip_validations) { false }

          it "does NOT skip validations" do
            expect(service_instance.result).to be_error.with_message("bar must be filled")
          end
        end

        context "when `skip_validations` option is `true`" do
          let(:skip_validations) { true }

          it "skips validations" do
            expect(service_instance.result).to be_success.with_data(**kwargs)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/DescribeClass
