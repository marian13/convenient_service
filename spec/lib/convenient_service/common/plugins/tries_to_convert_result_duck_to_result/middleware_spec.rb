# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::TriesToConvertResultDuckToResult::Middleware, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :result, entity: any_entity
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

      let(:method) { wrap_method(service_instance, method_name, observe_middleware: middleware) }
      let(:method_name) { :result }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Standard::Config

            middlewares :result do
              observe middleware
            end

            def result
              success
            end
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify do
        expect { method_value }.to call_chain_next.on(method)
      end

      specify do
        expect { method_value }.to delegate_to(ConvenientService::Service::Plugins::HasJSendResult, :result?)
      end

      context "when `type_safety` option is disabled" do
        context "when `result` is NOT result" do
          context "when `result` is NOT result duck (does NOT respond to #result)" do
            context "when that #result does NOT raise exception" do
              let(:service_class) do
                Class.new.tap do |klass|
                  klass.class_exec(middleware) do |middleware|
                    include ConvenientService::Standard::Config.without(:type_safety)

                    middlewares :result do
                      observe middleware
                    end

                    def result
                      "string value"
                    end
                  end
                end
              end

              it "raises `NoMethodError`" do
                expect { method_value }
                  .to raise_error(NoMethodError)
                  .with_message(/String/)
              end

              specify do
                expect { ignoring_exception(NoMethodError) { method_value } }
                  .not_to delegate_to(ConvenientService, :raise)
              end
            end

            context "when that #result raises exception" do
              let(:exception_message) { "exception from result" }

              context "when that #result does NOT raise `NoMethodError` exception" do
                let(:service_class) do
                  Class.new.tap do |klass|
                    klass.class_exec(middleware) do |middleware|
                      include ConvenientService::Standard::Config.without(:type_safety)

                      middlewares :result do
                        observe middleware
                      end

                      def result
                        raise ArgumentError, "exception from result"
                      end
                    end
                  end
                end

                it "raises `ArgumentError`" do
                  expect { method_value }
                    .to raise_error(ArgumentError)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ArgumentError) { method_value } }
                    .not_to delegate_to(ConvenientService, :raise)
                end
              end

              context "when that #result raises `NoMethodError` exception" do
                let(:service_class) do
                  Class.new.tap do |klass|
                    klass.class_exec(middleware) do |middleware|
                      include ConvenientService::Standard::Config.without(:type_safety)

                      middlewares :result do
                        observe middleware
                      end

                      def result
                        raise NoMethodError, "exception from result"
                      end
                    end
                  end
                end

                it "raises `NoMethodError`" do
                  expect { method_value }
                    .to raise_error(NoMethodError)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(NoMethodError) { method_value } }
                    .not_to delegate_to(ConvenientService, :raise)
                end
              end
            end
          end

          context "when `result` is result duck (responds to #result)" do
            context "when that #result does NOT raise exception" do
              context "when that #result does NOT return result" do
                let(:service_class) do
                  Class.new.tap do |klass|
                    klass.class_exec(middleware) do |middleware|
                      include ConvenientService::Standard::Config.without(:type_safety)

                      middlewares :result do
                        observe middleware
                      end

                      def result
                        OpenStruct.new(result: 42)
                      end
                    end
                  end
                end

                it "raises `NoMethodError`" do
                  expect { method_value }
                    .to raise_error(NoMethodError)
                    .with_message(/Integer/)
                end

                specify do
                  expect { ignoring_exception(NoMethodError) { method_value } }
                    .not_to delegate_to(ConvenientService, :raise)
                end
              end

              context "when that #result returns result" do
                let(:service_class) do
                  Class.new.tap do |klass|
                    klass.class_exec(middleware, first_step) do |middleware, first_step|
                      include ConvenientService::Standard::Config.without(:type_safety)

                      define_singleton_method(:first_step) { first_step }

                      middlewares :result do
                        observe middleware
                      end

                      def result
                        step first_step
                      end

                      private

                      def first_step
                        self.class.first_step
                      end
                    end
                  end
                end

                let(:first_step) do
                  Class.new do
                    include ConvenientService::Standard::Config.without(:type_safety)

                    def result
                      success(from: :first_step)
                    end
                  end
                end

                it "returns original method value" do
                  expect(method_value).to be_success.with_data(from: :first_step)
                end
              end
            end

            context "when that #result raises exception" do
              let(:service_class) do
                Class.new.tap do |klass|
                  klass.class_exec(middleware, first_step) do |middleware, first_step|
                    include ConvenientService::Standard::Config.without(:type_safety)

                    define_singleton_method(:first_step) { first_step }

                    middlewares :result do
                      observe middleware
                    end

                    def result
                      step first_step
                    end

                    private

                    def first_step
                      self.class.first_step
                    end
                  end
                end
              end

              let(:exception_message) { "exception from first_step" }

              context "when that #result does NOT raise `NoMethodError` exception" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      raise ArgumentError, "exception from first_step"
                    end
                  end
                end

                it "raises `ArgumentError`" do
                  expect { method_value }
                    .to raise_error(ArgumentError)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ArgumentError) { method_value } }
                    .not_to delegate_to(ConvenientService, :raise)
                end
              end

              context "when that #result raises `NoMethodError` exception" do
                context "when that #result raises NOT native `NoMethodError` exception" do
                  let(:first_step) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        raise NoMethodError, "exception from first_step"
                      end
                    end
                  end

                  it "raises that NOT native `NoMethodError`" do
                    expect { method_value }
                      .to raise_error(NoMethodError)
                      .with_message(exception_message)
                  end

                  specify do
                    expect { ignoring_exception(NoMethodError) { method_value } }
                      .not_to delegate_to(ConvenientService, :raise)
                  end
                end

                context "when that #result raises native `NoMethodError` exception" do
                  context "when that native `NoMethodError` exception receiver does NOT respond to `result`" do
                    let(:first_step) do
                      Class.new do
                        include ConvenientService::Standard::Config

                        def result
                          Set.new.not_existing_method
                        end
                      end
                    end

                    it "raises that native `NoMethodError`" do
                      expect { method_value }
                        .to raise_error(NoMethodError)
                        .with_message(/not_existing_method/)
                    end

                    specify do
                      expect { ignoring_exception(NoMethodError) { method_value } }
                        .not_to delegate_to(ConvenientService, :raise)
                    end
                  end

                  context "when that native `NoMethodError` exception receiver responds to `result`" do
                    let(:first_step) do
                      Class.new do
                        include ConvenientService::Standard::Config

                        def result
                          klass = Class.new do
                            def result
                              Set.new.not_existing_method
                            end
                          end

                          klass.new
                        end
                      end
                    end

                    it "raises that native `NoMethodError`" do
                      expect { method_value }
                        .to raise_error(NoMethodError)
                        .with_message(/not_existing_method/)
                    end

                    specify do
                      expect { ignoring_exception(NoMethodError) { method_value } }
                        .not_to delegate_to(ConvenientService, :raise)
                    end
                  end
                end
              end
            end
          end
        end

        context "when `result` is result" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(middleware) do |middleware|
                include ConvenientService::Standard::Config.without(:type_safety)

                middlewares :result do
                  observe middleware
                end

                def result
                  success(from: :result)
                end
              end
            end
          end

          it "returns original method value" do
            expect(method_value).to be_success.with_data(from: :result)
          end
        end
      end

      context "when `type_safety` option is enabled" do
        context "when `result` is NOT result" do
          context "when `result` is NOT result duck (does NOT respond to #result)" do
            context "when that #result does NOT raise exception" do
              let(:service_class) do
                Class.new.tap do |klass|
                  klass.class_exec(middleware) do |middleware|
                    include ConvenientService::Standard::Config

                    middlewares :result do
                      observe middleware
                    end

                    def result
                      "string value"
                    end
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  Return value of service `#{service_class}` is NOT a `Result`.
                  It is `String`.

                  Did you forget to call `success`, `failure`, or `error` from the `:#{method_name}` method?
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult`" do
                expect { method_value }
                  .to raise_error(ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult) { method_value } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end

            context "when that #result raises exception" do
              let(:exception_message) { "exception from result" }

              context "when that #result does NOT raise `NoMethodError` exception" do
                let(:service_class) do
                  Class.new.tap do |klass|
                    klass.class_exec(middleware) do |middleware|
                      include ConvenientService::Standard::Config

                      middlewares :result do
                        observe middleware
                      end

                      def result
                        raise ArgumentError, "exception from result"
                      end
                    end
                  end
                end

                it "raises `ArgumentError`" do
                  expect { method_value }
                    .to raise_error(ArgumentError)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ArgumentError) { method_value } }
                    .not_to delegate_to(ConvenientService, :raise)
                end
              end

              context "when that #result raises `NoMethodError` exception" do
                let(:service_class) do
                  Class.new.tap do |klass|
                    klass.class_exec(middleware) do |middleware|
                      include ConvenientService::Standard::Config

                      middlewares :result do
                        observe middleware
                      end

                      def result
                        raise NoMethodError, "exception from result"
                      end
                    end
                  end
                end

                it "raises `NoMethodError`" do
                  expect { method_value }
                    .to raise_error(NoMethodError)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(NoMethodError) { method_value } }
                    .not_to delegate_to(ConvenientService, :raise)
                end
              end
            end
          end

          context "when `result` is result duck (responds to #result)" do
            context "when that #result does NOT raise exception" do
              context "when that #result does NOT return result" do
                let(:service_class) do
                  Class.new.tap do |klass|
                    klass.class_exec(middleware) do |middleware|
                      include ConvenientService::Standard::Config

                      middlewares :result do
                        observe middleware
                      end

                      def result
                        OpenStruct.new(result: 42)
                      end
                    end
                  end
                end

                let(:exception_message) do
                  <<~TEXT
                    Return value of service `#{service_class}` is NOT a `Result`.
                    It is `Integer`.

                    Did you forget to call `success`, `failure`, or `error` from the `:#{method_name}` method?
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end

              context "when that #result returns result" do
                let(:service_class) do
                  Class.new.tap do |klass|
                    klass.class_exec(middleware, first_step) do |middleware, first_step|
                      include ConvenientService::Standard::Config

                      define_singleton_method(:first_step) { first_step }

                      middlewares :result do
                        observe middleware
                      end

                      def result
                        step first_step
                      end

                      private

                      def first_step
                        self.class.first_step
                      end
                    end
                  end
                end

                let(:first_step) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      success(from: :first_step)
                    end
                  end
                end

                it "returns original method value" do
                  expect(method_value).to be_success.with_data(from: :first_step)
                end
              end
            end

            context "when that #result raises exception" do
              let(:service_class) do
                Class.new.tap do |klass|
                  klass.class_exec(middleware, first_step) do |middleware, first_step|
                    include ConvenientService::Standard::Config

                    define_singleton_method(:first_step) { first_step }

                    middlewares :result do
                      observe middleware
                    end

                    def result
                      step first_step
                    end

                    private

                    def first_step
                      self.class.first_step
                    end
                  end
                end
              end

              let(:exception_message) { "exception from first_step" }

              context "when that #result does NOT raise `NoMethodError` exception" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      raise ArgumentError, "exception from first_step"
                    end
                  end
                end

                it "raises that NOT `NoMethodError` exception" do
                  expect { method_value }
                    .to raise_error(ArgumentError)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ArgumentError) { method_value } }
                    .not_to delegate_to(ConvenientService, :raise)
                end
              end

              context "when that #result raises `NoMethodError` exception" do
                context "when that #result raises NOT native `NoMethodError` exception" do
                  let(:first_step) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        raise NoMethodError, "exception from first_step"
                      end
                    end
                  end

                  it "raises that NOT native `NoMethodError` exception" do
                    expect { method_value }
                      .to raise_error(NoMethodError)
                      .with_message(exception_message)
                  end

                  specify do
                    expect { ignoring_exception(NoMethodError) { method_value } }
                      .not_to delegate_to(ConvenientService, :raise)
                  end
                end

                context "when that #result raises native `NoMethodError` exception" do
                  context "when that native `NoMethodError` exception receiver does NOT respond to `result`" do
                    let(:first_step) do
                      Class.new do
                        include ConvenientService::Standard::Config

                        def result
                          Set.new.not_existing_method
                        end
                      end
                    end

                    it "raises that native `NoMethodError` exception" do
                      expect { method_value }
                        .to raise_error(NoMethodError)
                        .with_message(/not_existing_method/)
                    end

                    specify do
                      expect { ignoring_exception(NoMethodError) { method_value } }
                        .not_to delegate_to(ConvenientService, :raise)
                    end
                  end

                  context "when that native `NoMethodError` exception receiver responds to `result`" do
                    let(:first_step) do
                      Class.new do
                        include ConvenientService::Standard::Config

                        def result
                          klass = Class.new do
                            def result
                              Set.new.not_existing_method
                            end
                          end

                          klass.new
                        end
                      end
                    end

                    it "raises that native `NoMethodError` exception" do
                      expect { method_value }
                        .to raise_error(NoMethodError)
                        .with_message(/not_existing_method/)
                    end

                    specify do
                      expect { ignoring_exception(NoMethodError) { method_value } }
                        .not_to delegate_to(ConvenientService, :raise)
                    end
                  end
                end
              end
            end
          end
        end

        context "when `result` is result" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(middleware) do |middleware|
                include ConvenientService::Standard::Config

                middlewares :result do
                  observe middleware
                end

                def result
                  success(from: :result)
                end
              end
            end
          end

          it "returns original method value" do
            expect(method_value).to be_success.with_data(from: :result)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
