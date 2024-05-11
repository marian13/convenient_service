# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Observable::Entities::Event, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:event) { described_class.new(type: type) }
  let(:type) { :before_call }

  let(:observer_class) do
    Class.new do
      def handle_before_call(...)
      end
    end
  end

  let(:observer) { observer_class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(Observable) }
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { event }

      it { is_expected.to have_attr_reader(:type) }
    end

    describe "#default_handler_name" do
      it "returns `handle_\#{type}`" do
        expect(event.default_handler_name).to eq("handle_#{type}")
      end
    end

    describe "#add_observer" do
      context "when `func` is NOT passed" do
        it "defaults to `default_handler_name`" do
          expect { event.add_observer(observer) }.not_to raise_error
        end
      end
    end

    describe "#notify_observers" do
      specify do
        expect { event.notify_observers }
          .to delegate_to(event, :changed)
          .without_arguments
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(event == other).to be_nil
          end
        end

        context "when `other` has different `type`" do
          let(:other) { described_class.new(type: :after_call) }

          it "returns `false`" do
            expect(event == other).to eq(false)
          end
        end

        context "when `other` has different `observers`" do
          let(:other) { described_class.new(type: type).tap { |event| event.add_observer(observer) } }

          it "returns `false`" do
            expect(event == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(type: type) }

          it "returns `true`" do
            expect(event == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
