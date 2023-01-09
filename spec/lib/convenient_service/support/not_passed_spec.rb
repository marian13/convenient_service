# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/FilePath
RSpec.describe ConvenientService::Support do
  example_group "constants" do
    describe "::NOT_PASSED" do
      it "returns `Object` instance" do
        expect(described_class::NOT_PASSED).to be_instance_of(Object)
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
