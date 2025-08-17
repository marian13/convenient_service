# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Commands::DefineMethodCallers, type: :standard do
  let(:command_result) { command_instance.call }
  let(:command_instance) { described_class.new(scope: scope, method: method, container: container, caller: caller) }

  let(:scope) { :instance }
  let(:method) { :result }
  let(:method_without_middlewares) { :result_without_middlewares }

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
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { command_instance }

    it { is_expected.to have_attr_reader(:scope) }
    it { is_expected.to have_attr_reader(:method) }
    it { is_expected.to have_attr_reader(:container) }
    it { is_expected.to have_attr_reader(:caller) }
  end

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # example_group "delegators" do
  #   include Shoulda::Matchers::Independent
  #
  #   subject { command_instance }
  #
  #   it { is_expected.to delegate_method(:prefix).to(:caller) }
  # end

  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::PrependModule

      context "when `scope` is `:instance`" do
        let(:scope) { :instance }
        let(:container) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container.new(klass: klass) }

        context "when `method` caller (with middlewares) is NOT defined in methods callers" do
          it "synchronize method definitions by lock" do
            allow(container.lock).to receive(:synchronize).and_call_original

            command_result

            expect(container.lock).to have_received(:synchronize)
          end

          it "prepend methods callers to container" do
            command_result

            expect(container.klass).to prepend_module(methods_middlewares_callers)
          end

          it "defines `method` caller (with middlewares)" do
            expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method, methods_middlewares_callers, private: true) }.from(false).to(true)
          end

          it "defines `method` caller without middlewares" do
            expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method_without_middlewares, methods_middlewares_callers, private: true) }.from(false).to(true)
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end

          context "when `method` name ends with `!`" do
            let(:method) { :result! }
            let(:method_without_middlewares) { :result_without_middlewares! }

            it "defines `method` caller without middlewares placing `!` after `without_middlewares` suffix" do
              expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method_without_middlewares, methods_middlewares_callers, private: true) }.from(false).to(true)
            end
          end

          context "when `method` name ends with `?`" do
            let(:method) { :success? }
            let(:method_without_middlewares) { :success_without_middlewares? }

            it "defines `method` caller without middlewares placing `?` after `without_middlewares` suffix" do
              expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method_without_middlewares, methods_middlewares_callers, private: true) }.from(false).to(true)
            end
          end
        end

        context "when `method` caller (with middlewares) is defined in methods callers" do
          before do
            methods_middlewares_callers.define_method(method) {}
          end

          it "synchronize method definitions by lock" do
            allow(container.lock).to receive(:synchronize).and_call_original

            command_result

            expect(container.lock).to have_received(:synchronize)
          end

          it "returns `false`" do
            expect(command_result).to eq(false)
          end

          ##
          # NOTE: `prepend_methods_callers_to_container` is only called before defining. So if it is NOT called then NO redefinition happened.
          #
          it "does NOT redefines `method` callers" do
            allow(container).to receive(:prepend_methods_callers_to_container).and_call_original

            command_result

            expect(container).not_to have_received(:prepend_methods_callers_to_container)
          end
        end

        example_group "generated `method` caller (with middlewares)" do
          let(:service_instance) { service_class.new }

          context "when super is NOT defined" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                middlewares(:result, scope: :instance) do
                  middleware = Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) do
                    def next(...)
                      [:middleware_value, *chain.next(...)]
                    end
                  end

                  use middleware
                end
              end
            end

            ##
            # NOTE: Ruby 3.4 changes exception messages and backtrace displays.
            # - https://www.ruby-lang.org/en/news/2024/05/16/ruby-3-4-0-preview1-released
            #
            # NOTE: Depending on the `did_you_mean` version, an additional line may be added to the exception message, which is why the `with_message` string is replaced by regex.
            #
            # rubocop:disable RSpec/RepeatedDescription
            if ConvenientService::Dependencies.ruby.version >= 3.4
              it "raises `NoMethodError`" do
                expect { service_instance.result }.to raise_error(NoMethodError).with_message(/super: no superclass method 'result' for an instance of #{service_instance.class}/)
              end
            elsif ConvenientService::Dependencies.ruby.version >= 3.3
              it "raises `NoMethodError`" do
                expect { service_instance.result }.to raise_error(NoMethodError).with_message(/super: no superclass method `result' for an instance of #{service_instance.class}/)
              end
            else
              it "raises `NoMethodError`" do
                expect { service_instance.result }.to raise_error(NoMethodError).with_message(/super: no superclass method `result' for #{service_instance}/)
              end
            end
          end

          context "when super is defined" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                middlewares(:result, scope: :instance) do
                  middleware = Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) do
                    def next(...)
                      [:middleware_value, *chain.next(...)]
                    end
                  end

                  use middleware
                end

                def result
                  :original_value
                end
              end
            end

            it "calls middlewares and super" do
              expect(service_instance.result).to eq([:middleware_value, :original_value])
            end
          end
        end

        example_group "generated `method` caller without middlewares" do
          let(:service_instance) { service_class.new }

          context "when super is NOT defined" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                middlewares(:result, scope: :instance) do
                  middleware = Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) do
                    def next(...)
                      [:middleware_value, *chain.next(...)]
                    end
                  end

                  use middleware
                end
              end
            end

            ##
            # NOTE: Ruby 3.4 changes exception messages and backtrace displays.
            # - https://www.ruby-lang.org/en/news/2024/05/16/ruby-3-4-0-preview1-released
            #
            # NOTE: Depending on the `did_you_mean` version, an additional line may be added to the exception message, which is why the `with_message` string is replaced by regex.
            #
            # rubocop:disable RSpec/RepeatedDescription
            if ConvenientService::Dependencies.ruby.version >= 3.4
              it "raises `NoMethodError`" do
                expect { service_instance.result_without_middlewares }.to raise_error(NoMethodError).with_message(/super: no superclass method 'result' for an instance of #{service_instance.class}/)
              end
            elsif ConvenientService::Dependencies.ruby.version >= 3.3
              it "raises `NoMethodError`" do
                expect { service_instance.result_without_middlewares }.to raise_error(NoMethodError).with_message(/super: no superclass method `result' for an instance of #{service_instance.class}/)
              end
            else
              it "raises `NoMethodError`" do
                expect { service_instance.result_without_middlewares }.to raise_error(NoMethodError).with_message(/super: no superclass method `result' for #{service_instance}/)
              end
            end
          end

          context "when super is defined" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                middlewares(:result, scope: :instance) do
                  middleware = Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) do
                    def next(...)
                      [:middleware_value, *chain.next(...)]
                    end
                  end

                  use middleware
                end

                def result
                  :original_value
                end
              end
            end

            it "calls middlewares and super" do
              expect(service_instance.result_without_middlewares).to eq(:original_value)
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

          it "prepend methods callers to container" do
            command_result

            expect(container.klass).to prepend_module(methods_middlewares_callers)
          end

          it "defines `method` caller (with middlewares)" do
            expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method, methods_middlewares_callers, private: true) }.from(false).to(true)
          end

          it "defines `method` caller without middlewares" do
            expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method_without_middlewares, methods_middlewares_callers, private: true) }.from(false).to(true)
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end

          context "when `method` name ends with `!`" do
            let(:method) { :result! }
            let(:method_without_middlewares) { :result_without_middlewares! }

            it "defines `method` caller without middlewares placing `!` after `without_middlewares` suffix" do
              expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method_without_middlewares, methods_middlewares_callers, private: true) }.from(false).to(true)
            end
          end

          context "when `method` name ends with `?`" do
            let(:method) { :success? }
            let(:method_without_middlewares) { :success_without_middlewares? }

            it "defines `method` caller without middlewares placing `?` after `without_middlewares` suffix" do
              expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method_without_middlewares, methods_middlewares_callers, private: true) }.from(false).to(true)
            end
          end
        end

        context "when `method` caller (with middlewares) is defined in methods callers" do
          before do
            methods_middlewares_callers.define_method(method) {}
          end

          it "synchronize method definitions by lock" do
            allow(container.lock).to receive(:synchronize).and_call_original

            command_result

            expect(container.lock).to have_received(:synchronize)
          end

          it "returns `false`" do
            expect(command_result).to eq(false)
          end

          ##
          # NOTE: `prepend_methods_callers_to_container` is only called before defining. So if it is NOT called then NO redefinition happened.
          #
          it "does NOT redefines `method` callers" do
            allow(container).to receive(:prepend_methods_callers_to_container).and_call_original

            command_result

            expect(container).not_to have_received(:prepend_methods_callers_to_container)
          end
        end

        example_group "generated `method` caller (with middlewares)" do
          context "when super is NOT defined" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                middlewares(:result, scope: :class) do
                  middleware = Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) do
                    def next(...)
                      [:middleware_value, *chain.next(...)]
                    end
                  end

                  use middleware
                end
              end
            end

            ##
            # NOTE: Ruby 3.4 changes exception messages and backtrace displays.
            # - https://www.ruby-lang.org/en/news/2024/05/16/ruby-3-4-0-preview1-released
            #
            # NOTE: Depending on the `did_you_mean` version, an additional line may be added to the exception message, which is why the `with_message` string is replaced by regex.
            #
            # rubocop:disable RSpec/RepeatedDescription
            if ConvenientService::Dependencies.ruby.version >= 3.4
              it "raises `NoMethodError`" do
                expect { service_class.result }.to raise_error(NoMethodError).with_message(/super: no superclass method 'result' for class #{service_class}/)
              end
            elsif ConvenientService::Dependencies.ruby.version >= 3.3
              it "raises `NoMethodError`" do
                expect { service_class.result }.to raise_error(NoMethodError).with_message(/super: no superclass method `result' for class #{service_class}/)
              end
            else
              it "raises `NoMethodError`" do
                expect { service_class.result }.to raise_error(NoMethodError).with_message(/super: no superclass method `result' for #{service_class}/)
              end
            end
            # rubocop:enable RSpec/RepeatedDescription
          end

          context "when super is defined" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                middlewares(:result, scope: :class) do
                  middleware = Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) do
                    def next(...)
                      [:middleware_value, *chain.next(...)]
                    end
                  end

                  use middleware
                end

                class << self
                  def result
                    :original_value
                  end
                end
              end
            end

            it "calls middlewares and super" do
              expect(service_class.result).to eq([:middleware_value, :original_value])
            end
          end
        end

        example_group "generated `method` caller without middlewares" do
          context "when super is NOT defined" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                middlewares(:result, scope: :class) do
                  middleware = Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) do
                    def next(...)
                      [:middleware_value, *chain.next(...)]
                    end
                  end

                  use middleware
                end
              end
            end

            ##
            # NOTE: Ruby 3.4 changes exception messages and backtrace displays.
            # - https://www.ruby-lang.org/en/news/2024/05/16/ruby-3-4-0-preview1-released
            #
            # NOTE: Depending on the `did_you_mean` version, an additional line may be added to the exception message, which is why the `with_message` string is replaced by regex.
            #
            # rubocop:disable RSpec/RepeatedDescription
            if ConvenientService::Dependencies.ruby.version >= 3.4
              it "raises `NoMethodError`" do
                expect { service_class.result_without_middlewares }.to raise_error(NoMethodError).with_message(/super: no superclass method 'result' for class #{service_class}/)
              end
            elsif ConvenientService::Dependencies.ruby.version >= 3.3
              it "raises `NoMethodError`" do
                expect { service_class.result_without_middlewares }.to raise_error(NoMethodError).with_message(/super: no superclass method `result' for class #{service_class}/)
              end
            else
              it "raises `NoMethodError`" do
                expect { service_class.result_without_middlewares }.to raise_error(NoMethodError).with_message(/super: no superclass method `result' for #{service_class}/)
              end
            end
            # rubocop:enable RSpec/RepeatedDescription
          end

          context "when super is defined" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                middlewares(:result, scope: :class) do
                  middleware = Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) do
                    def next(...)
                      [:middleware_value, *chain.next(...)]
                    end
                  end

                  use middleware
                end

                class << self
                  def result
                    :original_value
                  end
                end
              end
            end

            it "calls middlewares and super" do
              expect(service_class.result_without_middlewares).to eq(:original_value)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
