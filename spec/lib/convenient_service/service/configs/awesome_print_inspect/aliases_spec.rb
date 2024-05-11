# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/configs/awesome_print_inspect/aliases", type: :standard do
  specify { expect(ConvenientService::AwesomePrintInspect::Config).to eq(ConvenientService::Service::Configs::AwesomePrintInspect) }
end
# rubocop:enable RSpec/DescribeClass
