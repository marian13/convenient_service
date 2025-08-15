# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Proc, type: :standard do
  describe ".conjunct" do
    let(:procs) { [->(item) { item[:valid] }] }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Proc::Conjunct.call`" do
      expect(described_class::Conjunct)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[procs], {}, nil])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.conjunct(procs)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Proc::Conjunct.call` value" do
      expect(described_class.conjunct(procs)).to eq(described_class::Conjunct.call(procs))
    end
  end

  describe ".display" do
    let(:proc) { -> { :foo } }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Proc::Display.call`" do
      expect(described_class::Display)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[proc], {}, nil])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.display(proc)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Proc::Display.call` value" do
      expect(described_class.display(proc)).to eq(described_class::Display.call(proc))
    end
  end

  describe ".exec_config" do
    let(:proc) { ->(object) { object.reverse } }
    let(:object) { "abc" }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Proc::ExecConfig.call`" do
      expect(described_class::ExecConfig)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[proc, object], {}, nil])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.exec_config(proc, object)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Proc::ExecConfig.call` value" do
      expect(described_class.exec_config(proc, object)).to eq(described_class::ExecConfig.call(proc, object))
    end
  end
end
