# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::String::Camelize, type: :standard do
  describe ".call" do
    context "when `capitalize_first_letter` is NOT passed" do
      subject(:util_result) { described_class.call(string) }

      context "when string do NOT contain any special chars" do
        let(:string) { "foo" }

        it "returns camelized string with uppercased first letter" do
          expect(util_result).to eq("Foo")
        end
      end

      context "when string contains colon" do
        let(:string) { "foo:bar" }

        it "returns camelized string with uppercased first letter" do
          expect(util_result).to eq("FooBar")
        end
      end

      context "when string contains underscore" do
        let(:string) { "foo_bar" }

        it "returns camelized string with uppercased first letter" do
          expect(util_result).to eq("FooBar")
        end
      end

      context "when string contains question mark" do
        let(:string) { "foo?" }

        it "returns camelized string with uppercased first letter" do
          expect(util_result).to eq("Foo")
        end
      end

      context "when string contains exclamation mark" do
        let(:string) { "foo!" }

        it "returns camelized string with uppercased first letter" do
          expect(util_result).to eq("Foo")
        end
      end

      context "when string contains dash" do
        let(:string) { "foo-bar" }

        it "returns camelized string with uppercased first letter" do
          expect(util_result).to eq("FooBar")
        end
      end

      context "when string contains space" do
        let(:string) { "foo bar" }

        it "returns camelized string with uppercased first letter" do
          expect(util_result).to eq("FooBar")
        end
      end

      context "when string contains doubled delimiter" do
        let(:string) { "foo!!bar" }

        it "returns camelized string with uppercased first letter" do
          expect(util_result).to eq("FooBar")
        end
      end

      context "when string contains uppercase letter" do
        let(:string) { "bAr" }

        ##
        # NOTE: Does NOT modifies that uppercase letter.
        # https://textedit.tools/camelcase
        #
        it "returns camelized string with uppercased first letter" do
          expect(util_result).to eq("BAr")
        end
      end
    end

    context "when `capitalize_first_letter` is passed" do
      subject(:util_result) { described_class.call(string, capitalize_first_letter: capitalize_first_letter) }

      context "when `capitalize_first_letter` is `false`" do
        let(:capitalize_first_letter) { false }

        context "when string do NOT contain any special chars" do
          let(:string) { "foo" }

          it "returns camelized string with lowercased first letter" do
            expect(util_result).to eq("foo")
          end
        end

        context "when string contains colon" do
          let(:string) { "foo:bar" }

          it "returns camelized string with lowercased first letter" do
            expect(util_result).to eq("fooBar")
          end
        end

        context "when string contains underscore" do
          let(:string) { "foo_bar" }

          it "returns camelized string with lowercased first letter" do
            expect(util_result).to eq("fooBar")
          end
        end

        context "when string contains question mark" do
          let(:string) { "foo?" }

          it "returns camelized string with lowercased first letter" do
            expect(util_result).to eq("foo")
          end
        end

        context "when string contains exclamation mark" do
          let(:string) { "foo!" }

          it "returns camelized string with lowercased first letter" do
            expect(util_result).to eq("foo")
          end
        end

        context "when string contains dash" do
          let(:string) { "foo-bar" }

          it "returns camelized string with lowercased first letter" do
            expect(util_result).to eq("fooBar")
          end
        end

        context "when string contains space" do
          let(:string) { "foo bar" }

          it "returns camelized string with lowercased first letter" do
            expect(util_result).to eq("fooBar")
          end
        end

        context "when string contains doubled delimiter" do
          let(:string) { "foo!!bar" }

          it "returns camelized string with uppercased first letter" do
            expect(util_result).to eq("fooBar")
          end
        end

        context "when string contains uppercase letter" do
          let(:string) { "bAr" }

          ##
          # NOTE: Does NOT modifies that uppercase letter.
          # https://textedit.tools/camelcase
          #
          it "returns camelized string with lowercased first letter" do
            expect(util_result).to eq("bAr")
          end
        end
      end

      context "when `capitalize_first_letter` is `true`" do
        let(:capitalize_first_letter) { true }

        context "when string do NOT contain any special chars" do
          let(:string) { "foo" }

          it "returns camelized string with uppercased first letter" do
            expect(util_result).to eq("Foo")
          end
        end

        context "when string contains colon" do
          let(:string) { "foo:bar" }

          it "returns camelized string with uppercased first letter" do
            expect(util_result).to eq("FooBar")
          end
        end

        context "when string contains underscore" do
          let(:string) { "foo_bar" }

          it "returns camelized string with uppercased first letter" do
            expect(util_result).to eq("FooBar")
          end
        end

        context "when string contains question mark" do
          let(:string) { "foo?" }

          it "returns camelized string with uppercased first letter" do
            expect(util_result).to eq("Foo")
          end
        end

        context "when string contains exclamation mark" do
          let(:string) { "foo!" }

          it "returns camelized string with uppercased first letter" do
            expect(util_result).to eq("Foo")
          end
        end

        context "when string contains dash" do
          let(:string) { "foo-bar" }

          it "returns camelized string with uppercased first letter" do
            expect(util_result).to eq("FooBar")
          end
        end

        context "when string contains space" do
          let(:string) { "foo bar" }

          it "returns camelized string with uppercased first letter" do
            expect(util_result).to eq("FooBar")
          end
        end

        context "when string contains doubled delimiter" do
          let(:string) { "foo!!bar" }

          it "returns camelized string with uppercased first letter" do
            expect(util_result).to eq("FooBar")
          end
        end

        context "when string contains uppercase letter" do
          let(:string) { "bAr" }

          ##
          # NOTE: Does NOT modifies that uppercase letter.
          # https://textedit.tools/camelcase
          #
          it "returns camelized string with uppercased first letter" do
            expect(util_result).to eq("BAr")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
