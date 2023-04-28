# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/configs/awesome_print/aliases" do
  specify { expect(ConvenientService::AwesomePrint::Config).to eq(ConvenientService::Configs::AwesomePrint) }
end
# rubocop:enable RSpec/DescribeClass
