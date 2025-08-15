# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Method, type: :standard do
  describe ".defined?" do
    let(:method) { :foo }
    let(:klass) { Class.new }

    let(:public) { true }
    let(:protected) { true }
    let(:private) { true }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Method::Defined.call`" do
      expect(described_class::Defined)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[method, klass], {public: public, protected: protected, private: private}, nil])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.defined?(method, klass, public: public, protected: protected, private: private)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Method::Defined.call` value" do
      expect(described_class.defined?(method, klass, public: public, protected: protected, private: private)).to eq(described_class::Defined.call(method, klass, public: public, protected: protected, private: private))
    end
  end

  describe ".remove" do
    let(:method) { :foo }

    let(:klass) do
      Class.new do
        def foo
        end
      end
    end

    let(:public) { true }
    let(:protected) { true }
    let(:private) { true }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Method::Remove.call`" do
      expect(described_class::Remove)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[method, klass], {public: public, protected: protected, private: private}, nil])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.remove(method, klass, public: public, protected: protected, private: private)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Method::Remove.call` value" do
      ##
      # NOTE: Returns `true` when called for the first time, `false` for all the subsequent calls.
      #
      described_class.remove(method, klass, public: public, protected: protected, private: private)

      expect(described_class.remove(method, klass, public: public, protected: protected, private: private)).to eq(described_class::Remove.call(method, klass, public: public, protected: protected, private: private))
    end
  end
end
