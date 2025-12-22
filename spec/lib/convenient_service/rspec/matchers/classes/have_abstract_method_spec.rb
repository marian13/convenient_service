# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Classes::HaveAbstractMethod, type: :standard do
  subject(:matcher_result) { matcher.matches?(object) }

  let(:matcher) { described_class.new(method_name) }

  let(:method_name) { :foo }
  let(:object) { klass.new }
  let(:klass) do
    Class.new do
      include ConvenientService::Support::AbstractMethod
    end
  end

  describe "#matches?" do
    context "when call of method does NOT raise" do
      let(:klass) do
        Class.new do
          include ConvenientService::Support::AbstractMethod

          def foo
          end
        end
      end

      it "returns false" do
        expect(matcher_result).to be(false)
      end
    end

    context "when call of method raises" do
      context "when call of method raises NOT `ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden`" do
        let(:klass) do
          Class.new do
            include ConvenientService::Support::AbstractMethod

            def foo
              raise
            end
          end
        end

        it "returns false" do
          expect(matcher_result).to be(false)
        end
      end

      context "when call of method raises `ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden`" do
        let(:klass) do
          Class.new do
            include ConvenientService::Support::AbstractMethod

            abstract_method :foo
          end
        end

        it "returns true" do
          expect(matcher_result).to be(true)
        end
      end
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("have abstract method `#{method_name}`")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected `#{object.class}` to have abstract method `#{method_name}`")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected `#{object.class}` NOT to have abstract method `#{method_name}`")
    end
  end
end
# rubocop:enable RSpec/NestedGroups
