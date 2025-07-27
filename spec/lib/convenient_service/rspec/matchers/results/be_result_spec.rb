# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Results::BeResult, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  example_group "instance methods" do
    let(:klass) do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include mod
        end
      end
    end

    let(:instance) { klass.new }

    context "when NOT valid `status` is passed" do
      let(:status) { :foo }

      let(:exception_message) do
        <<~TEXT
          Status `#{status.inspect}` is NOT valid.

          Valid statuses for `be_result` are `:success`, `:failure`, `:error`, `:not_success`, `:not_failure`, and `:not_error`.
        TEXT
      end

      it "raises `ConvenientService::RSpec::Matchers::Results::BeResult::Exceptions::InvalidStatus`" do
        expect { be_result(status) }
          .to raise_error(ConvenientService::RSpec::Matchers::Results::BeResult::Exceptions::InvalidStatus)
          .with_message(exception_message)
      end

      specify do
        expect { ignoring_exception(ConvenientService::RSpec::Matchers::Results::BeResult::Exceptions::InvalidStatus) { be_result(status) } }
          .to delegate_to(ConvenientService, :raise)
      end
    end

    context "when valid `status` is passed" do
      specify do
        expect(be_result(:success)).to eq(ConvenientService::RSpec::Matchers::Classes::Results::BeSuccess.new)
      end

      specify do
        expect(be_result(:failure)).to eq(ConvenientService::RSpec::Matchers::Classes::Results::BeFailure.new)
      end

      specify do
        expect(be_result(:error)).to eq(ConvenientService::RSpec::Matchers::Classes::Results::BeError.new)
      end

      specify do
        expect(be_result(:not_success)).to eq(ConvenientService::RSpec::Matchers::Classes::Results::BeNotSuccess.new)
      end

      specify do
        expect(be_result(:not_failure)).to eq(ConvenientService::RSpec::Matchers::Classes::Results::BeNotFailure.new)
      end

      specify do
        expect(be_result(:not_error)).to eq(ConvenientService::RSpec::Matchers::Classes::Results::BeNotError.new)
      end
    end
  end
end
