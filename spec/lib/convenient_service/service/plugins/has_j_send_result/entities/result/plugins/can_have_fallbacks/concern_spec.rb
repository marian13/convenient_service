# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Concern, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      let(:result_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    describe "#with_fallback" do
      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            failure("from original result")
          end

          def fallback_result
            success(from: :fallback_result)
          end
        end
      end

      let(:result) { service.result }

      let(:raise_when_missing) { false }

      specify do
        expect { result.with_fallback(raise_when_missing: raise_when_missing) }
          .to delegate_to(result, :with_failure_fallback)
          .with_arguments(raise_when_missing: raise_when_missing)
          .and_return_its_value
      end
    end

    describe "#with_fallback_for" do
      let(:result) { service.result }

      let(:raise_when_missing) { false }

      context "when `statuses_to_fallback` is `failure`" do
        context "when that `failure` is passed as single value" do
          let(:statuses_to_fallback) { :failure }

          context "when result is success" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success(from: :original_result)
                end
              end
            end

            it "returns original result" do
              expect(result.with_fallback_for(statuses_to_fallback)).to be_success.with_data(from: :original_result)
            end
          end

          context "when result is failure" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  failure("from original result")
                end

                def fallback_result
                  success(from: :fallback_result)
                end
              end
            end

            specify do
              expect { result.with_fallback_for(statuses_to_fallback, raise_when_missing: raise_when_missing) }
                .to delegate_to(result, :with_failure_fallback)
                .with_arguments(raise_when_missing: raise_when_missing)
                .and_return_its_value
            end
          end

          context "when result is error" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  error("from original result")
                end

                def fallback_result
                  success(from: :fallback_result)
                end
              end
            end

            it "returns original result" do
              expect(result.with_fallback_for(statuses_to_fallback)).to be_error.with_message("from original result")
            end
          end
        end

        context "when that `failure` is passed as array" do
          let(:statuses_to_fallback) { [:failure] }

          context "when result is success" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success(from: :original_result)
                end
              end
            end

            it "returns original result" do
              expect(result.with_fallback_for(statuses_to_fallback)).to be_success.with_data(from: :original_result)
            end
          end

          context "when result is failure" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  failure("from original result")
                end

                def fallback_result
                  success(from: :fallback_result)
                end
              end
            end

            specify do
              expect { result.with_fallback_for(statuses_to_fallback, raise_when_missing: raise_when_missing) }
                .to delegate_to(result, :with_failure_fallback)
                .with_arguments(raise_when_missing: raise_when_missing)
                .and_return_its_value
            end
          end

          context "when result is error" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  error("from original result")
                end

                def fallback_result
                  success(from: :fallback_result)
                end
              end
            end

            it "returns original result" do
              expect(result.with_fallback_for(statuses_to_fallback)).to be_error.with_message("from original result")
            end
          end
        end
      end

      context "when `statuses_to_fallback` is `error`" do
        context "when that `error` is passed as single value" do
          let(:statuses_to_fallback) { :error }

          context "when result is success" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success(from: :original_result)
                end
              end
            end

            it "returns original result" do
              expect(result.with_fallback_for(statuses_to_fallback)).to be_success.with_data(from: :original_result)
            end
          end

          context "when result is failure" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  failure("from original result")
                end

                def fallback_result
                  success(from: :fallback_result)
                end
              end
            end

            it "returns original result" do
              expect(result.with_fallback_for(statuses_to_fallback)).to be_failure.with_message("from original result")
            end
          end

          context "when result is error" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  error("from original result")
                end

                def fallback_result
                  success(from: :fallback_result)
                end
              end
            end

            specify do
              expect { result.with_fallback_for(statuses_to_fallback, raise_when_missing: raise_when_missing) }
                .to delegate_to(result, :with_error_fallback)
                .with_arguments(raise_when_missing: raise_when_missing)
                .and_return_its_value
            end
          end
        end

        context "when that `error` is passed as array" do
          let(:statuses_to_fallback) { [:error] }

          context "when result is success" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success(from: :original_result)
                end
              end
            end

            it "returns original result" do
              expect(result.with_fallback_for(statuses_to_fallback)).to be_success.with_data(from: :original_result)
            end
          end

          context "when result is failure" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  failure("from original result")
                end

                def fallback_result
                  success(from: :fallback_result)
                end
              end
            end

            it "returns original result" do
              expect(result.with_fallback_for(statuses_to_fallback)).to be_failure.with_message("from original result")
            end
          end

          context "when result is error" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  error("from original result")
                end

                def fallback_result
                  success(from: :fallback_result)
                end
              end
            end

            specify do
              expect { result.with_fallback_for(statuses_to_fallback, raise_when_missing: raise_when_missing) }
                .to delegate_to(result, :with_error_fallback)
                .with_arguments(raise_when_missing: raise_when_missing)
                .and_return_its_value
            end
          end
        end
      end

      context "when `statuses_to_fallback` is both `failure` and `error`" do
        let(:statuses_to_fallback) { [:failure, :error] }

        context "when result is success" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(from: :original_result)
              end
            end
          end

          it "returns original result" do
            expect(result.with_fallback_for(statuses_to_fallback)).to be_success.with_data(from: :original_result)
          end
        end

        context "when result is failure" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure("from original result")
              end

              def fallback_result
                success(from: :fallback_result)
              end
            end
          end

          specify do
            expect { result.with_fallback_for(statuses_to_fallback, raise_when_missing: raise_when_missing) }
              .to delegate_to(result, :with_failure_fallback)
              .with_arguments(raise_when_missing: raise_when_missing)
              .and_return_its_value
          end
        end

        context "when result is error" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error("from original result")
              end

              def fallback_result
                success(from: :fallback_result)
              end
            end
          end

          specify do
            expect { result.with_fallback_for(statuses_to_fallback, raise_when_missing: raise_when_missing) }
              .to delegate_to(result, :with_error_fallback)
              .with_arguments(raise_when_missing: raise_when_missing)
              .and_return_its_value
          end
        end
      end
    end

    describe "#with_failure_fallback" do
      let(:result) { service.result }

      context "when result is success" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(from: :original_result)
            end
          end
        end

        it "returns original result" do
          expect(result.with_failure_fallback).to be_success.with_data(from: :original_result)
        end
      end

      context "when result is failure" do
        context "when service does NOT have `fallback_failure_result` method" do
          context "when service does NOT have `fallback_result` method" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  failure("from original result")
                end

                def self.name
                  "ImportantService"
                end
              end
            end

            let(:exception_message) do
              <<~TEXT
                Result has NO `failure` fallback since neither `fallback_failure_result` nor `fallback_result` methods of `ImportantService` are overridden.
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
              expect { result.with_failure_fallback }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { result.with_failure_fallback } }
                .to delegate_to(ConvenientService, :raise)
            end
          end

          context "when service has `fallback_result` method" do
            context "when that `fallback_result` method is NOT service own method" do
              let(:mod) do
                Module.new do
                  def fallback_result
                    success(from: :inherited_fallback_result)
                  end
                end
              end

              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(mod) do |mod|
                    include ConvenientService::Standard::Config
                    include mod

                    def result
                      failure("from original result")
                    end

                    def self.name
                      "ImportantService"
                    end
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  Result has NO `failure` fallback since neither `fallback_failure_result` nor `fallback_result` methods of `ImportantService` are overridden.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
                expect { result.with_failure_fallback }
                  .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { result.with_failure_fallback } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end

            context "when that `fallback_result` method is service own method" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    failure("from original result")
                  end

                  def fallback_result
                    success(from: :own_fallback_result)
                  end
                end
              end

              it "returns result from own `fallback_result` method" do
                expect(result.with_failure_fallback).to be_success.with_data(from: :own_fallback_result)
              end
            end
          end
        end

        context "when service has `fallback_failure_result` method" do
          context "when that `fallback_failure_result` method is NOT service own method" do
            context "when service does NOT have `fallback_result` method" do
              let(:mod) do
                Module.new do
                  def fallback_failure_result
                    success(from: :inherited_fallback_failure_result)
                  end
                end
              end

              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(mod) do |mod|
                    include ConvenientService::Standard::Config
                    include mod

                    def result
                      failure("from original result")
                    end

                    def self.name
                      "ImportantService"
                    end
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  Result has NO `failure` fallback since neither `fallback_failure_result` nor `fallback_result` methods of `ImportantService` are overridden.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
                expect { result.with_failure_fallback }
                  .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { result.with_failure_fallback } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end

            context "when service has `fallback_result` method" do
              context "when that `fallback_result` method is NOT service own method" do
                let(:mod) do
                  Module.new do
                    def fallback_failure_result
                      success(from: :inherited_fallback_failure_result)
                    end

                    def fallback_result
                      success(from: :inherited_fallback_result)
                    end
                  end
                end

                let(:service) do
                  Class.new.tap do |klass|
                    klass.class_exec(mod) do |mod|
                      include ConvenientService::Standard::Config
                      include mod

                      def result
                        failure("from original result")
                      end

                      def self.name
                        "ImportantService"
                      end
                    end
                  end
                end

                let(:exception_message) do
                  <<~TEXT
                    Result has NO `failure` fallback since neither `fallback_failure_result` nor `fallback_result` methods of `ImportantService` are overridden.
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
                  expect { result.with_failure_fallback }
                    .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { result.with_failure_fallback } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end

              context "when that `fallback_result` method is service own method" do
                let(:mod) do
                  Module.new do
                    def fallback_failure_result
                      success(from: :inherited_fallback_failure_result)
                    end
                  end
                end

                let(:service) do
                  Class.new.tap do |klass|
                    klass.class_exec(mod) do |mod|
                      include ConvenientService::Standard::Config
                      include mod

                      def result
                        failure("from original result")
                      end

                      def fallback_result
                        success(from: :own_fallback_result)
                      end
                    end
                  end
                end

                it "returns result from own `fallback_result` method" do
                  expect(result.with_failure_fallback).to be_success.with_data(from: :own_fallback_result)
                end
              end
            end
          end

          context "when that `fallback_failure_result` method is service own method" do
            context "when service does NOT have `fallback_result` method" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    failure("from original result")
                  end

                  def fallback_failure_result
                    success(from: :own_fallback_failure_result)
                  end
                end
              end

              it "returns result from own `fallback_failure_result` method" do
                expect(result.with_failure_fallback).to be_success.with_data(from: :own_fallback_failure_result)
              end
            end

            context "when service has `fallback_result` method" do
              context "when that `fallback_result` method is NOT service own method" do
                let(:mod) do
                  Module.new do
                    def fallback_result
                      success(from: :inherited_fallback_result)
                    end
                  end
                end

                let(:service) do
                  Class.new.tap do |klass|
                    klass.class_exec(mod) do |mod|
                      include ConvenientService::Standard::Config
                      include mod

                      def result
                        failure("from original result")
                      end

                      def fallback_failure_result
                        success(from: :own_fallback_failure_result)
                      end
                    end
                  end
                end

                it "returns result from own `fallback_failure_result` method" do
                  expect(result.with_failure_fallback).to be_success.with_data(from: :own_fallback_failure_result)
                end
              end

              context "when that `fallback_result` method is service own method" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      failure("from original result")
                    end

                    def fallback_failure_result
                      success(from: :own_fallback_failure_result)
                    end

                    def fallback_result
                      success(from: :own_fallback_result)
                    end
                  end
                end

                it "returns result from own `fallback_result` method" do
                  expect(result.with_failure_fallback).to be_success.with_data(from: :own_fallback_failure_result)
                end
              end
            end
          end
        end
      end

      context "when result is error" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_failure_fallback).to be_error.with_message("from original result")
        end
      end

      example_group "`raise_when_missing` option" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from original result")
            end

            def self.name
              "ImportantService"
            end
          end
        end

        context "when `raise_when_missing` option is NOT passed" do
          let(:exception_message) do
            <<~TEXT
              Result has NO `failure` fallback since neither `fallback_failure_result` nor `fallback_result` methods of `ImportantService` are overridden.
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
            expect { result.with_failure_fallback }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { result.with_failure_fallback } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `raise_when_missing` option is passed" do
          context "when `raise_when_missing` option is `false`" do
            let(:raise_when_missing) { false }

            it "returns `nil`" do
              expect(result.with_failure_fallback(raise_when_missing: raise_when_missing)).to be_nil
            end
          end

          context "when `raise_when_missing` option is `true`" do
            let(:raise_when_missing) { true }

            let(:exception_message) do
              <<~TEXT
                Result has NO `failure` fallback since neither `fallback_failure_result` nor `fallback_result` methods of `ImportantService` are overridden.
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
              expect { result.with_failure_fallback(raise_when_missing: raise_when_missing) }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { result.with_failure_fallback(raise_when_missing: raise_when_missing) } }
                .to delegate_to(ConvenientService, :raise)
            end
          end
        end

        example_group "anonymous service" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure("from original result")
              end
            end
          end

          let(:exception_message) do
            <<~TEXT
              Result has NO `failure` fallback since neither `fallback_failure_result` nor `fallback_result` methods of `#{ConvenientService::Utils::Class.display_name(service)}` are overridden.
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
            expect { result.with_failure_fallback }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
              .with_message(exception_message)
          end
        end
      end

      example_group "duplicated calls" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from original result")
            end

            def fallback_failure_result
              success(from: :fallback_failure_result)
            end

            def self.name
              "ImportantService"
            end
          end
        end

        context "when called two times" do
          it "returns fallback result" do
            expect(result.with_failure_fallback.with_failure_fallback).to be_success.with_data(from: :fallback_failure_result)
          end

          it "does not instantiate intermediate results" do
            expect(result.with_failure_fallback).to equal(result.with_failure_fallback.with_failure_fallback)
          end
        end

        context "when called more than two times" do
          it "returns fallback result" do
            expect(result.with_failure_fallback.with_failure_fallback.with_failure_fallback).to be_success.with_data(from: :fallback_failure_result)
          end

          it "does not instantiate intermediate results" do
            expect(result.with_failure_fallback.with_failure_fallback).to equal(result.with_failure_fallback.with_failure_fallback.with_failure_fallback)
          end
        end
      end
    end

    describe "#with_error_fallback" do
      let(:result) { service.result }

      context "when result is success" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(from: :original_result)
            end
          end
        end

        it "returns original result" do
          expect(result.with_error_fallback).to be_success.with_data(from: :original_result)
        end
      end

      context "when result is failure" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_error_fallback).to be_failure.with_message("from original result")
        end
      end

      context "when result is error" do
        context "when service does NOT have `fallback_error_result` method" do
          context "when service does NOT have `fallback_result` method" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  error("from original result")
                end

                def self.name
                  "ImportantService"
                end
              end
            end

            let(:exception_message) do
              <<~TEXT
                Result has NO `error` fallback since neither `fallback_error_result` nor `fallback_result` methods of `ImportantService` are overridden.
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
              expect { result.with_error_fallback }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { result.with_error_fallback } }
                .to delegate_to(ConvenientService, :raise)
            end
          end

          context "when service has `fallback_result` method" do
            context "when that `fallback_result` method is NOT service own method" do
              let(:mod) do
                Module.new do
                  def fallback_result
                    success(from: :inherited_fallback_result)
                  end
                end
              end

              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(mod) do |mod|
                    include ConvenientService::Standard::Config
                    include mod

                    def result
                      error("from original result")
                    end

                    def self.name
                      "ImportantService"
                    end
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  Result has NO `error` fallback since neither `fallback_error_result` nor `fallback_result` methods of `ImportantService` are overridden.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
                expect { result.with_error_fallback }
                  .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { result.with_error_fallback } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end

            context "when that `fallback_result` method is service own method" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    error("from original result")
                  end

                  def fallback_result
                    success(from: :own_fallback_result)
                  end
                end
              end

              it "returns result from own `fallback_result` method" do
                expect(result.with_error_fallback).to be_success.with_data(from: :own_fallback_result)
              end
            end
          end
        end

        context "when service has `fallback_error_result` method" do
          context "when that `fallback_error_result` method is NOT service own method" do
            context "when service does NOT have `fallback_result` method" do
              let(:mod) do
                Module.new do
                  def fallback_error_result
                    success(from: :inherited_fallback_error_result)
                  end
                end
              end

              let(:service) do
                Class.new.tap do |klass|
                  klass.class_exec(mod) do |mod|
                    include ConvenientService::Standard::Config
                    include mod

                    def result
                      error("from original result")
                    end

                    def self.name
                      "ImportantService"
                    end
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  Result has NO `error` fallback since neither `fallback_error_result` nor `fallback_result` methods of `ImportantService` are overridden.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
                expect { result.with_error_fallback }
                  .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { result.with_error_fallback } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end

            context "when service has `fallback_result` method" do
              context "when that `fallback_result` method is NOT service own method" do
                let(:mod) do
                  Module.new do
                    def fallback_error_result
                      success(from: :inherited_fallback_error_result)
                    end

                    def fallback_result
                      success(from: :inherited_fallback_result)
                    end
                  end
                end

                let(:service) do
                  Class.new.tap do |klass|
                    klass.class_exec(mod) do |mod|
                      include ConvenientService::Standard::Config
                      include mod

                      def result
                        error("from original result")
                      end

                      def self.name
                        "ImportantService"
                      end
                    end
                  end
                end

                let(:exception_message) do
                  <<~TEXT
                    Result has NO `error` fallback since neither `fallback_error_result` nor `fallback_result` methods of `ImportantService` are overridden.
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
                  expect { result.with_error_fallback }
                    .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { result.with_error_fallback } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end

              context "when that `fallback_result` method is service own method" do
                let(:mod) do
                  Module.new do
                    def fallback_error_result
                      success(from: :inherited_fallback_error_result)
                    end
                  end
                end

                let(:service) do
                  Class.new.tap do |klass|
                    klass.class_exec(mod) do |mod|
                      include ConvenientService::Standard::Config
                      include mod

                      def result
                        error("from original result")
                      end

                      def fallback_result
                        success(from: :own_fallback_result)
                      end
                    end
                  end
                end

                it "returns result from own `fallback_result` method" do
                  expect(result.with_error_fallback).to be_success.with_data(from: :own_fallback_result)
                end
              end
            end
          end

          context "when that `fallback_error_result` method is service own method" do
            context "when service does NOT have `fallback_result` method" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    error("from original result")
                  end

                  def fallback_error_result
                    success(from: :own_fallback_error_result)
                  end
                end
              end

              it "returns result from own `fallback_error_result` method" do
                expect(result.with_error_fallback).to be_success.with_data(from: :own_fallback_error_result)
              end
            end

            context "when service has `fallback_result` method" do
              context "when that `fallback_result` method is NOT service own method" do
                let(:mod) do
                  Module.new do
                    def fallback_result
                      success(from: :inherited_fallback_result)
                    end
                  end
                end

                let(:service) do
                  Class.new.tap do |klass|
                    klass.class_exec(mod) do |mod|
                      include ConvenientService::Standard::Config
                      include mod

                      def result
                        error("from original result")
                      end

                      def fallback_error_result
                        success(from: :own_fallback_error_result)
                      end
                    end
                  end
                end

                it "returns result from own `fallback_error_result` method" do
                  expect(result.with_error_fallback).to be_success.with_data(from: :own_fallback_error_result)
                end
              end

              context "when that `fallback_result` method is service own method" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      error("from original result")
                    end

                    def fallback_error_result
                      success(from: :own_fallback_error_result)
                    end

                    def fallback_result
                      success(from: :own_fallback_result)
                    end
                  end
                end

                it "returns result from own `fallback_result` method" do
                  expect(result.with_error_fallback).to be_success.with_data(from: :own_fallback_error_result)
                end
              end
            end
          end
        end
      end

      example_group "`raise_when_missing` option" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("from original result")
            end

            def self.name
              "ImportantService"
            end
          end
        end

        context "when `raise_when_missing` option is NOT passed" do
          let(:exception_message) do
            <<~TEXT
              Result has NO `error` fallback since neither `fallback_error_result` nor `fallback_result` methods of `ImportantService` are overridden.
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
            expect { result.with_error_fallback }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { result.with_error_fallback } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `raise_when_missing` option is passed" do
          context "when `raise_when_missing` option is `false`" do
            let(:raise_when_missing) { false }

            it "returns `nil`" do
              expect(result.with_error_fallback(raise_when_missing: raise_when_missing)).to be_nil
            end
          end

          context "when `raise_when_missing` option is `true`" do
            let(:raise_when_missing) { true }

            let(:exception_message) do
              <<~TEXT
                Result has NO `error` fallback since neither `fallback_error_result` nor `fallback_result` methods of `ImportantService` are overridden.
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
              expect { result.with_error_fallback(raise_when_missing: raise_when_missing) }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { result.with_error_fallback(raise_when_missing: raise_when_missing) } }
                .to delegate_to(ConvenientService, :raise)
            end
          end
        end

        example_group "anonymous service" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error("from original result")
              end
            end
          end

          let(:exception_message) do
            <<~TEXT
              Result has NO `error` fallback since neither `fallback_error_result` nor `fallback_result` methods of `#{ConvenientService::Utils::Class.display_name(service)}` are overridden.
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
            expect { result.with_error_fallback }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
              .with_message(exception_message)
          end
        end
      end

      example_group "duplicated calls" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("from original result")
            end

            def fallback_error_result
              success(from: :fallback_error_result)
            end

            def self.name
              "ImportantService"
            end
          end
        end

        context "when called two times" do
          it "returns fallback result" do
            expect(result.with_error_fallback.with_error_fallback).to be_success.with_data(from: :fallback_error_result)
          end

          it "does not instantiate intermediate results" do
            expect(result.with_error_fallback).to equal(result.with_error_fallback.with_error_fallback)
          end
        end

        context "when called more than two times" do
          it "returns fallback result" do
            expect(result.with_error_fallback.with_error_fallback.with_error_fallback).to be_success.with_data(from: :fallback_error_result)
          end

          it "does not instantiate intermediate results" do
            expect(result.with_error_fallback.with_error_fallback).to equal(result.with_error_fallback.with_error_fallback.with_error_fallback)
          end
        end
      end
    end

    describe "#with_failure_and_error_fallback" do
      let(:result) { service.result }

      let(:raise_when_missing) { false }

      context "when result is success" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(from: :original_result)
            end
          end
        end

        it "returns original result" do
          expect(result.with_failure_and_error_fallback).to be_success.with_data(from: :original_result)
        end
      end

      context "when result is failure" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from original result")
            end

            def fallback_result
              success(from: :fallback_result)
            end
          end
        end

        specify do
          expect { result.with_failure_and_error_fallback(raise_when_missing: raise_when_missing) }
            .to delegate_to(result, :with_failure_fallback)
            .with_arguments(raise_when_missing: raise_when_missing)
            .and_return_its_value
        end
      end

      context "when result is error" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("from original result")
            end

            def fallback_result
              success(from: :fallback_result)
            end
          end
        end

        specify do
          expect { result.with_failure_and_error_fallback(raise_when_missing: raise_when_missing) }
            .to delegate_to(result, :with_error_fallback)
            .with_arguments(raise_when_missing: raise_when_missing)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
