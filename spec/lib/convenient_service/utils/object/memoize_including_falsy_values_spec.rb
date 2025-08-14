# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Object::MemoizeIncludingFalsyValues, type: :standard do
  describe ".call" do
    subject(:util_result) { described_class.call(object, ivar_name, &value_block) }

    let(:object) { Object.new }
    let(:ivar_name) { :@foo }
    let(:value_block) { proc { false } }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Object::InstanceVariableFetch.call`" do
      expect(ConvenientService::Utils::Object::InstanceVariableFetch)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[object, ivar_name], {}, value_block]) }

      util_result
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Object::InstanceVariableFetch.call` value" do
      expect(util_result).to eq(ConvenientService::Utils::Object::InstanceVariableFetch.call(object, ivar_name, &value_block))
    end
  end
end
