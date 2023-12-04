# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Plugins::CanHaveEntries::Commands::DefineEntry do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      subject(:command_result) { described_class.call(feature_class: feature_class, name: name, body: body) }

      let(:feature_class) do
        Class.new do
          include ConvenientService::Feature::Configs::Standard
        end
      end

      let(:feature_instance) { feature_class.new }

      let(:name) { :foo }
      let(:body) { proc { |*args, **kwargs, &block| [__method__, args, kwargs, block] } }

      it "returns `name`" do
        expect(command_result).to eq(name)
      end

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

      context "when class method with `name` on `feature_class` already exist" do
        let(:feature_class) do
          Class.new do
            include ConvenientService::Feature::Configs::Standard

            def self.foo
              :foo
            end
          end
        end

        it "overrides that already existing class method" do
          command_result

          expect(feature_class.foo).to eq([name, [], {}, nil])
        end
      end

      context "when instance method with `name` on `feature_class` already exist" do
        let(:feature_class) do
          Class.new do
            include ConvenientService::Feature::Configs::Standard

            def foo
              :foo
            end
          end
        end

        it "overrides that already existing instance method" do
          command_result

          expect(feature_instance.foo).to eq([name, [], {}, nil])
        end
      end

      example_group "generated class method" do
        it "returns `body` value" do
          command_result

          expect(feature_class.foo).to eq([name, [], {}, nil])
        end

        context "when `body` accepts arguments" do
          let(:args) { [:foo] }
          let(:kwargs) { {foo: :bar} }
          let(:block) { proc { :foo } }

          it "accepts same arguments as `body`" do
            command_result

            expect(feature_class.foo(*args, **kwargs, &block)).to eq([name, args, kwargs, block])
          end
        end
      end

      example_group "generated instance method" do
        it "returns `body` value" do
          command_result

          expect(feature_instance.foo).to eq([name, [], {}, nil])
        end

        context "when `body` accepts arguments" do
          let(:args) { [:foo] }
          let(:kwargs) { {foo: :bar} }
          let(:block) { proc { :foo } }

          it "accepts same arguments as `body`" do
            command_result

            expect(feature_instance.foo(*args, **kwargs, &block)).to eq([name, args, kwargs, block])
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
