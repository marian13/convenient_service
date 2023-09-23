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

      context "when class method with `name` on `feature_class` already exist" do
        let(:feature_class) do
          Module.new do
            class << self
              def foo
                :foo
              end
            end
          end
        end

        it "overrides that already existing class method" do
          command_result

          expect(feature_class.foo).to eq([name, [], {}, nil])
        end
      end

      example_group "generated method" do
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
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
