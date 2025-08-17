# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:expression) { described_class.allocate }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::AbstractMethod) }
    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "instance methods" do
    example_group "abstract methods" do
      include ConvenientService::RSpec::Matchers::HaveAbstractMethod

      subject { expression }

      it { is_expected.to have_abstract_method(:initialize) }
      it { is_expected.to have_abstract_method(:result) }
      it { is_expected.to have_abstract_method(:organizer) }
      it { is_expected.to have_abstract_method(:success?) }
      it { is_expected.to have_abstract_method(:failure?) }
      it { is_expected.to have_abstract_method(:error?) }
      it { is_expected.to have_abstract_method(:each_step) }
      it { is_expected.to have_abstract_method(:each_evaluated_step) }
      it { is_expected.to have_abstract_method(:with_organizer) }
      it { is_expected.to have_abstract_method(:inspect) }
      it { is_expected.to have_abstract_method(:==) }
      it { is_expected.to have_abstract_method(:to_arguments) }
    end

    describe "#steps" do
      let(:expression_class) do
        Class.new(described_class) do
          def each_step(&block)
            yield("first step")
            yield("second step")
            yield("third step")

            self
          end
        end
      end

      let(:expression) { expression_class.allocate }

      it "returns `steps` received from `each_step`" do
        expect(expression.steps).to eq(["first step", "second step", "third step"])
      end

      specify do
        expect { expression.steps }.to delegate_to(expression, :each_step)
      end
    end

    describe "#scalar?" do
      it "returns `false`" do
        expect(expression.scalar?).to eq(false)
      end
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

    describe "#if?" do
      it "returns `false`" do
        expect(expression.if?).to eq(false)
      end
    end

    describe "#else?" do
      it "returns `false`" do
        expect(expression.else?).to eq(false)
      end
    end

    describe "#complex_if?" do
      it "returns `false`" do
        expect(expression.complex_if?).to eq(false)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
