# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Commands::UndefineMethodCallers, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:command_result) { command_instance.call }
  let(:command_instance) { described_class.new(scope: scope, method: method, container: container) }

  let(:scope) { :instance }
  let(:method) { :result }
  let(:method_without_middlewares) { "result_without_middlewares" }

  let(:container) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container.new(klass: klass) }
  let(:methods_middlewares_callers) { container.methods_middlewares_callers }
  let(:klass) { service_class }

  let(:service_class) do
    Class.new do
      include ConvenientService::Core
    end
  end

  let(:caller) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller.new(prefix: prefix) }
  let(:prefix) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Constants::INSTANCE_PREFIX }

  example_group "attributes" do
    include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

    subject { command_instance }

    it { is_expected.to have_attr_reader(:scope) }
    it { is_expected.to have_attr_reader(:method) }
    it { is_expected.to have_attr_reader(:container) }
  end

  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::PrimitiveMatchers::PrependModule

      context "when `scope` is `:instance`" do
        let(:scope) { :instance }
        let(:container) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container.new(klass: klass) }

        context "when `method` caller (with middlewares) is NOT defined in methods callers" do
          it "synchronize method definitions by lock" do
            allow(container.lock).to receive(:synchronize).and_call_original

            command_result

            expect(container.lock).to have_received(:synchronize)
          end

          specify do
            expect { command_result }
              .not_to delegate_to(ConvenientService::Utils::Method, :remove)
              .with_arguments(method, methods_middlewares_callers, private: true)
          end

          specify do
            expect { command_result }
              .not_to delegate_to(ConvenientService::Utils::Method, :remove)
              .with_arguments(method_without_middlewares, methods_middlewares_callers, private: true)
          end

          it "returns `false`" do
            expect(command_result).to eq(false)
          end
        end

        context "when `method` caller (with middlewares) is defined in methods callers" do
          before do
            ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Commands::DefineMethodCallers[scope: scope, method: method, container: container, caller: caller]
          end

          it "synchronize method definitions by lock" do
            allow(container.lock).to receive(:synchronize).and_call_original

            command_result

            expect(container.lock).to have_received(:synchronize)
          end

          it "removes `method` caller (with middlewares)" do
            expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method, methods_middlewares_callers, private: true) }.from(true).to(false)
          end

          specify do
            expect { command_result }
              .to delegate_to(ConvenientService::Utils::Method, :remove)
              .with_arguments(method, methods_middlewares_callers, private: true)
          end

          it "removes `method` caller without middlewares" do
            expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method_without_middlewares, methods_middlewares_callers, private: true) }.from(true).to(false)
          end

          specify do
            expect { command_result }
              .to delegate_to(ConvenientService::Utils::Method, :remove)
              .with_arguments(method_without_middlewares, methods_middlewares_callers, private: true)
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end

          context "when `method` name ends with `!`" do
            let(:method) { :result! }
            let(:method_without_middlewares) { "result_without_middlewares!" }

            it "removes `method` caller without middlewares placing `!` after `without_middlewares` suffix" do
              expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method_without_middlewares, methods_middlewares_callers, private: true) }.from(true).to(false)
            end
          end

          context "when `method` name ends with `?`" do
            let(:method) { :success? }
            let(:method_without_middlewares) { "success_without_middlewares?" }

            it "removes `method` caller without middlewares placing `?` after `without_middlewares` suffix" do
              expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method_without_middlewares, methods_middlewares_callers, private: true) }.from(true).to(false)
            end
          end
        end
      end

      context "when `scope` is `:class`" do
        let(:scope) { :class }
        let(:container) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container.new(klass: klass.singleton_class) }

        context "when `method` caller (with middlewares) is NOT defined in methods callers" do
          it "synchronize method definitions by lock" do
            allow(container.lock).to receive(:synchronize).and_call_original

            command_result

            expect(container.lock).to have_received(:synchronize)
          end

          specify do
            expect { command_result }
              .not_to delegate_to(ConvenientService::Utils::Method, :remove)
              .with_arguments(method, methods_middlewares_callers, private: true)
          end

          specify do
            expect { command_result }
              .not_to delegate_to(ConvenientService::Utils::Method, :remove)
              .with_arguments(method_without_middlewares, methods_middlewares_callers, private: true)
          end

          it "returns `false`" do
            expect(command_result).to eq(false)
          end
        end

        context "when `method` caller (with middlewares) is defined in methods callers" do
          before do
            ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Commands::DefineMethodCallers[scope: scope, method: method, container: container, caller: caller]
          end

          it "synchronize method definitions by lock" do
            allow(container.lock).to receive(:synchronize).and_call_original

            command_result

            expect(container.lock).to have_received(:synchronize)
          end

          it "removes `method` caller (with middlewares)" do
            expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method, methods_middlewares_callers, private: true) }.from(true).to(false)
          end

          specify do
            expect { command_result }
              .to delegate_to(ConvenientService::Utils::Method, :remove)
              .with_arguments(method, methods_middlewares_callers, private: true)
          end

          it "removes `method` caller without middlewares" do
            expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method_without_middlewares, methods_middlewares_callers, private: true) }.from(true).to(false)
          end

          specify do
            expect { command_result }
              .to delegate_to(ConvenientService::Utils::Method, :remove)
              .with_arguments(method_without_middlewares, methods_middlewares_callers, private: true)
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end

          context "when `method` name ends with `!`" do
            let(:method) { :result! }
            let(:method_without_middlewares) { "result_without_middlewares!" }

            it "removes `method` caller without middlewares placing `!` after `without_middlewares` suffix" do
              expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method_without_middlewares, methods_middlewares_callers, private: true) }.from(true).to(false)
            end
          end

          context "when `method` name ends with `?`" do
            let(:method) { :success? }
            let(:method_without_middlewares) { "success_without_middlewares?" }

            it "removes `method` caller without middlewares placing `?` after `without_middlewares` suffix" do
              expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method_without_middlewares, methods_middlewares_callers, private: true) }.from(true).to(false)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
