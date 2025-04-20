# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain::Commands::NormalizeEnv, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(env: env) }

      let(:env) { {} }

      specify do
        expect { command_result }
          .to delegate_to(env, :to_h)
          .without_arguments
      end

      context "when `env` is `nil`" do
        let(:env) { nil }

        it "returns hash with empty array for `args` key, empty hash for `kwargs` key and `nil` for `block` key" do
          expect(command_result).to eq({args: [], kwargs: {}, block: nil})
        end
      end

      context "when `env` is hash" do
        let(:expected_env) { {args: [], kwargs: {}, block: nil} }

        context "when `env` has NO `:args` key" do
          let(:env) { {} }

          it "returns hash with empty array for `args` key" do
            expect(command_result).to eq({args: [], kwargs: {}, block: nil})
          end
        end

        context "when `env` has `:args` key with `nil` value" do
          let(:env) { {args: nil} }

          it "returns hash with empty array for `args` key" do
            expect(command_result).to eq({args: [], kwargs: {}, block: nil})
          end
        end

        context "when `env` has `:args` key with array value" do
          let(:env) { {args: [:foo]} }

          it "returns hash with that array value as `env[:args]`" do
            expect(command_result).to eq({args: [:foo], kwargs: {}, block: nil})
          end
        end

        context "when `env` has NO `:kwargs` key" do
          let(:env) { {} }

          it "returns hash with empty hash for `kwargs` key" do
            expect(command_result).to eq({args: [], kwargs: {}, block: nil})
          end
        end

        context "when `env` has `:kwargs` key with `nil` value" do
          let(:env) { {kwargs: nil} }

          it "returns hash with empty hash for `kwargs` key" do
            expect(command_result).to eq({args: [], kwargs: {}, block: nil})
          end
        end

        context "when `env` has `:kwargs` key with hash value" do
          let(:env) { {kwargs: {foo: :bar}} }

          it "returns hash with that hash value for `kwargs` key" do
            expect(command_result).to eq({args: [], kwargs: {foo: :bar}, block: nil})
          end
        end

        context "when `env` has NO `:block` key" do
          let(:env) { {} }

          it "returns hash with `nil` for `:block` key" do
            expect(command_result).to eq({args: [], kwargs: {}, block: nil})
          end
        end

        context "when `env` has `:block` key with `nil` value" do
          let(:env) { {block: nil} }

          it "returns hash with `nil` for `:block` key" do
            expect(command_result).to eq({args: [], kwargs: {}, block: nil})
          end
        end

        context "when `env` has `:block` key with proc value" do
          let(:env) { {block: block} }

          let(:block) { proc { :foo } }

          it "returns hash with that proc value for `:block` key" do
            expect(command_result).to eq({args: [], kwargs: {}, block: block})
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
