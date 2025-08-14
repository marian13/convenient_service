# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Method::Name, type: :standard do
  describe ".append" do
    let(:method_name) { :foo }
    let(:suffix) { "_without_middlewares" }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Method::Name::Append.call`" do
      expect(described_class::Append)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[method_name, suffix], {}, nil]) }

      described_class.append(method_name, suffix)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Method::Name::Append.call` value" do
      expect(described_class.append(method_name, suffix)).to eq(described_class::Append.call(method_name, suffix))
    end
  end
end
