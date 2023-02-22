# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasResultShortSyntax::Concern do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      let(:result_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    let(:service) do
      Class.new do
        include ConvenientService::Configs::Minimal

        # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
        class self::Result
          concerns do
            use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasResultShortSyntax::Concern
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration

        def result
          success(data: {foo: :bar})
        end
      end
    end

    let(:result) { service.result }
    let(:key) { :foo }

    describe "#[]" do
      specify do
        expect { result[key] }
          .to delegate_to(result.data, :[])
          .with_arguments(key)
          .and_return_its_value
      end
    end

    describe "#ud" do
      specify do
        expect { result.ud }
          .to delegate_to(result, :unsafe_data)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#um" do
      specify do
        expect { result.um }
          .to delegate_to(result, :unsafe_message)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#uc" do
      specify do
        expect { result.uc }
          .to delegate_to(result, :unsafe_code)
          .without_arguments
          .and_return_its_value
      end
    end
  end
end
