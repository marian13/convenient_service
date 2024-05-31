# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveRollbacks::Middleware, type: :standard do
  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :result, entity: :service
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware) }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Standard::Config

            middlewares :result do
              use_and_observe middleware
            end

            def result
              success
            end
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify do
        expect { method_value }
          .to call_chain_next.on(method)
          .without_arguments
          .and_return_its_value
      end

      example_group "comprehensive suite" do
        let(:config) do
          Module.new do
            include ConvenientService::Support::Concern

            included do
              include ConvenientService::Standard::Config

              middlewares :result do
                insert_before \
                  ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware,
                  ConvenientService::Service::Plugins::CanHaveRollbacks::Middleware
              end
            end
          end
        end

        let(:result) { service.result }

        let(:out) { Tempfile.new }
        let(:output) { out.tap(&:rewind).read }

        context "when service has NO steps" do
          context "when service result is success" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(config, out) do |config, out|
                  include config

                  define_method(:out) { out }

                  def result
                    success.tap { out.puts "original service success" }
                  end

                  def rollback_result
                    out.puts "original service rollback"
                  end

                  def self.name
                    "OriginalService"
                  end
                end
              end
            end

            let(:text) do
              <<~TEXT
                original service success
              TEXT
            end

            it "returns that success" do
              expect(result).to be_success.without_data.of_service(service).without_step
            end

            it "does NOT trigger service rollback" do
              result

              expect(output).to eq(text)
            end

            context "when service has NO rollback" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "original service success" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  original service success
                TEXT
              end

              it "does NOT trigger service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when service rollback raises exception" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "original service success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  original service success
                TEXT
              end

              it "does NOT trigger service rollback" do
                result

                expect(output).to eq(text)
              end
            end
          end

          context "when service result is failure" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(config, out) do |config, out|
                  include config

                  define_method(:out) { out }

                  def result
                    failure.tap { out.puts "original service failure" }
                  end

                  def rollback_result
                    out.puts "original service rollback"
                  end

                  def self.name
                    "OriginalService"
                  end
                end
              end
            end

            let(:text) do
              <<~TEXT
                original service failure
                original service rollback
              TEXT
            end

            it "returns that failure" do
              expect(result).to be_failure.without_data.of_service(service).without_step
            end

            it "triggers service rollback" do
              result

              expect(output).to eq(text)
            end

            context "when service has NO rollback" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      failure.tap { out.puts "original service failure" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  original service failure
                TEXT
              end

              it "skips service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when service rollback raises exception" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      failure.tap { out.puts "original service failure" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  original service failure
                TEXT
              end

              it "rescues service rollback exception" do
                result

                expect(output).to eq(text)
              end
            end
          end

          context "when service result is error" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(config, out) do |config, out|
                  include config

                  define_method(:out) { out }

                  def result
                    error.tap { out.puts "original service error" }
                  end

                  def rollback_result
                    out.puts "original service rollback"
                  end

                  def self.name
                    "OriginalService"
                  end
                end
              end
            end

            let(:text) do
              <<~TEXT
                original service error
                original service rollback
              TEXT
            end

            it "returns that error" do
              expect(result).to be_error.without_data.of_service(service).without_step
            end

            it "triggers service rollback" do
              result

              expect(output).to eq(text)
            end

            context "when service has NO rollback" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      error.tap { out.puts "original service error" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  original service error
                TEXT
              end

              it "skips service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when service rollback raises exception" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      error.tap { out.puts "original service error" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  original service error
                TEXT
              end

              it "rescues service rollback exception" do
                result

                expect(output).to eq(text)
              end
            end
          end
        end

        context "when service has some service steps" do
          let(:first_step) do
            Class.new.tap do |klass|
              klass.class_exec(config, out) do |config, out|
                include config

                define_method(:out) { out }

                def result
                  success.tap { out.puts "first service step success" }
                end

                def rollback_result
                  out.puts "first service step rollback"
                end

                def self.name
                  "FirstStep"
                end
              end
            end
          end

          context "when service result is success" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(config, out, first_step) do |config, out, first_step|
                  include config

                  step first_step

                  step :result

                  define_method(:out) { out }

                  def result
                    success.tap { out.puts "original service success" }
                  end

                  def rollback_result
                    out.puts "original service rollback"
                  end

                  def self.name
                    "OriginalService"
                  end
                end
              end
            end

            let(:text) do
              <<~TEXT
                first service step success
                original service success
              TEXT
            end

            it "returns that success" do
              expect(result).to be_success.without_data.of_service(service).of_step(:result)
            end

            it "does NOT trigger any rollbacks" do
              result

              expect(output).to eq(text)
            end

            context "when service has NO rollback" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step) do |config, out, first_step|
                    include config

                    step first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "original service success" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step success
                  original service success
                TEXT
              end

              it "does NOT trigger service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when service rollback raises exception" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step) do |config, out, first_step|
                    include config

                    step first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "original service success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step success
                  original service success
                TEXT
              end

              it "does NOT trigger service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when step has NO rollback" do
              let(:first_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "first service step success" }
                    end

                    def self.name
                      "FirstStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step success
                  original service success
                TEXT
              end

              it "does NOT trigger step rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when step rollback raises exception" do
              let(:first_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "first service step success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "FirstStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step success
                  original service success
                TEXT
              end

              it "does NOT trigger step rollback" do
                result

                expect(output).to eq(text)
              end
            end
          end

          context "when service result is failure" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(config, out, first_step) do |config, out, first_step|
                  include config

                  step first_step

                  step :result

                  define_method(:out) { out }

                  def result
                    failure.tap { out.puts "original service failure" }
                  end

                  def rollback_result
                    out.puts "original service rollback"
                  end

                  def self.name
                    "OriginalService"
                  end
                end
              end
            end

            let(:text) do
              <<~TEXT
                first service step success
                original service failure
                original service rollback
                first service step rollback
              TEXT
            end

            it "returns that failure" do
              expect(result).to be_failure.without_data.of_service(service).of_step(:result)
            end

            it "triggers service and steps rollbacks in reverse order" do
              result

              expect(output).to eq(text)
            end

            context "when service has NO rollback" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step) do |config, out, first_step|
                    include config

                    step first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      failure.tap { out.puts "original service failure" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step success
                  original service failure
                  first service step rollback
                TEXT
              end

              it "skips service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when service rollback raises exception" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step) do |config, out, first_step|
                    include config

                    step first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      failure.tap { out.puts "original service failure" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step success
                  original service failure
                  first service step rollback
                TEXT
              end

              it "rescues service rollback exception" do
                result

                expect(output).to eq(text)
              end
            end

            context "when step has NO rollback" do
              let(:first_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "first service step success" }
                    end

                    def self.name
                      "FirstStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step success
                  original service failure
                  original service rollback
                TEXT
              end

              it "skips step rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when step rollback raises exception" do
              let(:first_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "first service step success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "FirstStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step success
                  original service failure
                  original service rollback
                TEXT
              end

              it "rescues service rollback exception" do
                result

                expect(output).to eq(text)
              end
            end
          end

          context "when service result is error" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(config, out, first_step) do |config, out, first_step|
                  include config

                  step first_step

                  step :result

                  define_method(:out) { out }

                  def result
                    error.tap { out.puts "original service error" }
                  end

                  def rollback_result
                    out.puts "original service rollback"
                  end

                  def self.name
                    "OriginalService"
                  end
                end
              end
            end

            let(:text) do
              <<~TEXT
                first service step success
                original service error
                original service rollback
                first service step rollback
              TEXT
            end

            it "returns that error" do
              expect(result).to be_error.without_data.of_service(service).of_step(:result)
            end

            it "triggers service and steps rollbacks in reverse order" do
              result

              expect(output).to eq(text)
            end

            context "when service has NO rollback" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step) do |config, out, first_step|
                    include config

                    step first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      error.tap { out.puts "original service error" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step success
                  original service error
                  first service step rollback
                TEXT
              end

              it "skips service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when service rollback raises exception" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step) do |config, out, first_step|
                    include config

                    step first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      error.tap { out.puts "original service error" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step success
                  original service error
                  first service step rollback
                TEXT
              end

              it "rescues service rollback exception" do
                result

                expect(output).to eq(text)
              end
            end

            context "when step has NO rollback" do
              let(:first_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "first service step success" }
                    end

                    def self.name
                      "FirstStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step success
                  original service error
                  original service rollback
                TEXT
              end

              it "skips step rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when step rollback raises exception" do
              let(:first_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "first service step success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "FirstStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step success
                  original service error
                  original service rollback
                TEXT
              end

              it "rescues service rollback exception" do
                result

                expect(output).to eq(text)
              end
            end
          end
        end

        context "when service has nested steps" do
          let(:first_step_nested_step) do
            Class.new.tap do |klass|
              klass.class_exec(config, out) do |config, out|
                include config

                define_method(:out) { out }

                def result
                  success.tap { out.puts "first service step nested service step success" }
                end

                def rollback_result
                  out.puts "first service step nested service step rollback"
                end

                def self.name
                  "FirstStep::NestedStep"
                end
              end
            end
          end

          let(:first_step) do
            Class.new.tap do |klass|
              klass.class_exec(config, out, first_step_nested_step) do |config, out, first_step_nested_step|
                include config

                define_method(:out) { out }

                step first_step_nested_step

                step :result

                def result
                  success.tap { out.puts "first step success" }
                end

                def rollback_result
                  out.puts "first step rollback"
                end

                def self.name
                  "FirstStep"
                end
              end
            end
          end

          context "when service result is success" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(config, out, first_step) do |config, out, first_step|
                  include config

                  step first_step

                  step :result

                  define_method(:out) { out }

                  def result
                    success.tap { out.puts "original service success" }
                  end

                  def rollback_result
                    out.puts "original service rollback"
                  end

                  def self.name
                    "OriginalService"
                  end
                end
              end
            end

            let(:text) do
              <<~TEXT
                first service step nested service step success
                first step success
                original service success
              TEXT
            end

            it "returns that success" do
              expect(result).to be_success.without_data.of_service(service).of_step(:result)
            end

            it "does NOT trigger any rollbacks" do
              result

              expect(output).to eq(text)
            end

            context "when service has NO rollback" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step) do |config, out, first_step|
                    include config

                    step first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "original service success" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service success
                TEXT
              end

              it "does NOT trigger service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when service rollback raises exception" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step) do |config, out, first_step|
                    include config

                    step first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "original service success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service success
                TEXT
              end

              it "does NOT trigger service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when step has NO rollback" do
              let(:first_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step_nested_step) do |config, out, first_step_nested_step|
                    include config

                    define_method(:out) { out }

                    step first_step_nested_step

                    step :result

                    def result
                      success.tap { out.puts "first step success" }
                    end

                    def self.name
                      "FirstStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service success
                TEXT
              end

              it "does NOT trigger step rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when step rollback raises exception" do
              let(:first_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step_nested_step) do |config, out, first_step_nested_step|
                    include config

                    define_method(:out) { out }

                    step first_step_nested_step

                    step :result

                    def result
                      success.tap { out.puts "first step success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "FirstStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service success
                TEXT
              end

              it "does NOT trigger step rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when nested step has NO rollback" do
              let(:first_step_nested_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "first service step nested service step success" }
                    end

                    def self.name
                      "FirstStep::NestedStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service success
                TEXT
              end

              it "skips nested step rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when nested step rollback raises exception" do
              let(:first_step_nested_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "first service step nested service step success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "FirstStep::NestedStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service success
                TEXT
              end

              it "does NOT trigger nested step rollback" do
                result

                expect(output).to eq(text)
              end
            end
          end

          context "when service result is failure" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(config, out, first_step) do |config, out, first_step|
                  include config

                  step first_step

                  step :result

                  define_method(:out) { out }

                  def result
                    failure.tap { out.puts "original service failure" }
                  end

                  def rollback_result
                    out.puts "original service rollback"
                  end

                  def self.name
                    "OriginalService"
                  end
                end
              end
            end

            let(:text) do
              <<~TEXT
                first service step nested service step success
                first step success
                original service failure
                original service rollback
                first step rollback
                first service step nested service step rollback
              TEXT
            end

            it "returns that failure" do
              expect(result).to be_failure.without_data.of_service(service).of_step(:result)
            end

            it "triggers service, steps and nested steps rollbacks in reverse order" do
              result

              expect(output).to eq(text)
            end

            context "when service has NO rollback" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step) do |config, out, first_step|
                    include config

                    step first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      failure.tap { out.puts "original service failure" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service failure
                  first step rollback
                  first service step nested service step rollback
                TEXT
              end

              it "skips service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when service rollback raises exception" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step) do |config, out, first_step|
                    include config

                    step first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      failure.tap { out.puts "original service failure" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service failure
                  first step rollback
                  first service step nested service step rollback
                TEXT
              end

              it "rescues service rollback exception" do
                result

                expect(output).to eq(text)
              end
            end

            context "when step has NO rollback" do
              let(:first_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step_nested_step) do |config, out, first_step_nested_step|
                    include config

                    define_method(:out) { out }

                    step first_step_nested_step

                    step :result

                    def result
                      success.tap { out.puts "first step success" }
                    end

                    def self.name
                      "FirstStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service failure
                  original service rollback
                  first service step nested service step rollback
                TEXT
              end

              it "skips step rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when step rollback raises exception" do
              let(:first_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step_nested_step) do |config, out, first_step_nested_step|
                    include config

                    define_method(:out) { out }

                    step first_step_nested_step

                    step :result

                    def result
                      success.tap { out.puts "first step success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "FirstStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service failure
                  original service rollback
                  first service step nested service step rollback
                TEXT
              end

              it "rescues step rollback exception" do
                result

                expect(output).to eq(text)
              end
            end

            context "when nested step has NO rollback" do
              let(:first_step_nested_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "first service step nested service step success" }
                    end

                    def self.name
                      "FirstStep::NestedStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service failure
                  original service rollback
                  first step rollback
                TEXT
              end

              it "skips nested step rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when nested step rollback raises exception" do
              let(:first_step_nested_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "first service step nested service step success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "FirstStep::NestedStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service failure
                  original service rollback
                  first step rollback
                TEXT
              end

              it "rescues nested step rollback exception" do
                result

                expect(output).to eq(text)
              end
            end
          end

          context "when service result is error" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(config, out, first_step) do |config, out, first_step|
                  include config

                  step first_step

                  step :result

                  define_method(:out) { out }

                  def result
                    error.tap { out.puts "original service error" }
                  end

                  def rollback_result
                    out.puts "original service rollback"
                  end

                  def self.name
                    "OriginalService"
                  end
                end
              end
            end

            let(:text) do
              <<~TEXT
                first service step nested service step success
                first step success
                original service error
                original service rollback
                first step rollback
                first service step nested service step rollback
              TEXT
            end

            it "returns that error" do
              expect(result).to be_error.without_data.of_service(service).of_step(:result)
            end

            it "triggers service, steps and nested steps rollbacks in reverse order" do
              result

              expect(output).to eq(text)
            end

            context "when service has NO rollback" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step) do |config, out, first_step|
                    include config

                    step first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      error.tap { out.puts "original service error" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service error
                  first step rollback
                  first service step nested service step rollback
                TEXT
              end

              it "skips service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when service rollback raises exception" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step) do |config, out, first_step|
                    include config

                    step first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      error.tap { out.puts "original service error" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service error
                  first step rollback
                  first service step nested service step rollback
                TEXT
              end

              it "rescues service rollback exception" do
                result

                expect(output).to eq(text)
              end
            end

            context "when step has NO rollback" do
              let(:first_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step_nested_step) do |config, out, first_step_nested_step|
                    include config

                    define_method(:out) { out }

                    step first_step_nested_step

                    step :result

                    def result
                      success.tap { out.puts "first step success" }
                    end

                    def self.name
                      "FirstStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service error
                  original service rollback
                  first service step nested service step rollback
                TEXT
              end

              it "skips step rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when step rollback raises exception" do
              let(:first_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out, first_step_nested_step) do |config, out, first_step_nested_step|
                    include config

                    define_method(:out) { out }

                    step first_step_nested_step

                    step :result

                    def result
                      success.tap { out.puts "first step success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "FirstStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service error
                  original service rollback
                  first service step nested service step rollback
                TEXT
              end

              it "rescues step rollback exception" do
                result

                expect(output).to eq(text)
              end
            end

            context "when nested step has NO rollback" do
              let(:first_step_nested_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "first service step nested service step success" }
                    end

                    def self.name
                      "FirstStep::NestedStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service error
                  original service rollback
                  first step rollback
                TEXT
              end

              it "skips nested step rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when nested step rollback raises exception" do
              let(:first_step_nested_step) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "first service step nested service step success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def self.name
                      "FirstStep::NestedStep"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first service step nested service step success
                  first step success
                  original service error
                  original service rollback
                  first step rollback
                TEXT
              end

              it "rescues nested step rollback exception" do
                result

                expect(output).to eq(text)
              end
            end
          end
        end

        context "when service has only method steps" do
          context "when service result is success" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(config, out) do |config, out|
                  include config

                  step :first_step

                  step :result

                  define_method(:out) { out }

                  def result
                    success.tap { out.puts "original service success" }
                  end

                  def rollback_result
                    out.puts "original service rollback"
                  end

                  def first_step
                    success.tap { out.puts "first method step success" }
                  end

                  def self.name
                    "OriginalService"
                  end
                end
              end
            end

            let(:text) do
              <<~TEXT
                first method step success
                original service success
              TEXT
            end

            it "returns that success" do
              expect(result).to be_success.without_data.of_service(service).of_step(:result)
            end

            it "does NOT trigger any rollbacks" do
              result

              expect(output).to eq(text)
            end

            context "when service has NO rollback" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    step :first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "original service success" }
                    end

                    def first_step
                      success.tap { out.puts "first method step success" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first method step success
                  original service success
                TEXT
              end

              it "does NOT trigger service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when service rollback raises exception" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    step :first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      success.tap { out.puts "original service success" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def first_step
                      success.tap { out.puts "first method step success" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first method step success
                  original service success
                TEXT
              end

              it "does NOT trigger service rollback" do
                result

                expect(output).to eq(text)
              end
            end
          end

          context "when service result is failure" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(config, out) do |config, out|
                  include config

                  step :first_step

                  step :result

                  define_method(:out) { out }

                  def result
                    failure.tap { out.puts "original service failure" }
                  end

                  def rollback_result
                    out.puts "original service rollback"
                  end

                  def first_step
                    success.tap { out.puts "first method step success" }
                  end

                  def self.name
                    "OriginalService"
                  end
                end
              end
            end

            let(:text) do
              <<~TEXT
                first method step success
                original service failure
                original service rollback
              TEXT
            end

            it "returns that failure" do
              expect(result).to be_failure.without_data.of_service(service).of_step(:result)
            end

            it "triggers service rollback" do
              result

              expect(output).to eq(text)
            end

            context "when service has NO rollback" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    step :first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      failure.tap { out.puts "original service failure" }
                    end

                    def first_step
                      success.tap { out.puts "first method step success" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first method step success
                  original service failure
                TEXT
              end

              it "skips service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when service rollback raises exception" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    step :first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      failure.tap { out.puts "original service failure" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def first_step
                      success.tap { out.puts "first method step success" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first method step success
                  original service failure
                TEXT
              end

              it "rescues service rollback exception" do
                result

                expect(output).to eq(text)
              end
            end
          end

          context "when service result is error" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(config, out) do |config, out|
                  include config

                  step :first_step

                  step :result

                  define_method(:out) { out }

                  def result
                    error.tap { out.puts "original service error" }
                  end

                  def rollback_result
                    out.puts "original service rollback"
                  end

                  def first_step
                    success.tap { out.puts "first method step success" }
                  end

                  def self.name
                    "OriginalService"
                  end
                end
              end
            end

            let(:text) do
              <<~TEXT
                first method step success
                original service error
                original service rollback
              TEXT
            end

            it "returns that error" do
              expect(result).to be_error.without_data.of_service(service).of_step(:result)
            end

            it "triggers service rollback" do
              result

              expect(output).to eq(text)
            end

            context "when service has NO rollback" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    step :first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      error.tap { out.puts "original service error" }
                    end

                    def first_step
                      success.tap { out.puts "first method step success" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first method step success
                  original service error
                TEXT
              end

              it "skips service rollback" do
                result

                expect(output).to eq(text)
              end
            end

            context "when service rollback raises exception" do
              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(config, out) do |config, out|
                    include config

                    step :first_step

                    step :result

                    define_method(:out) { out }

                    def result
                      error.tap { out.puts "original service error" }
                    end

                    def rollback_result
                      raise ArgumentError
                    end

                    def first_step
                      success.tap { out.puts "first method step success" }
                    end

                    def self.name
                      "OriginalService"
                    end
                  end
                end
              end

              let(:text) do
                <<~TEXT
                  first method step success
                  original service error
                TEXT
              end

              it "rescues service rollback exception" do
                result

                expect(output).to eq(text)
              end
            end
          end
        end

        context "when service has not completed steps" do
          let(:first_step) do
            Class.new.tap do |klass|
              klass.class_exec(config, out) do |config, out|
                include config

                define_method(:out) { out }

                def result
                  failure.tap { out.puts "first service step failure" }
                end

                def rollback_result
                  out.puts "first service step rollback"
                end

                def self.name
                  "FirstStep"
                end
              end
            end
          end

          let(:second_step) do
            Class.new.tap do |klass|
              klass.class_exec(config, out) do |config, out|
                include config

                define_method(:out) { out }

                def result
                  success.tap { out.puts "second service step success" }
                end

                def rollback_result
                  out.puts "second service step rollback"
                end

                def self.name
                  "SecondStep"
                end
              end
            end
          end

          let(:service) do
            Class.new.tap do |klass|
              klass.class_exec(config, out, first_step, second_step) do |config, out, first_step, second_step|
                include config

                step first_step

                step second_step

                step :result

                define_method(:out) { out }

                def result
                  success.tap { out.puts "original service success" }
                end

                def rollback_result
                  out.puts "original service rollback"
                end

                def self.name
                  "OriginalService"
                end
              end
            end

            let(:text) do
              <<~TEXT
                first service step failure
                first service step rollback
                original service rollback
              TEXT
            end

            it "returns last completed step result" do
              expect(result).to be_failure.without_data.of_service(service).of_service(first_step)
            end

            it "triggers service and completed steps rollbacks in reverse order" do
              result

              expect(output).to eq(text)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
