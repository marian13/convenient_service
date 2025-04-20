# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Steps with special characters", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::Results

  example_group "Service" do
    example_group "instance methods" do
      describe "#result" do
        context "when service has step that reassigns output of other step" do
          let(:service_instance) { service_class.new(out: out) }

          let(:out) { Tempfile.new }

          let(:actual_output) { out.tap(&:rewind).read }

          context "when called before original output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  out.puts(foo)

                  success(foo: :first_step_foo)
                end

                def second_step
                  success(foo: :second_step_foo)
                end

                def third_step
                  success(foo: :third_step_foo)
                end
              end
            end

            it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted`" do
              expect { service_instance.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted)
            end
          end

          context "when called after original output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  success(foo: :first_step_foo)
                end

                def second_step
                  out.puts(foo)

                  success(foo: :second_step_foo)
                end

                def third_step
                  success(foo: :third_step_foo)
                end
              end
            end

            let(:expected_output) do
              <<~TEXT
                first_step_foo
              TEXT
            end

            it "returns that original output value" do
              service_instance.result

              expect(actual_output).to eq(expected_output)
            end
          end

          context "when called after first reassigned output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  success(foo: :first_step_foo)
                end

                def second_step
                  success(foo: :second_step_foo)
                end

                def third_step
                  out.puts(foo)

                  success(foo: :third_step_foo)
                end
              end
            end

            let(:expected_output) do
              <<~TEXT
                second_step_foo
              TEXT
            end

            it "returns that first reassigned output value" do
              service_instance.result

              expect(actual_output).to eq(expected_output)
            end
          end

          context "when called after last reassigned output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  success(foo: :first_step_foo)
                end

                def second_step
                  success(foo: :second_step_foo)
                end

                def third_step
                  success(foo: :third_step_foo)
                end
              end
            end

            it "returns that last reassigned output value" do
              expect(service_instance.result.unsafe_data[:foo]).to eq(:third_step_foo)
            end
          end
        end

        context "when service has step that reassigns public method" do
          let(:service_instance) { service_class.new(out: out) }

          let(:out) { Tempfile.new }

          let(:actual_output) { out.tap(&:rewind).read }

          context "when called before original output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  out.puts(foo)

                  success(foo: :first_step_foo)
                end

                def second_step
                  success(foo: :second_step_foo)
                end

                def third_step
                  success(foo: :third_step_foo)
                end

                def foo
                  :method_foo
                end
              end
            end

            let(:expected_output) do
              <<~TEXT
                method_foo
              TEXT
            end

            it "returns that original output value" do
              service_instance.result

              expect(actual_output).to eq(expected_output)
            end
          end

          context "when called after original output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  success(foo: :first_step_foo)
                end

                def second_step
                  out.puts(foo)

                  success(foo: :second_step_foo)
                end

                def third_step
                  success(foo: :third_step_foo)
                end

                def foo
                  :method_foo
                end
              end
            end

            let(:expected_output) do
              <<~TEXT
                first_step_foo
              TEXT
            end

            it "returns that original output value" do
              service_instance.result

              expect(actual_output).to eq(expected_output)
            end
          end

          context "when called after first reassigned output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  success(foo: :first_step_foo)
                end

                def second_step
                  success(foo: :second_step_foo)
                end

                def third_step
                  out.puts(foo)

                  success(foo: :third_step_foo)
                end

                def foo
                  :method_foo
                end
              end
            end

            let(:expected_output) do
              <<~TEXT
                second_step_foo
              TEXT
            end

            it "returns that first reassigned output value" do
              service_instance.result

              expect(actual_output).to eq(expected_output)
            end
          end

          context "when called after last reassigned output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  success(foo: :first_step_foo)
                end

                def second_step
                  success(foo: :second_step_foo)
                end

                def third_step
                  success(foo: :third_step_foo)
                end

                def foo
                  :method_foo
                end
              end
            end

            it "returns that last reassigned output value" do
              expect(service_instance.result.unsafe_data[:foo]).to eq(:third_step_foo)
            end
          end
        end

        context "when service has step that reassigns protected method" do
          let(:service_instance) { service_class.new(out: out) }

          let(:out) { Tempfile.new }

          let(:actual_output) { out.tap(&:rewind).read }

          context "when called before original output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  out.puts(foo)

                  success(foo: :first_step_foo)
                end

                def second_step
                  success(foo: :second_step_foo)
                end

                def third_step
                  success(foo: :third_step_foo)
                end

                protected

                def foo
                  :method_foo
                end
              end
            end

            let(:expected_output) do
              <<~TEXT
                method_foo
              TEXT
            end

            it "returns that original output value" do
              service_instance.result

              expect(actual_output).to eq(expected_output)
            end
          end

          context "when called after original output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  success(foo: :first_step_foo)
                end

                def second_step
                  out.puts(foo)

                  success(foo: :second_step_foo)
                end

                def third_step
                  success(foo: :third_step_foo)
                end

                protected

                def foo
                  :method_foo
                end
              end
            end

            let(:expected_output) do
              <<~TEXT
                first_step_foo
              TEXT
            end

            it "returns that original output value" do
              service_instance.result

              expect(actual_output).to eq(expected_output)
            end
          end

          context "when called after first reassigned output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  success(foo: :first_step_foo)
                end

                def second_step
                  success(foo: :second_step_foo)
                end

                def third_step
                  out.puts(foo)

                  success(foo: :third_step_foo)
                end

                protected

                def foo
                  :method_foo
                end
              end
            end

            let(:expected_output) do
              <<~TEXT
                second_step_foo
              TEXT
            end

            it "returns that first reassigned output value" do
              service_instance.result

              expect(actual_output).to eq(expected_output)
            end
          end

          context "when called after last reassigned output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  success(foo: :first_step_foo)
                end

                def second_step
                  success(foo: :second_step_foo)
                end

                def third_step
                  success(foo: :third_step_foo)
                end

                protected

                def foo
                  :method_foo
                end
              end
            end

            it "returns that last reassigned output value" do
              expect(service_instance.result.unsafe_data[:foo]).to eq(:third_step_foo)
            end
          end
        end

        context "when service has step that reassigns private method" do
          let(:service_instance) { service_class.new(out: out) }

          let(:out) { Tempfile.new }

          let(:actual_output) { out.tap(&:rewind).read }

          context "when called before original output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  out.puts(foo)

                  success(foo: :first_step_foo)
                end

                def second_step
                  success(foo: :second_step_foo)
                end

                def third_step
                  success(foo: :third_step_foo)
                end

                private

                def foo
                  :method_foo
                end
              end
            end

            let(:expected_output) do
              <<~TEXT
                method_foo
              TEXT
            end

            it "returns that original output value" do
              service_instance.result

              expect(actual_output).to eq(expected_output)
            end
          end

          context "when called after original output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  success(foo: :first_step_foo)
                end

                def second_step
                  out.puts(foo)

                  success(foo: :second_step_foo)
                end

                def third_step
                  success(foo: :third_step_foo)
                end

                private

                def foo
                  :method_foo
                end
              end
            end

            let(:expected_output) do
              <<~TEXT
                first_step_foo
              TEXT
            end

            it "returns that original output value" do
              service_instance.result

              expect(actual_output).to eq(expected_output)
            end
          end

          context "when called after first reassigned output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  success(foo: :first_step_foo)
                end

                def second_step
                  success(foo: :second_step_foo)
                end

                def third_step
                  out.puts(foo)

                  success(foo: :third_step_foo)
                end

                private

                def foo
                  :method_foo
                end
              end
            end

            let(:expected_output) do
              <<~TEXT
                second_step_foo
              TEXT
            end

            it "returns that first reassigned output value" do
              service_instance.result

              expect(actual_output).to eq(expected_output)
            end
          end

          context "when called after last reassigned output is executed" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                attr_reader :out

                step :first_step,
                  out: :foo

                step :second_step,
                  out: :foo

                step :third_step,
                  out: :foo

                def initialize(out:)
                  @out = out
                end

                def first_step
                  success(foo: :first_step_foo)
                end

                def second_step
                  success(foo: :second_step_foo)
                end

                def third_step
                  success(foo: :third_step_foo)
                end

                private

                def foo
                  :method_foo
                end
              end
            end

            it "returns that last reassigned output value" do
              expect(service_instance.result.unsafe_data[:foo]).to eq(:third_step_foo)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
