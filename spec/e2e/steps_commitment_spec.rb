# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Steps commitment", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::Results

  example_group "Service" do
    example_group "class methods" do
      describe "#new" do
        context "when service steps are NOT committed" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :first_step,
                out: :foo

              def first_step
                success(foo: "foo from first step")
              end
            end
          end

          it "commits those service steps" do
            expect { service.new }.to change(service.steps, :committed?).from(false).to(true)
          end

          it "freezes those service steps" do
            expect { service.new }.to change(service.steps, :frozen?).from(false).to(true)
          end

          it "defines those service steps outputs" do
            expect { service.new }.to change { service.instance_methods.include?(:foo) }.from(false).to(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
