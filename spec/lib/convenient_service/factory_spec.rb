# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Factory do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".create" do
      let(:method) { :result_with_method_step }
      let(:kwargs) { {method_step: :foo} }

      specify do
        expect { described_class.create(method, **kwargs) }
          .to delegate_to(ConvenientService::Factories, :public_send)
          .with_arguments("create_#{method}", **kwargs)
      end

      it "returns created object" do
        expect(described_class.create(:result_method_step)).to eq(:result)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
