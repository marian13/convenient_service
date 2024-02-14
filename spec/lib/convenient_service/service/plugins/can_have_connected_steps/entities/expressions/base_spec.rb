# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base do
  let(:expression) { described_class.allocate }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::AbstractMethod) }
  end

  example_group "instance methods" do
    example_group "abstract methods" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAbstractMethod

      subject { expression }

      it { is_expected.to have_abstract_method(:initialize) }
      it { is_expected.to have_abstract_method(:result) }
      it { is_expected.to have_abstract_method(:success?) }
      it { is_expected.to have_abstract_method(:failure?) }
      it { is_expected.to have_abstract_method(:error?) }
      it { is_expected.to have_abstract_method(:each_step) }
      it { is_expected.to have_abstract_method(:each_evaluated_step) }
      it { is_expected.to have_abstract_method(:with_organizer) }
      it { is_expected.to have_abstract_method(:inspect) }
    end

    describe "#not?" do
      it "returns `false`" do
        expect(expression.not?).to eq(false)
      end
    end

    describe "#and?" do
      it "returns `false`" do
        expect(expression.and?).to eq(false)
      end
    end

    describe "#or?" do
      it "returns `false`" do
        expect(expression.or?).to eq(false)
      end
    end

    describe "#group?" do
      it "returns `false`" do
        expect(expression.group?).to eq(false)
      end
    end

    describe "#empty?" do
      it "returns `false`" do
        expect(expression.empty?).to eq(false)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
