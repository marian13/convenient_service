# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::String, type: :standard do
  describe ".camelize" do
    let(:string) { "foo" }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::String::Camelize.call`" do
      expect(described_class::Camelize)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[string], {}, nil]) }

      described_class.camelize(string)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::String::Camelize.call` value" do
      expect(described_class.camelize(string)).to eq(described_class::Camelize.call(string))
    end
  end

  describe ".demodulize" do
    let(:string) { "Inflections" }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::String::Demodulize.call`" do
      expect(described_class::Demodulize)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[string], {}, nil]) }

      described_class.demodulize(string)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::String::Demodulize.call` value" do
      expect(described_class.demodulize(string)).to eq(described_class::Demodulize.call(string))
    end
  end

  describe ".split" do
    let(:string) { "foo.bar" }
    let(:delimiters) { "." }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::String::Split.call`" do
      expect(described_class::Split)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[string, *delimiters], {}, nil]) }

      described_class.split(string, *delimiters)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::String::Split.call` value" do
      expect(described_class.split(string, *delimiters)).to eq(described_class::Split.call(string, *delimiters))
    end
  end

  describe ".truncate" do
    let(:string) { "hello" }
    let(:truncate_at) { 4 }
    let(:omission) { "..." }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::String::Truncate.call`" do
      expect(described_class::Truncate)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[string, truncate_at], {omission: omission}, nil]) }

      described_class.truncate(string, truncate_at, omission: omission)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::String::Truncate.call` value" do
      expect(described_class.truncate(string, truncate_at, omission: omission)).to eq(described_class::Truncate.call(string, truncate_at, omission: omission))
    end
  end
end
