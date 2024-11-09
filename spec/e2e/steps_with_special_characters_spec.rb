# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Steps with special characters", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::Results

  example_group "Service" do
    example_group "class methods" do
      describe ".result" do
        context "when service has step for method that ends with exclamation mark" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo!

              def foo!
                success(from: :method_foo!)
              end
            end
          end

          it "executes that method with exclamation mark" do
            expect(service.result).to be_success.with_data(from: :method_foo!)
          end
        end

        context "when service has step for method that ends with question mark" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo?

              def foo?
                success(from: :method_foo?)
              end
            end
          end

          it "executes that method with question mark" do
            expect(service.result).to be_success.with_data(from: :method_foo?)
          end
        end

        context "when service has step with input that ends with exclamation mark" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :first_step,
                in: :foo!

              def first_step
                success(from: :input_foo!)
              end

              def foo!
                :foo!
              end
            end
          end

          it "executes that input with exclamation mark" do
            expect(service.result).to be_success.with_data(from: :input_foo!)
          end
        end

        context "when service has step with input that ends with question mark" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :first_step,
                in: :foo?

              def first_step
                success(from: :input_foo?)
              end

              def foo?
                :foo?
              end
            end
          end

          it "executes that input with question mark" do
            expect(service.result).to be_success.with_data(from: :input_foo?)
          end
        end

        context "when service has step with output that ends with exclamation mark" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :first_step,
                out: :foo!

              def first_step
                success(foo!: :from_output)
              end
            end
          end

          it "executes that output with exclamation mark" do
            expect(service.result).to be_success.with_data(foo!: :from_output)
          end
        end

        context "when service has step with output that ends with question mark" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :first_step,
                out: :foo?

              def first_step
                success(foo?: :from_output)
              end
            end
          end

          it "executes that output with question mark" do
            expect(service.result).to be_success.with_data(foo?: :from_output)
          end
        end

        context "when service has step with output reassignment that ends with exclamation mark" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :first_step,
                out: :foo!

              step :second_step,
                out: :foo!

              def first_step
                success(foo!: :from_output)
              end

              def second_step
                success(foo!: :from_output_reassignment)
              end
            end
          end

          it "executes that output reassignment with exclamation mark" do
            expect(service.result).to be_success.with_data(foo!: :from_output_reassignment)
          end
        end

        context "when service has step with output reassignment that ends with question mark" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :first_step,
                out: :foo?

              step :second_step,
                out: :foo?

              def first_step
                success(foo?: :from_output)
              end

              def second_step
                success(foo?: :from_output_reassignment)
              end
            end
          end

          it "executes that output reassignment with question mark" do
            expect(service.result).to be_success.with_data(foo?: :from_output_reassignment)
          end
        end

        context "when service has step with method reassignment that ends with exclamation mark" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :first_step,
                out: :foo!

              def first_step
                success(foo!: :from_method_reassignment)
              end

              def foo!
                :foo!
              end
            end
          end

          it "executes that method reassignment with exclamation mark" do
            expect(service.result).to be_success.with_data(foo!: :from_method_reassignment)
          end
        end

        context "when service has step with method reassignment that ends with question mark" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :first_step,
                out: :foo?

              def first_step
                success(foo?: :from_method_reassignment)
              end

              def foo?
                :foo?
              end
            end
          end

          it "executes that method reassignment with question mark" do
            expect(service.result).to be_success.with_data(foo?: :from_method_reassignment)
          end
        end

        ##
        # NOTE: The following case in NOT a valid Ruby syntax.
        #
        # context "when service has step for method that accepts argument that ends with exclamation mark" do
        #   let(:service) do
        #     Class.new do
        #       include ConvenientService::Standard::Config
        #
        #       step :first_step,
        #         in: :foo!
        #
        #       def first_step(foo!:)
        #         success(from: :method_argument_foo!)
        #       end
        #
        #       def foo!
        #         :foo!
        #       end
        #     end
        #   end
        #
        #   it "executes that method that accepts argument with exclamation mark" do
        #     expect(service.result).to be_success.with_data(from: :method_argument_foo!)
        #   end
        # end
        ##

        ##
        # NOTE: The following case in NOT a valid Ruby syntax.
        #
        # context "when service has step for method that accepts argument that ends with question mark" do
        #   let(:service) do
        #     Class.new do
        #       include ConvenientService::Standard::Config
        #
        #       step :first_step,
        #         in: :foo?
        #
        #       def first_step(foo?:)
        #         success(from: :method_argument_foo?)
        #       end
        #
        #       def foo?
        #         :foo?
        #       end
        #     end
        #   end
        #
        #   it "executes that method that accepts argument with question mark" do
        #     expect(service.result).to be_success.with_data(from: :method_argument_foo?)
        #   end
        # end
        ##
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
