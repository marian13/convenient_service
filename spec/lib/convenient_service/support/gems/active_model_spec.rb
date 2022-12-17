# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Gems::ActiveModel do
  example_group "class methods" do
    if described_class.loaded?
      describe "version" do
        it "return version" do
          expect(described_class.version).to eq(ConvenientService::Support::Version.new(::ActiveModel.version))
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
