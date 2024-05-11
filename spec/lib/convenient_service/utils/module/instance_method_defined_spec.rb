# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Utils::Module::InstanceMethodDefined, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methhods" do
    describe ".call" do
      let(:util_result) { described_class.call(mod, method_name, public: public, protected: protected, private: private) }

      let(:mod) do
        Module.new do
          def foo
          end
        end
      end

      let(:method_name) { :foo }

      let(:public) { false }
      let(:protected) { false }
      let(:private) { false }

      specify do
        expect { util_result }
          .to delegate_to(ConvenientService::Utils::Method, :defined?)
          .with_arguments(method_name, mod, public: public, protected: protected, private: private)
          .and_return_its_value
      end

      context "when `public` is NOT passed" do
        let(:util_result) { described_class.call(mod, method_name, protected: protected, private: private) }

        specify do
          expect { util_result }
            .to delegate_to(ConvenientService::Utils::Method, :defined?)
            .with_arguments(method_name, mod, public: true, protected: protected, private: private)
            .and_return_its_value
        end
      end

      context "when `protected` is NOT passed" do
        let(:util_result) { described_class.call(mod, method_name, public: public, private: private) }

        specify do
          expect { util_result }
            .to delegate_to(ConvenientService::Utils::Method, :defined?)
            .with_arguments(method_name, mod, public: public, protected: true, private: private)
            .and_return_its_value
        end
      end

      context "when `private` is NOT passed" do
        let(:util_result) { described_class.call(mod, method_name, public: public, protected: protected) }

        specify do
          expect { util_result }
            .to delegate_to(ConvenientService::Utils::Method, :defined?)
            .with_arguments(method_name, mod, public: public, protected: protected, private: false)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
