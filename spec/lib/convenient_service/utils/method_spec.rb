# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Method, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".defined?" do
    let(:method) { :foo }
    let(:klass) { Class.new }

    let(:public) { true }
    let(:protected) { true }
    let(:private) { true }

    specify do
      expect { described_class.defined?(method, klass, public: public, protected: protected, private: private) }
        .to delegate_to(described_class::Defined, :call)
        .with_arguments(method, klass, public: public, protected: protected, private: private)
        .and_return_its_value
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

    specify do
      ##
      # NOTE: Returns `true` when called for the first time, `false` for all the subsequent calls.
      #
      described_class.remove(method, klass, public: public, protected: protected, private: private)

      expect { described_class.remove(method, klass, public: public, protected: protected, private: private) }
        .to delegate_to(described_class::Remove, :call)
        .with_arguments(method, klass, public: public, protected: protected, private: private)
        .and_return_its_value
    end
  end
end
