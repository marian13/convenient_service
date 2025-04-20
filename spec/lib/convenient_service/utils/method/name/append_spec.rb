# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Method::Name::Append, type: :standard do
  example_group "class methods" do
    describe ".call" do
      let(:util_result) { described_class.call(method_name, suffix) }

      context "when `method_name` is `nil`" do
        let(:method_name) { nil }

        context "when `suffix` is `nil`" do
          let(:suffix) { nil }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end

        context "when `suffix` is empty string" do
          let(:suffix) { "" }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end

        context "when `suffix` is empty symbol" do
          let(:suffix) { :"" }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end

        context "when `suffix` is symbol" do
          let(:suffix) { :_before_out_redefinition }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end

        context "when `suffix` is string" do
          let(:suffix) { "_before_out_redefinition" }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end
      end

      context "when `method_name` is empty symbol" do
        let(:method_name) { :"" }

        context "when `suffix` is `nil`" do
          let(:suffix) { nil }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end

        context "when `suffix` is empty string" do
          let(:suffix) { "" }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end

        context "when `suffix` is empty symbol" do
          let(:suffix) { :"" }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end

        context "when `suffix` is symbol" do
          let(:suffix) { :_before_out_redefinition }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end

        context "when `suffix` is string" do
          let(:suffix) { "_before_out_redefinition" }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end
      end

      context "when `method_name` is empty string" do
        let(:method_name) { "" }

        context "when `suffix` is `nil`" do
          let(:suffix) { nil }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end

        context "when `suffix` is empty string" do
          let(:suffix) { "" }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end

        context "when `suffix` is empty symbol" do
          let(:suffix) { :"" }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end

        context "when `suffix` is symbol" do
          let(:suffix) { :_before_out_redefinition }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end

        context "when `suffix` is string" do
          let(:suffix) { "_before_out_redefinition" }

          it "returns empty string" do
            expect(util_result).to eq("")
          end
        end
      end

      context "when `method_name` is symbol" do
        let(:method_name) { :foo }

        context "when `suffix` is `nil`" do
          let(:suffix) { nil }

          it "returns method name without suffix" do
            expect(util_result).to eq("foo")
          end
        end

        context "when `suffix` is empty string" do
          let(:suffix) { "" }

          it "returns method name without suffix" do
            expect(util_result).to eq("foo")
          end
        end

        context "when `suffix` is empty symbol" do
          let(:suffix) { :"" }

          it "returns method name with suffix" do
            expect(util_result).to eq("foo")
          end
        end

        context "when `suffix` is symbol" do
          let(:suffix) { :_before_out_redefinition }

          it "returns method name with suffix" do
            expect(util_result).to eq("foo_before_out_redefinition")
          end
        end

        context "when `suffix` is string" do
          let(:suffix) { "_before_out_redefinition" }

          it "returns method name with suffix" do
            expect(util_result).to eq("foo_before_out_redefinition")
          end
        end

        context "when `method_name` ends with `!`" do
          let(:method_name) { :foo! }

          context "when `suffix` is `nil`" do
            let(:suffix) { nil }

            it "returns method name without suffix" do
              expect(util_result).to eq("foo!")
            end
          end

          context "when `suffix` is empty string" do
            let(:suffix) { "" }

            it "returns method name without suffix" do
              expect(util_result).to eq("foo!")
            end
          end

          context "when `suffix` is empty symbol" do
            let(:suffix) { :"" }

            it "returns method name with suffix" do
              expect(util_result).to eq("foo!")
            end
          end

          context "when `suffix` is symbol" do
            let(:suffix) { :_before_out_redefinition }

            it "returns method name with suffix" do
              expect(util_result).to eq("foo_before_out_redefinition!")
            end
          end

          context "when `suffix` is string" do
            let(:suffix) { "_before_out_redefinition" }

            it "returns method name with suffix" do
              expect(util_result).to eq("foo_before_out_redefinition!")
            end
          end
        end

        context "when `method_name` ends with `?`" do
          let(:method_name) { :foo? }

          context "when `suffix` is `nil`" do
            let(:suffix) { nil }

            it "returns method name without suffix" do
              expect(util_result).to eq("foo?")
            end
          end

          context "when `suffix` is empty string" do
            let(:suffix) { "" }

            it "returns method name without suffix" do
              expect(util_result).to eq("foo?")
            end
          end

          context "when `suffix` is empty symbol" do
            let(:suffix) { :"" }

            it "returns method name with suffix" do
              expect(util_result).to eq("foo?")
            end
          end

          context "when `suffix` is symbol" do
            let(:suffix) { :_before_out_redefinition }

            it "returns method name with suffix" do
              expect(util_result).to eq("foo_before_out_redefinition?")
            end
          end

          context "when `suffix` is string" do
            let(:suffix) { "_before_out_redefinition" }

            it "returns method name with suffix" do
              expect(util_result).to eq("foo_before_out_redefinition?")
            end
          end
        end
      end

      context "when `method_name` is string" do
        let(:method_name) { "foo" }

        context "when `suffix` is `nil`" do
          let(:suffix) { nil }

          it "returns method name without suffix" do
            expect(util_result).to eq("foo")
          end
        end

        context "when `suffix` is empty string" do
          let(:suffix) { "" }

          it "returns method name without suffix" do
            expect(util_result).to eq("foo")
          end
        end

        context "when `suffix` is empty symbol" do
          let(:suffix) { :"" }

          it "returns method name with suffix" do
            expect(util_result).to eq("foo")
          end
        end

        context "when `suffix` is symbol" do
          let(:suffix) { :_before_out_redefinition }

          it "returns method name with suffix" do
            expect(util_result).to eq("foo_before_out_redefinition")
          end
        end

        context "when `suffix` is string" do
          let(:suffix) { "_before_out_redefinition" }

          it "returns method name with suffix" do
            expect(util_result).to eq("foo_before_out_redefinition")
          end
        end

        context "when `method_name` ends with `!`" do
          let(:method_name) { "foo!" }

          context "when `suffix` is `nil`" do
            let(:suffix) { nil }

            it "returns method name without suffix" do
              expect(util_result).to eq("foo!")
            end
          end

          context "when `suffix` is empty string" do
            let(:suffix) { "" }

            it "returns method name without suffix" do
              expect(util_result).to eq("foo!")
            end
          end

          context "when `suffix` is empty symbol" do
            let(:suffix) { :"" }

            it "returns method name with suffix" do
              expect(util_result).to eq("foo!")
            end
          end

          context "when `suffix` is symbol" do
            let(:suffix) { :_before_out_redefinition }

            it "returns method name with suffix" do
              expect(util_result).to eq("foo_before_out_redefinition!")
            end
          end

          context "when `suffix` is string" do
            let(:suffix) { "_before_out_redefinition" }

            it "returns method name with suffix" do
              expect(util_result).to eq("foo_before_out_redefinition!")
            end
          end
        end

        context "when `method_name` ends with `?`" do
          let(:method_name) { "foo?" }

          context "when `suffix` is `nil`" do
            let(:suffix) { nil }

            it "returns method name without suffix" do
              expect(util_result).to eq("foo?")
            end
          end

          context "when `suffix` is empty string" do
            let(:suffix) { "" }

            it "returns method name without suffix" do
              expect(util_result).to eq("foo?")
            end
          end

          context "when `suffix` is empty symbol" do
            let(:suffix) { :"" }

            it "returns method name with suffix" do
              expect(util_result).to eq("foo?")
            end
          end

          context "when `suffix` is symbol" do
            let(:suffix) { :_before_out_redefinition }

            it "returns method name with suffix" do
              expect(util_result).to eq("foo_before_out_redefinition?")
            end
          end

          context "when `suffix` is string" do
            let(:suffix) { "_before_out_redefinition" }

            it "returns method name with suffix" do
              expect(util_result).to eq("foo_before_out_redefinition?")
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
