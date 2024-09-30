# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Plugins::CanHaveEntries::Commands::DefineEntry, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(feature_class: feature_class, name: name, body: body) }

      let(:feature_class) do
        Class.new do
          include ConvenientService::Feature::Configs::Standard
        end
      end

      let(:feature_instance) { feature_class.new }

      let(:name) { :main }
      let(:body) { proc { |*args, **kwargs, &block| :foo } }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { |*args, **kwargs, &block| [:foo, args, kwargs, block] } }

      it "defines class method with `name` on `feature_class`" do
        ##
        # NOTE: `false` in `methods(false)` means own methods.
        # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-methods
        #
        expect { command_result }.to change { feature_class.methods(false).include?(name.to_sym) }.from(false).to(true)
      end

      it "defines instance method with `name` on `feature_class`" do
        ##
        # NOTE: `false` in `instance_methods(false)` means own methods.
        # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-methods
        #
        expect { command_result }.to change { feature_class.instance_methods(false).include?(name.to_sym) }.from(false).to(true)
      end

      it "defines instance method with `name` on `feature_class.instance_proxy_class`" do
        ##
        # NOTE: `false` in `methods(false)` means own methods.
        # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-methods
        #
        expect { command_result }.to change { feature_class.instance_proxy_class.instance_methods(false).include?(name.to_sym) }.from(false).to(true)
      end

      it "defines `entry` instance method on `feature_class.instance_proxy_class`" do
        ##
        # NOTE: `false` in `methods(false)` means own methods.
        # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-methods
        #
        expect { command_result }.to change { feature_class.instance_proxy_class.instance_methods(false).include?(:trigger) }.from(false).to(true)
      end

      it "returns `name`" do
        expect(command_result).to eq(name)
      end

      context "when class method with `name` on `feature_class` already defined before entry" do
        let(:feature_class) do
          Class.new do
            include ConvenientService::Feature::Configs::Standard

            def self.main(*args, **kwargs, &block)
              :main_entry_value
            end
          end
        end

        it "overrides that already defined before entry class method" do
          command_result

          expect(feature_class.main(*args, **kwargs, &block)).to eq(body.call(*args, **kwargs, &block))
        end
      end

      context "when class method with `name` on `feature_class` already defined after entry" do
        # rubocop:disable RSpec/ExampleLength
        it "does NOT override that already defined after entry class method" do
          command_result

          feature_class.class_exec do
            def self.main(*args, **kwargs, &block)
              :main_entry_value
            end
          end

          expect(feature_class.main(*args, **kwargs, &block)).to eq(:main_entry_value)
        end
        # rubocop:enable RSpec/ExampleLength
      end

      context "when instance method with `name` on `feature_class` already defined before entry" do
        let(:feature_class) do
          Class.new do
            include ConvenientService::Feature::Configs::Standard

            def main(*args, **kwargs, &block)
              :main_entry_value
            end
          end
        end

        it "overrides that already defined before entry instance method" do
          command_result

          expect(feature_class.main(*args, **kwargs, &block)).to eq(body.call(*args, **kwargs, &block))
        end
      end

      context "when instance method with `name` on `feature_class` already defined after entry" do
        # rubocop:disable RSpec/ExampleLength
        it "does NOT override that already defined after entry instance method" do
          command_result

          feature_class.class_exec do
            def main(*args, **kwargs, &block)
              :main_entry_value
            end
          end

          expect(feature_instance.main(*args, **kwargs, &block)).to eq(:main_entry_value)
        end
        # rubocop:enable RSpec/ExampleLength
      end

      example_group "generated class method" do
        specify do
          allow(feature_class).to receive(:new).and_return(feature_instance)

          command_result

          expect { feature_class.main(*args, **kwargs, &block) }
            .to delegate_to(feature_instance, :trigger)
            .with_arguments(name, *args, **kwargs, &block)
        end
      end

      example_group "generated instance method" do
        context "when `body` is `nil`" do
          let(:body) { nil }

          let(:exception_message) do
            <<~TEXT
              Entry for `#{name}` is registered inside `#{feature_class}` feature, but its corresponding method is NOT defined.

              Did you forget to define it? For example, using method form:

              class #{feature_class}
                entry :#{name}

                # ...

                def #{name}(...)
                  # ...
                end

                # ...
              end

              Or using block form:

              class #{feature_class}
                entry :#{name} do |*args, **kwargs, &block|
                  # ...
                end

                # ...
              end
            TEXT
          end

          it "raises `ConvenientService::Feature::Plugins::CanHaveEntries::Exceptions::NotDefinedEntryMethod`" do
            command_result

            expect { feature_instance.main(*args, **kwargs, &block) }
              .to raise_error(ConvenientService::Feature::Plugins::CanHaveEntries::Exceptions::NotDefinedEntryMethod)
              .with_message(exception_message)
          end

          specify do
            command_result

            expect { ignoring_exception(ConvenientService::Feature::Plugins::CanHaveEntries::Exceptions::NotDefinedEntryMethod) { feature_instance.main(*args, **kwargs, &block) } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `body` is proc" do
          let(:body) { proc { |*args, **kwargs, &block| [__method__, args, kwargs, block] } }

          it "returns `body` value" do
            command_result

            expect(feature_instance.main(*args, **kwargs, &block)).to eq([name, args, kwargs, block])
          end
        end
      end

      example_group "generated instance proxy instance method" do
        specify do
          command_result

          expect { feature_instance.main(*args, **kwargs, &block) }
            .to delegate_to(feature_instance.instance_proxy_target, :trigger)
            .with_arguments(name, *args, **kwargs, &block)
        end
      end

      example_group "generated instance proxy `entry` instance method" do
        specify do
          command_result

          expect { feature_instance.trigger(name, *args, **kwargs, &block) }
            .to delegate_to(feature_instance.instance_proxy_target, :trigger)
            .with_arguments(name, *args, **kwargs, &block)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
