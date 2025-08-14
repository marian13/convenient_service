# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Utils::Module::ClassMethodDefined, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methhods" do
    describe ".call" do
      let(:util_result) { described_class.call(mod, method_name, public: public, protected: protected, private: private) }

      let(:mod) do
        Module.new do
          def self.foo
          end
        end
      end

      let(:method_name) { :foo }

      let(:public) { false }
      let(:protected) { false }
      let(:private) { false }

      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
      it "delegates to `ConvenientService::Utils::Method.defined?`" do
        expect(ConvenientService::Utils::Method)
          .to receive(:defined?)
            .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[method_name, mod.singleton_class], {public: public, protected: protected, private: private}, nil]) }

        util_result
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

      it "returns `ConvenientService::Utils::Method.defined?` value" do
        expect(util_result).to eq(ConvenientService::Utils::Method.defined?(method_name, mod.singleton_class, public: public, protected: protected, private: private))
      end

      context "when `public` is NOT passed" do
        let(:util_result) { described_class.call(mod, method_name, protected: protected, private: private) }

        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
        it "delegates to `ConvenientService::Utils::Method.defined?`" do
          expect(ConvenientService::Utils::Method)
            .to receive(:defined?)
              .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[method_name, mod.singleton_class], {public: true, protected: protected, private: private}, nil]) }

          util_result
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

        it "returns `ConvenientService::Utils::Method.defined?` value" do
          expect(util_result).to eq(ConvenientService::Utils::Method.defined?(method_name, mod.singleton_class, public: true, protected: protected, private: private))
        end
      end

      context "when `protected` is NOT passed" do
        let(:util_result) { described_class.call(mod, method_name, public: public, private: private) }

        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
        it "delegates to `ConvenientService::Utils::Method.defined?`" do
          expect(ConvenientService::Utils::Method)
            .to receive(:defined?)
              .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[method_name, mod.singleton_class], {public: public, protected: true, private: private}, nil]) }

          util_result
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

        it "returns `ConvenientService::Utils::Method.defined?` value" do
          expect(util_result).to eq(ConvenientService::Utils::Method.defined?(method_name, mod.singleton_class, public: public, protected: true, private: private))
        end
      end

      context "when `private` is NOT passed" do
        let(:util_result) { described_class.call(mod, method_name, public: public, protected: protected) }

        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
        it "delegates to `ConvenientService::Utils::Method.defined?`" do
          expect(ConvenientService::Utils::Method)
            .to receive(:defined?)
              .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[method_name, mod.singleton_class], {public: public, protected: protected, private: false}, nil]) }

          util_result
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

        it "returns `ConvenientService::Utils::Method.defined?` value" do
          expect(util_result).to eq(ConvenientService::Utils::Method.defined?(method_name, mod.singleton_class, public: public, protected: protected, private: false))
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
