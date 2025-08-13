# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Class, type: :standard do
  describe ".display_name" do
    let(:klass) { Class.new }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Class::DisplayName.call`" do
      expect(described_class::DisplayName)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[klass], {}, nil]) }

      described_class.display_name(klass)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Class::DisplayName.call` value" do
      expect(described_class.display_name(klass)).to eq(described_class::DisplayName.call(klass))
    end
  end

  if ConvenientService::Dependencies.ruby.version >= 3.2
    describe ".attached_object" do
      let(:klass) { String.singleton_class }

      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
      it "delegates to `ConvenientService::Utils::Class::GetAttachedObject.call`" do
        expect(described_class::GetAttachedObject)
          .to receive(:call)
            .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[klass], {}, nil]) }

        described_class.attached_object(klass)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

      it "returns `ConvenientService::Utils::Class::GetAttachedObject.call` value" do
        expect(described_class.attached_object(klass)).to eq(described_class::GetAttachedObject.call(klass))
      end
    end
  end
end
