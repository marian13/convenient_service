# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  let(:result_unmock) { described_class.new(service_class: service_class, arguments: arguments) }

  let(:status) { :success }

  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end
    end
  end

  let(:arguments) { ConvenientService::Support::Arguments.new(:foo, {foo: :bar}) { :foo } }

  let(:data) { {foo: :bar} }
  let(:message) { "foo" }
  let(:code) { :foo }

  example_group "class methods" do
    describe ".new" do
      context "when service class is NOT passed" do
        it "defaults to `nil`" do
          expect(described_class.new(arguments: arguments)).to eq(described_class.new(service_class: nil, arguments: arguments))
        end
      end

      context "when arguments are NOT passed" do
        it "defaults to `nil`" do
          expect(described_class.new(service_class: service_class)).to eq(described_class.new(service_class: service_class, arguments: nil))
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#for" do
      let(:other_service_class) { Class.new }
      let(:other_arguments) { ConvenientService::Support::Arguments.new(:bar, {bar: :baz}) { :bar } }

      it "returns result mock copy with passed service class and arguments" do
        expect(result_unmock.for(other_service_class, other_arguments)).to eq(described_class.new(service_class: other_service_class, arguments: other_arguments))
      end
    end

    describe "#register" do
      specify do
        expect { result_unmock.register }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::DeleteServiceStubbedResult, :call)
            .with_arguments(service: service_class, arguments: arguments)
            .and_return { result_unmock }
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(result_unmock == other).to be_nil
          end
        end

        context "when `other` has different `service_class`" do
          let(:other) { described_class.new(service_class: Class.new, arguments: arguments) }

          it "returns `false`" do
            expect(result_unmock == other).to be(false)
          end
        end

        context "when `other` has different `arguments`" do
          let(:other) { described_class.new(service_class: service_class, arguments: ConvenientService::Support::Arguments.null_arguments) }

          it "returns `false`" do
            expect(result_unmock == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(service_class: service_class, arguments: arguments) }

          it "returns `true`" do
            expect(result_unmock == other).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
