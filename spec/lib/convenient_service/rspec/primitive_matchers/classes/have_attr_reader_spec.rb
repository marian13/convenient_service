# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::HaveAttrReader, type: :standard do
  subject(:matcher_result) { matcher.matches?(object) }

  let(:matcher) { described_class.new(attr_name) }

  let(:attr_name) { :foo }
  let(:object) { klass.new }
  let(:klass) { Class.new }

  describe "#matches?" do
    context "when `object` does NOT have `method`" do
      let(:klass) { Class.new }

      it "returns `false`" do
        expect(matcher_result).to eq(false)
      end
    end

    context "when `object` has `method`" do
      context "when that `method` does NOT return corresponding instance variable value" do
        let(:klass) do
          Class.new do
            def foo
              :foo
            end
          end
        end

        it "returns `false`" do
          expect(matcher_result).to eq(false)
        end
      end

      context "when that `method` returns corresponding instance variable value" do
        context "when that `method` defined explicitly" do
          let(:klass) do
            Class.new do
              attr_reader :foo
            end
          end

          it "returns `true`" do
            expect(matcher_result).to eq(true)
          end
        end

        context "when that `method` defined `attr_reader`" do
          let(:klass) do
            Class.new do
              attr_reader :foo
            end
          end

          it "returns `true`" do
            expect(matcher_result).to eq(true)
          end
        end
      end
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("have attr reader `#{attr_name}`")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected `#{object.class}` to have attr reader `#{attr_name}`")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected `#{object.class}` NOT to have attr reader `#{attr_name}`")
    end
  end
end
# rubocop:enable RSpec/NestedGroups
