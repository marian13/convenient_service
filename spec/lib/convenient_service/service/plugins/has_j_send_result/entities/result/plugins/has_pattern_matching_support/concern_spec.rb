# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasPatternMatchingSupport::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end

    example_group "instance methods" do
      describe "#deconstruct" do
        let(:service_instance) { service_class.new }
        let(:service) { service_instance }
        let(:result) { service_instance.result }

        context "when result has success status" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(data: {foo: :bar})
              end
            end
          end

          it "returns array with status and data" do
            expect(result.deconstruct).to eq([:success, {foo: :bar}])
          end

          specify do
            expect { result.deconstruct }
              .to delegate_to(result.status, :to_sym)
          end

          specify do
            expect { result.deconstruct }
              .to delegate_to(result.unsafe_data, :to_h)
          end

          it "does NOT mutably check result status" do
            expect { result.deconstruct }.not_to change(result.status, :checked?).from(false)
          end
        end

        context "when result has failure status" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(message: "foo")
              end
            end
          end

          it "returns array with status and message" do
            expect(result.deconstruct).to eq([:failure, "foo"])
          end

          specify do
            expect { result.deconstruct }
              .to delegate_to(result.status, :to_sym)
          end

          specify do
            expect { result.deconstruct }
              .to delegate_to(result.unsafe_message, :to_s)
          end

          it "does NOT mutably check result status" do
            expect { result.deconstruct }.not_to change(result.status, :checked?).from(false)
          end
        end

        context "when result has error status" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(message: "foo")
              end
            end
          end

          it "returns array with status and message" do
            expect(result.deconstruct).to eq([:error, "foo"])
          end

          specify do
            expect { result.deconstruct }
              .to delegate_to(result.status, :to_sym)
          end

          specify do
            expect { result.deconstruct }
              .to delegate_to(result.unsafe_message, :to_s)
          end

          it "does NOT mutably check result status" do
            expect { result.deconstruct }.not_to change(result.status, :checked?).from(false)
          end
        end
      end

      describe "#deconstruct_keys" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(data: {foo: :bar}, message: "foo", code: :foo)
            end
          end
        end

        let(:service_instance) { service_class.new }
        let(:service) { service_instance }
        let(:result) { service_instance.result }

        context "when `keys` is NOT `nil`" do
          context "when `keys` is array with one key" do
            context "when `keys` is array with `:status` key" do
              let(:values) { {status: :success} }

              it "returns hash with only `:status` key" do
                expect(result.deconstruct_keys([:status])).to eq(values)
              end

              specify do
                expect { result.deconstruct_keys([:status]) }
                  .to delegate_to(result.status, :to_sym)
              end
            end

            context "when `keys` is array with `:data` key" do
              let(:values) { {data: {foo: :bar}} }

              it "returns hash with only `:data` key" do
                expect(result.deconstruct_keys([:data])).to eq(values)
              end

              specify do
                expect { result.deconstruct_keys([:data]) }
                  .to delegate_to(result.unsafe_data, :to_h)
              end
            end

            context "when `keys` is array with `:message` key" do
              let(:values) { {message: "foo"} }

              it "returns hash with only `:message` key" do
                expect(result.deconstruct_keys([:message])).to eq(values)
              end

              specify do
                expect { result.deconstruct_keys([:message]) }
                  .to delegate_to(result.unsafe_message, :to_s)
              end
            end

            context "when `keys` is array with `:code` key" do
              let(:values) { {code: :foo} }

              it "returns hash with only `:code` key" do
                expect(result.deconstruct_keys([:code])).to eq(values)
              end

              specify do
                expect { result.deconstruct_keys([:code]) }
                  .to delegate_to(result.unsafe_code, :to_sym)
              end
            end

            context "when `keys` is array with `:step` key" do
              context "when result does NOT have step" do
                let(:values) { {step: nil} }

                it "returns hash with only `:step` key" do
                  expect(result.deconstruct_keys([:step])).to eq(values)
                end

                specify do
                  expect { result.deconstruct_keys([:step]) }
                    .to delegate_to(result, :step)
                end
              end

              context "when result has step" do
                context "when result has method step" do
                  let(:service_class) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      step :first_step

                      def first_step
                        success(data: {foo: :bar}, message: "foo", code: :foo)
                      end
                    end
                  end

                  let(:values) { {step: :first_step} }

                  it "returns hash with only `:step` key" do
                    expect(result.deconstruct_keys([:step])).to eq(values)
                  end

                  specify do
                    expect { result.deconstruct_keys([:step]) }
                      .to delegate_to(result.step, :action)
                  end
                end

                context "when result has service step" do
                  let(:first_step) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        success(data: {foo: :bar}, message: "foo", code: :foo)
                      end
                    end
                  end

                  let(:service_class) do
                    Class.new.tap do |klass|
                      klass.class_exec(first_step) do |first_step|
                        include ConvenientService::Standard::Config

                        step first_step
                      end
                    end
                  end

                  let(:values) { {step: service.steps[0].service_result.service} }

                  it "returns hash with only `:step` key" do
                    expect(result.deconstruct_keys([:step])).to eq(values)
                  end

                  specify do
                    expect { result.deconstruct_keys([:step]) }
                      .to delegate_to(result.step, :action)
                  end
                end
              end
            end

            context "when `keys` is array with `:step_index` key" do
              context "when result does NOT have step" do
                let(:values) { {step_index: nil} }

                it "returns hash with only `:step_index` key" do
                  expect(result.deconstruct_keys([:step_index])).to eq(values)
                end

                specify do
                  expect { result.deconstruct_keys([:step_index]) }
                    .to delegate_to(result, :step)
                end
              end

              context "when result has step" do
                let(:service_class) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    step :first_step

                    def first_step
                      success(data: {foo: :bar}, message: "foo", code: :foo)
                    end
                  end
                end

                let(:values) { {step_index: 0} }

                it "returns hash with only `:step_index` key" do
                  expect(result.deconstruct_keys([:step_index])).to eq(values)
                end

                specify do
                  expect { result.deconstruct_keys([:step_index]) }
                    .to delegate_to(result.step, :index)
                end
              end
            end

            context "when `keys` is array with `:service` key" do
              let(:values) { {service: service} }

              it "returns hash with only `:service` key" do
                expect(result.deconstruct_keys([:service])).to eq(values)
              end

              specify do
                expect { result.deconstruct_keys([:service]) }
                  .to delegate_to(result, :service)
              end

              specify do
                expect { result.deconstruct_keys([:service]) }
                  .not_to delegate_to(result.service, :class)
              end
            end

            context "when `keys` is array with `:original_service` key" do
              context "when result does NOT have step" do
                let(:values) { {original_service: service} }

                it "returns hash with only `:original_service` key" do
                  expect(result.deconstruct_keys([:original_service])).to eq(values)
                end

                specify do
                  expect { result.deconstruct_keys([:original_service]) }
                    .to delegate_to(result, :original_service)
                end

                specify do
                  expect { result.deconstruct_keys([:original_service]) }
                    .not_to delegate_to(result.original_service, :class)
                end
              end

              context "when result has step" do
                context "when result has method step" do
                  let(:service_class) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      step :first_step

                      def first_step
                        success(data: {foo: :bar}, message: "foo", code: :foo)
                      end
                    end
                  end

                  let(:values) { {original_service: service} }

                  it "returns hash with only `:original_service` key" do
                    expect(result.deconstruct_keys([:original_service])).to eq(values)
                  end

                  specify do
                    expect { result.deconstruct_keys([:original_service]) }
                      .to delegate_to(result, :original_service)
                  end

                  specify do
                    expect { result.deconstruct_keys([:original_service]) }
                      .not_to delegate_to(result.original_service, :class)
                  end
                end

                context "when result has service step" do
                  let(:first_step) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        success(data: {foo: :bar}, message: "foo", code: :foo)
                      end
                    end
                  end

                  let(:service_class) do
                    Class.new.tap do |klass|
                      klass.class_exec(first_step) do |first_step|
                        include ConvenientService::Standard::Config

                        step first_step
                      end
                    end
                  end

                  let(:values) { {original_service: service.steps[0].service_result.service} }

                  it "returns hash with only `:original_service` key" do
                    expect(result.deconstruct_keys([:original_service])).to eq(values)
                  end

                  specify do
                    expect { result.deconstruct_keys([:original_service]) }
                      .to delegate_to(result, :original_service)
                  end

                  specify do
                    expect { result.deconstruct_keys([:original_service]) }
                      .not_to delegate_to(result.original_service, :class)
                  end
                end
              end
            end
          end

          context "when `keys` is array with multiple keys" do
            # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
            it "returns hash with only those multiple keys" do
              expect(result.deconstruct_keys([:status, :data])).to eq({status: :success, data: {foo: :bar}})
              expect(result.deconstruct_keys([:message, :code])).to eq({message: "foo", code: :foo})
              expect(result.deconstruct_keys([:step, :step_index])).to eq({step: nil, step_index: nil})
              expect(result.deconstruct_keys([:service, :original_service])).to eq({service: service, original_service: service})
            end
            # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
          end

          context "when `keys` is array with unsupported key" do
            it "returns empty hash" do
              expect(result.deconstruct_keys([:unsupported])).to eq({})
            end
          end
        end

        context "when `keys` is `nil`" do
          context "when result does NOT have step" do
            let(:values) do
              {
                status: :success,
                data: {foo: :bar},
                message: "foo",
                code: :foo,
                step: nil,
                step_index: nil,
                service: service,
                original_service: service
              }
            end

            it "returns hash with all possible keys" do
              expect(result.deconstruct_keys(nil)).to eq(values)
            end
          end

          context "when result has step" do
            context "when result has method step" do
              let(:service_class) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :first_step

                  def first_step
                    success(data: {foo: :bar}, message: "foo", code: :foo)
                  end
                end
              end

              let(:values) do
                {
                  status: :success,
                  data: {foo: :bar},
                  message: "foo",
                  code: :foo,
                  step: :first_step,
                  step_index: 0,
                  service: service,
                  original_service: service
                }
              end

              it "returns hash with all possible keys" do
                expect(result.deconstruct_keys(nil)).to eq(values)
              end
            end

            context "when result has service step" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {foo: :bar}, message: "foo", code: :foo)
                  end
                end
              end

              let(:service_class) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step) do |first_step|
                    include ConvenientService::Standard::Config

                    step first_step
                  end
                end
              end

              let(:values) do
                {
                  status: :success,
                  data: {foo: :bar},
                  message: "foo",
                  code: :foo,
                  step: service.steps[0].service_result.service,
                  step_index: 0,
                  service: service,
                  original_service: service.steps[0].service_result.service
                }
              end

              it "returns hash with all possible keys" do
                expect(result.deconstruct_keys(nil)).to eq(values)
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
