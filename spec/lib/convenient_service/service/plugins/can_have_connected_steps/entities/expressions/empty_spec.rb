# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Empty do
  let(:expression) { described_class.new }

  let(:container) do
    Class.new do
      include ConvenientService::Service::Configs::Minimal
    end
  end

  let(:organizer) { container.new }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base) }
  end

  example_group "class methods" do
    describe ".new" do
      it "is overridden" do
        expect { described_class.new }.not_to raise_error
      end
    end
  end

  example_group "instance methods" do
    describe "#result" do
      let(:exception_message) do
        <<~TEXT
          Empty expression has NO result.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoResult`" do
        expect { expression.result }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoResult)
          .with_message(exception_message)
      end
    end

    describe "#success?" do
      let(:exception_message) do
        <<~TEXT
          Empty expression has NO status.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoStatus`" do
        expect { expression.success? }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoStatus)
          .with_message(exception_message)
      end
    end

    describe "#failure?" do
      let(:exception_message) do
        <<~TEXT
          Empty expression has NO status.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoStatus`" do
        expect { expression.failure? }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoStatus)
          .with_message(exception_message)
      end
    end

    describe "#error?" do
      let(:exception_message) do
        <<~TEXT
          Empty expression has NO status.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoStatus`" do
        expect { expression.error? }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoStatus)
          .with_message(exception_message)
      end
    end

    describe "#each_step" do
      let(:block) { proc { :foo } }

      it "returns `expression`" do
        expect(expression.each_step(&block)).to eq(expression)
      end
    end

    describe "#each_evaluated_step" do
      let(:block) { proc { :foo } }

      it "returns `expression`" do
        expect(expression.each_evaluated_step(&block)).to eq(expression)
      end
    end

    describe "#with_organizer" do
      it "returns `expression`" do
        expect(expression.with_organizer(organizer)).to eq(expression)
      end
    end

    describe "#inspect" do
      it "returns empty string" do
        expect(expression.inspect).to eq("")
      end
    end

    describe "#empty?" do
      it "returns `true`" do
        expect(expression.empty?).to eq(true)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:expression) { described_class.new }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(expression == other).to be_nil
          end
        end

        context "when `other` has same class" do
          let(:other) { described_class.new }

          it "returns `true`" do
            expect(expression == other).to eq(true)
          end
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new }

      describe "#to_arguments" do
        it "returns arguments representation of caller" do
          expect(expression.to_arguments).to eq(arguments)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
