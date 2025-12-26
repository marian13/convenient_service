# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceUnstub, type: :standard do
  include ConvenientService::RSpec::Helpers::StubService

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  subject(:helper) { described_class.new(service_class: service_class) }

  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end
    end
  end

  let(:arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  let(:result_unmock) { ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock.new }

  example_group "instance methods" do
    describe "#with_any_arguments" do
      it "returns self" do
        expect(helper.with_any_arguments).to eq(helper)
      end

      context "when method is called without arguments" do
        it "modifies method to return stub" do
          stub_service(service_class).with_any_arguments.to return_error.with_code(:with_arguments)
          unstub_service(service_class).with_any_arguments.to return_result_mock

          expect(service_class.result).to be_success.without_data
        end
      end

      context "when method is called with arguments" do
        it "modifies method to return stub" do
          stub_service(service_class).with_any_arguments.to return_error.with_code(:with_arguments)
          unstub_service(service_class).with_any_arguments.to return_result_mock

          expect(service_class.result(*args, **kwargs, &block)).to be_success.without_data
        end
      end
    end

    describe "#with_arguments" do
      it "returns self" do
        expect(helper.with_arguments(*args, **kwargs, &block)).to eq(helper)
      end

      context "when method is NOT called with arguments" do
        it "does NOT modify method to return stub" do
          stub_service(service_class).with_arguments(*args, **kwargs, &block).to return_error.with_code(:with_arguments)
          unstub_service(service_class).with_arguments(*args, **kwargs, &block).to return_result_mock

          expect(service_class.result).to be_success.without_data
        end
      end

      context "when method is called with arguments" do
        it "modifies method to return stub" do
          stub_service(service_class).with_arguments(*args, **kwargs, &block).to return_error.with_code(:with_arguments)
          unstub_service(service_class).with_arguments(*args, **kwargs, &block).to return_result_mock

          expect(service_class.result(*args, **kwargs, &block)).to be_success.without_data
        end
      end
    end

    describe "#without_arguments" do
      it "returns self" do
        expect(helper.without_arguments).to eq(helper)
      end

      context "when method is NOT called without arguments" do
        it "does NOT modify method to return stub" do
          stub_service(service_class).without_arguments.to return_error.with_code(:with_arguments)
          unstub_service(service_class).without_arguments.to return_result_mock

          expect(service_class.result(*args, **kwargs, &block)).to be_success.without_data
        end
      end

      context "when method is called without arguments" do
        it "modifies method to return stub" do
          stub_service(service_class).without_arguments.to return_error.with_code(:with_arguments)
          unstub_service(service_class).without_arguments.to return_result_mock

          expect(service_class.result).to be_success.without_data
        end
      end
    end

    describe "#to" do
      it "returns `self`" do
        expect(helper.to(result_unmock)).to eq(helper)
      end

      specify do
        expect { helper.to(result_unmock) }
          .to delegate_to(result_unmock, :for)
          .with_arguments(service_class, nil)
      end

      specify do
        expect { helper.to(result_unmock) }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::DeleteServiceStubbedResult, :call)
          .with_arguments(service: service_class, arguments: nil)
      end

      specify do
        other_result_unmock = ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock.new(status: :success).for(service_class, nil)

        allow(result_unmock).to receive(:for).with(service_class, nil).and_return(other_result_unmock)

        expect { helper.to(result_unmock) }
          .to delegate_to(other_result_unmock, :register)
          .without_arguments
      end

      context "when used with `with_any_arguments`" do
        let(:arguments) { nil }

        specify do
          expect { helper.with_any_arguments.to(result_unmock) }
            .to delegate_to(result_unmock, :for)
            .with_arguments(service_class, arguments)
        end

        specify do
          expect { helper.with_any_arguments.to(result_unmock) }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::DeleteServiceStubbedResult, :call)
            .with_arguments(service: service_class, arguments: arguments)
        end
      end

      context "when used with `with_arguments`" do
        let(:arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }

        specify do
          expect { helper.with_arguments(*args, **kwargs, &block).to(result_unmock) }
            .to delegate_to(result_unmock, :for)
            .with_arguments(service_class, arguments)
        end

        specify do
          expect { helper.with_arguments(*args, **kwargs, &block).to(result_unmock) }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::DeleteServiceStubbedResult, :call)
            .with_arguments(service: service_class, arguments: arguments)
        end
      end

      context "when used with `without_arguments`" do
        let(:arguments) { ConvenientService::Support::Arguments.null_arguments }

        specify do
          expect { helper.without_arguments.to(result_unmock) }
            .to delegate_to(result_unmock, :for)
            .with_arguments(service_class, arguments)
        end

        specify do
          expect { helper.without_arguments.to(result_unmock) }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::DeleteServiceStubbedResult, :call)
            .with_arguments(service: service_class, arguments: arguments)
        end
      end
    end

    describe "#to_return_result_mock" do
      specify do
        expect { helper.to_return_result_mock }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock, :new)
          .with_arguments(service_class: service_class, arguments: nil)
          .and_return_its_value
      end

      it "sets result unmock for service unstub" do
        helper.to_return_result_mock

        expect(helper).not_to eq(described_class.new(service_class: service_class))
      end

      context "when used with `with_any_arguments`" do
        let(:arguments) { nil }

        specify do
          expect { helper.with_any_arguments.to_return_result_mock }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock, :new)
            .with_arguments(service_class: service_class, arguments: arguments)
            .and_return_its_value
        end
      end

      context "when used with `with_arguments`" do
        let(:arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }

        specify do
          expect { helper.with_arguments(*args, **kwargs, &block).to_return_result_mock }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock, :new)
            .with_arguments(service_class: service_class, arguments: arguments)
            .and_return_its_value
        end
      end

      context "when used with `without_arguments`" do
        let(:arguments) { ConvenientService::Support::Arguments.null_arguments }

        specify do
          expect { helper.without_arguments.to_return_result_mock }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock, :new)
            .with_arguments(service_class: service_class, arguments: arguments)
            .and_return_its_value
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:helper) { described_class.new(service_class: service_class) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(helper == other).to be_nil
          end
        end

        context "when `other` has different `service_class`" do
          let(:other) { described_class.new(service_class: Class.new) }

          it "returns `false`" do
            expect(helper == other).to be(false)
          end
        end

        context "when `other` has different `arguments`" do
          let(:other) { described_class.new(service_class: service_class).with_arguments(:foo, :bar) }

          it "returns `false`" do
            expect(helper == other).to be(false)
          end
        end

        context "when `other` has different `result_unmock`" do
          let(:other) { described_class.new(service_class: service_class).to return_result_mock }

          it "returns `false`" do
            expect(helper == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(service_class: service_class) }

          it "returns `true`" do
            expect(helper == other).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
