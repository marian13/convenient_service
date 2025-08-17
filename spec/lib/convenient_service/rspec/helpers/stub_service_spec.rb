# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Helpers::StubService, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "instance methods" do
    let(:klass) do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include mod
        end
      end
    end

    let(:instance) { klass.new }

    describe "#stub_service" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config
        end
      end

      specify do
        expect { instance.stub_service(service_class) }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::StubService, :call)
          .with_arguments(service_class)
          .and_return_its_value
      end
    end

    describe "#return_result" do
      let(:status) { :success }

      specify do
        expect { instance.return_result(status) }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec, :new)
          .with_arguments(status: status)
          .and_return_its_value
      end
    end

    describe "#return_success" do
      specify do
        expect { instance.return_success }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec, :new)
          .with_arguments(status: :success)
          .and_return_its_value
      end
    end

    describe "#return_failure" do
      specify do
        expect { instance.return_failure }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec, :new)
          .with_arguments(status: :failure)
          .and_return_its_value
      end
    end

    describe "#return_error" do
      specify do
        expect { instance.return_error }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec, :new)
          .with_arguments(status: :error)
          .and_return_its_value
      end
    end
  end
end
