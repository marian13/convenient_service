# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::DefineEntry do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      subject(:command_result) { described_class.call(container: container, name: name, body: body) }

      let(:container) { Module.new }

      let(:name) { :foo }
      let(:body) { proc { |*args, **kwargs, &block| [__method__, args, kwargs, block] } }

      it "returns `name`" do
        expect(command_result).to eq(name)
      end

      it "defines class method with `name` on `container`" do
        ##
        # NOTE: `false` in `methods(false)` means own methods.
        # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-methods
        #
        expect { command_result }.to change { container.methods(false).include?(name.to_sym) }.from(false).to(true)
      end

      context "when class method with `name` on `container` already exist" do
        let(:container) do
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

          expect(container.foo).to eq([name, [], {}, nil])
        end
      end

      example_group "generated method" do
        it "returns `body` value" do
          command_result

          expect(container.foo).to eq([name, [], {}, nil])
        end

        context "when `body` accepts arguments" do
          let(:args) { [:foo] }
          let(:kwargs) { {foo: :bar} }
          let(:block) { proc { :foo } }

          it "accepts same arguments as `body`" do
            command_result

            expect(container.foo(*args, **kwargs, &block)).to eq([name, args, kwargs, block])
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
