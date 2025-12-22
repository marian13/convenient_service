# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Classes::HaveAttrWriter, type: :standard do
  subject(:matcher_result) { matcher.matches?(object) }

  let(:matcher) { described_class.new(method) }

  let(:method) { :foo }
  let(:object) { klass.new }
  let(:klass) { Class.new }

  describe "#matches?" do
    context "when `object` does NOT have `method`" do
      let(:klass) { Class.new }

      it "returns `false`" do
        expect(matcher_result).to be(false)
      end
    end

    context "when `object` has `method`" do
      context "when that `method` does NOT set and return corresponding instance variable value" do
        let(:klass) do
          Class.new do
            def foo=(value)
              :foo
            end
          end
        end

        it "returns `false`" do
          expect(matcher_result).to be(false)
        end
      end

      context "when that `method` does NOT set but return corresponding instance variable value" do
        let(:klass) do
          Class.new do
            def foo=(value)
              value
            end
          end
        end

        it "returns `false`" do
          expect(matcher_result).to be(false)
        end
      end

      context "when that `method` sets and returns corresponding instance variable value" do
        context "when that `method` defined explicitly" do
          let(:klass) do
            Class.new do
              # rubocop:disable Style/TrivialAccessors
              def foo=(value)
                @foo = value
              end
              # rubocop:enable Style/TrivialAccessors
            end
          end

          it "returns `true`" do
            expect(matcher_result).to be(true)
          end
        end

        context "when that `method` defined `attr_writer`" do
          let(:klass) do
            Class.new do
              attr_writer :foo
            end
          end

          it "returns `true`" do
            expect(matcher_result).to be(true)
          end
        end

        context "when that `method` defined `attr` with `true`" do
          let(:klass) do
            Class.new do
              # rubocop:disable Lint/DeprecatedClassMethods
              attr :foo, true
              # rubocop:enable Lint/DeprecatedClassMethods
            end
          end

          it "returns `true`" do
            expect(matcher_result).to be(true)
          end
        end
      end
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("have attr writer `#{method}`")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected `#{object.class}` to have attr writer `#{method}`")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected `#{object.class}` NOT to have attr writer `#{method}`")
    end
  end
end
# rubocop:enable RSpec/NestedGroups
