# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Structs::IntendedMethod, type: :standard do
  example_group "instance methods" do
    describe "#==" do
      let(:method) { :result }
      let(:scope) { :instance }
      let(:entity) { :service }

      let(:intented_method) { described_class.new(method, scope, entity) }

      context "when `other` has different `method`" do
        let(:other) { described_class.new(:initialize, scope, entity) }

        it "returns `false`" do
          expect(intented_method == other).to eq(false)
        end
      end

      context "when `other` has different `scope`" do
        let(:other) { described_class.new(method, :class, entity) }

        it "returns `false`" do
          expect(intented_method == other).to eq(false)
        end
      end

      context "when `other` has different `entity`" do
        let(:other) { described_class.new(method, scope, :result) }

        it "returns `false`" do
          expect(intented_method == other).to eq(false)
        end
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(method, scope, entity) }

        it "returns `true`" do
          expect(intented_method == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
