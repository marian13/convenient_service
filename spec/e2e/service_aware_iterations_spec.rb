# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass, RSpec/ExampleLength, RSpec/MissingExampleGroupArgument, RSpec/MultipleExpectations
RSpec.describe "Step aware iterations", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::Results

  let(:number_service) do
    Class.new do
      include ConvenientService::Standard::Config

      attr_reader :number

      def initialize(number:)
        @number = number
      end

      ##
      # NOTE: `number_code` is ASCII Code.
      #
      def result
        case number
        when 0 then failure
        when 1 then success(number_string: "one", number_code: 49)
        when 2 then success(number_string: "two", number_code: 50)
        when 3 then success(number_string: "three", number_code: 51)
        when 4 then success(number_string: "four", number_code: 52)
        when 5 then success(number_string: "five", number_code: 53)
        when -Float::INFINITY..-1 then error(foo: :foo, bar: :bar, baz: :baz)
        else
          raise
        end
      end

      def self.name
        "NumberService"
      end
    end
  end

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:service_instance) { service.new }

  ##
  # TODO: Services (as classes).
  #
  example_group "results" do
    def iterate(&block)
      service_instance
        .service_aware_enumerable(collection)
        .service_aware_map { |number| yield(number_service.result(number: number)) }
        .result
    end

    example_group "success/failure" do
      let(:collection) { [1, 0] }

      # Default (with all keys).
      specify { expect(iterate { |result| result }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string) }).to be_success.with_data(values: ["one", nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code) }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_all_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string) }).to be_success.with_data(values: [{number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code) }).to be_success.with_data(values: [{}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{number_string: "one", number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string) }).to be_success.with_data(values: [{string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code) }).to be_success.with_data(values: [{string: "one", code: 49}, nil]) }

      # With none keys.
      specify { expect(iterate { |result| result.with_none_keys.with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_none_keys.with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect { iterate { |result| result.with_none_keys.with_only_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_none_keys.with_only_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_none_keys.with_all_keys }).to be_success.with_data(values: [{}, nil]) }
      specify { expect(iterate { |result| result.with_none_keys.with_except_keys }).to be_success.with_data(values: [{}, nil]) }
      specify { expect { iterate { |result| result.with_none_keys.with_except_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_none_keys.with_except_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_none_keys.with_extra_keys }).to be_success.with_data(values: [{}, nil]) }
      specify { expect(iterate { |result| result.with_none_keys.with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_none_keys.with_renamed_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect { iterate { |result| result.with_none_keys.with_renamed_keys(number_string: :string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_none_keys.with_renamed_keys(number_string: :string, number_code: :code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }

      # With zero keys.
      specify { expect(iterate { |result| result.with_only_keys.with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_only_keys.with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect { iterate { |result| result.with_only_keys.with_only_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_only_keys.with_only_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_only_keys.with_all_keys }).to be_success.with_data(values: [{}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys.with_except_keys }).to be_success.with_data(values: [{}, nil]) }
      specify { expect { iterate { |result| result.with_only_keys.with_except_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_only_keys.with_except_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_only_keys.with_extra_keys }).to be_success.with_data(values: [{}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys.with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys.with_renamed_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect { iterate { |result| result.with_only_keys.with_renamed_keys(number_string: :string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_only_keys.with_renamed_keys(number_string: :string, number_code: :code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }

      # With one key.
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_only_keys(:number_string) }).to be_success.with_data(values: ["one", nil]) }
      specify { expect { iterate { |result| result.with_only_keys(:number_string).with_only_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_code` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_all_keys }).to be_success.with_data(values: [{number_string: "one"}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_except_keys }).to be_success.with_data(values: [{number_string: "one"}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_except_keys(:number_string) }).to be_success.with_data(values: [{}, nil]) }
      specify { expect { iterate { |result| result.with_only_keys(:number_string).with_except_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_code` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_extra_keys }).to be_success.with_data(values: [{number_string: "one"}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{number_string: "one", number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_renamed_keys }).to be_success.with_data(values: ["one", nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_renamed_keys(number_string: :string) }).to be_success.with_data(values: ["one", nil]) }
      specify { expect { iterate { |result| result.with_only_keys(:number_string).with_renamed_keys(number_string: :string, number_code: :code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }

      # With many keys.
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_only_keys(:number_string) }).to be_success.with_data(values: ["one", nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_only_keys(:number_string, :number_code) }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_all_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_except_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_except_keys(:number_string) }).to be_success.with_data(values: [{number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_except_keys(:number_string, :number_code) }).to be_success.with_data(values: [{}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_extra_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{number_string: "one", number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_renamed_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_renamed_keys(number_string: :string) }).to be_success.with_data(values: [{string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_renamed_keys(number_string: :string, number_code: :code) }).to be_success.with_data(values: [{string: "one", code: 49}, nil]) }

      # With all keys.
      specify { expect(iterate { |result| result.with_all_keys.with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_all_keys.with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_all_keys.with_only_keys(:number_string) }).to be_success.with_data(values: ["one", nil]) }
      specify { expect(iterate { |result| result.with_all_keys.with_only_keys(:number_string, :number_code) }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_all_keys.with_all_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_all_keys.with_except_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_all_keys.with_except_keys(:number_string) }).to be_success.with_data(values: [{number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_all_keys.with_except_keys(:number_string, :number_code) }).to be_success.with_data(values: [{}, nil]) }
      specify { expect(iterate { |result| result.with_all_keys.with_extra_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_all_keys.with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{number_string: "one", number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_all_keys.with_renamed_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_all_keys.with_renamed_keys(number_string: :string) }).to be_success.with_data(values: [{string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_all_keys.with_renamed_keys(number_string: :string, number_code: :code) }).to be_success.with_data(values: [{string: "one", code: 49}, nil]) }

      # With zero except keys.
      specify { expect(iterate { |result| result.with_except_keys.with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_except_keys.with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_except_keys.with_only_keys(:number_string) }).to be_success.with_data(values: ["one", nil]) }
      specify { expect(iterate { |result| result.with_except_keys.with_only_keys(:number_string, :number_code) }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys.with_all_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys.with_except_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys.with_except_keys(:number_string) }).to be_success.with_data(values: [{number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys.with_except_keys(:number_string, :number_code) }).to be_success.with_data(values: [{}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys.with_extra_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys.with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{number_string: "one", number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys.with_renamed_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys.with_renamed_keys(number_string: :string) }).to be_success.with_data(values: [{string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys.with_renamed_keys(number_string: :string, number_code: :code) }).to be_success.with_data(values: [{string: "one", code: 49}, nil]) }

      # With one except key.
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect { iterate { |result| result.with_except_keys(:number_string).with_only_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_except_keys(:number_string).with_only_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_all_keys }).to be_success.with_data(values: [{number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_except_keys }).to be_success.with_data(values: [{number_code: 49}, nil]) }
      specify { expect { iterate { |result| result.with_except_keys(:number_string).with_except_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_except_keys(:number_string).with_except_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_extra_keys }).to be_success.with_data(values: [{number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_renamed_keys }).to be_success.with_data(values: [{number_code: 49}, nil]) }
      specify { expect { iterate { |result| result.with_except_keys(:number_string).with_renamed_keys(number_string: :string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_except_keys(:number_string).with_renamed_keys(number_string: :string, number_code: :code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }

      # With many except keys.
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect { iterate { |result| result.with_except_keys(:number_string, :number_code).with_only_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_except_keys(:number_string, :number_code).with_only_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_all_keys }).to be_success.with_data(values: [{}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_except_keys }).to be_success.with_data(values: [{}, nil]) }
      specify { expect { iterate { |result| result.with_except_keys(:number_string, :number_code).with_except_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_except_keys(:number_string, :number_code).with_except_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_extra_keys }).to be_success.with_data(values: [{}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_renamed_keys }).to be_success.with_data(values: [{}, nil]) }
      specify { expect { iterate { |result| result.with_except_keys(:number_string, :number_code).with_renamed_keys(number_string: :string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_except_keys(:number_string, :number_code).with_renamed_keys(number_string: :string, number_code: :code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }

      # With zero extra key.
      specify { expect(iterate { |result| result.with_extra_keys.with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_extra_keys.with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_extra_keys.with_only_keys(:number_string) }).to be_success.with_data(values: ["one", nil]) }
      specify { expect(iterate { |result| result.with_extra_keys.with_only_keys(:number_string, :number_code) }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys.with_all_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys.with_except_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys.with_except_keys(:number_string) }).to be_success.with_data(values: [{number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys.with_except_keys(:number_string, :number_code) }).to be_success.with_data(values: [{}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys.with_extra_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys.with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{number_string: "one", number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys.with_renamed_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys.with_renamed_keys(number_string: :string) }).to be_success.with_data(values: [{string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys.with_renamed_keys(number_string: :string, number_code: :code) }).to be_success.with_data(values: [{string: "one", code: 49}, nil]) }

      # With one extra key.
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_only_keys(:number_string) }).to be_success.with_data(values: ["one", nil]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_only_keys(:number_string, :number_code) }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_all_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_except_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_except_keys(:number_string) }).to be_success.with_data(values: [{number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_except_keys(:number_string, :number_code) }).to be_success.with_data(values: [{number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_extra_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_extra_keys(number_char: "2") }).to be_success.with_data(values: [{number_string: "one", number_code: 49, number_char: "2"}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_renamed_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_renamed_keys(number_string: :string) }).to be_success.with_data(values: [{string: "one", number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_renamed_keys(number_string: :string, number_code: :code) }).to be_success.with_data(values: [{string: "one", code: 49, number_char: "1"}, nil]) }

      # With zero renamed key.
      specify { expect(iterate { |result| result.with_renamed_keys.with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_only_keys(:number_string) }).to be_success.with_data(values: ["one", nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_only_keys(:number_string, :number_code) }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_all_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_except_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_except_keys(:number_string) }).to be_success.with_data(values: [{number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_except_keys(:number_string, :number_code) }).to be_success.with_data(values: [{}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_extra_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{number_string: "one", number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_renamed_keys }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_renamed_keys(number_string: :string) }).to be_success.with_data(values: [{string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_renamed_keys(number_string: :string, number_code: :code) }).to be_success.with_data(values: [{string: "one", code: 49}, nil]) }

      # With one renamed key.
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect { iterate { |result| result.with_renamed_keys(number_string: :string).with_only_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_renamed_keys(number_string: :string).with_only_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_all_keys }).to be_success.with_data(values: [{string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_except_keys }).to be_success.with_data(values: [{string: "one", number_code: 49}, nil]) }
      specify { expect { iterate { |result| result.with_renamed_keys(number_string: :string).with_except_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_renamed_keys(number_string: :string).with_except_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_extra_keys }).to be_success.with_data(values: [{string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{string: "one", number_code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_renamed_keys }).to be_success.with_data(values: [{string: "one", number_code: 49}, nil]) }
      specify { expect { iterate { |result| result.with_renamed_keys(number_string: :string).with_renamed_keys(number_string: :string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_renamed_keys(number_string: :string).with_renamed_keys(number_string: :string, number_code: :code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }

      # With many renamed keys.
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_none_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_only_keys }).to be_success.with_data(values: [true, false]) }
      specify { expect { iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_only_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_only_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_all_keys }).to be_success.with_data(values: [{string: "one", code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_except_keys }).to be_success.with_data(values: [{string: "one", code: 49}, nil]) }
      specify { expect { iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_except_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_except_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_extra_keys }).to be_success.with_data(values: [{string: "one", code: 49}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_extra_keys(number_char: "1") }).to be_success.with_data(values: [{string: "one", code: 49, number_char: "1"}, nil]) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_renamed_keys }).to be_success.with_data(values: [{string: "one", code: 49}, nil]) }
      specify { expect { iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_renamed_keys(number_string: :string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_renamed_keys(number_string: :string, number_code: :code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }
    end

    example_group "error" do
      let(:collection) { [-1, :exception] }

      # Default (with all keys).
      specify { expect(iterate { |result| result }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }

      # With none keys.
      specify { expect(iterate { |result| result.with_none_keys.with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_none_keys.with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect { iterate { |result| result.with_none_keys.with_only_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_none_keys.with_only_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_none_keys.with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_none_keys.with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect { iterate { |result| result.with_none_keys.with_except_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_none_keys.with_except_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_none_keys.with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_none_keys.with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_none_keys.with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect { iterate { |result| result.with_none_keys.with_renamed_keys(number_string: :string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_none_keys.with_renamed_keys(number_string: :string, number_code: :code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }

      # With zero keys.
      specify { expect(iterate { |result| result.with_only_keys.with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys.with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect { iterate { |result| result.with_only_keys.with_only_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_only_keys.with_only_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_only_keys.with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys.with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect { iterate { |result| result.with_only_keys.with_except_keys(:number_string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_only_keys.with_except_keys(:number_string, :number_code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.\n") }
      specify { expect(iterate { |result| result.with_only_keys.with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys.with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys.with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect { iterate { |result| result.with_only_keys.with_renamed_keys(number_string: :string) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }
      specify { expect { iterate { |result| result.with_only_keys.with_renamed_keys(number_string: :string, number_code: :code) } }.to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename).with_message("Data attribute by key `:number_string` does NOT exist. That is why it can NOT be renamed to `:string`. Make sure the corresponding result has it.\n") }

      # With one key.
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_only_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_only_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_except_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_except_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_renamed_keys(number_string: :string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string).with_renamed_keys(number_string: :string, number_code: :code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }

      # With many keys.
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_only_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_only_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_except_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_except_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_renamed_keys(number_string: :string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_only_keys(:number_string, :number_code).with_renamed_keys(number_string: :string, number_code: :code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }

      # With all keys.
      specify { expect(iterate { |result| result.with_all_keys.with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys.with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys.with_only_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys.with_only_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys.with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys.with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys.with_except_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys.with_except_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys.with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys.with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys.with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys.with_renamed_keys(number_string: :string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_all_keys.with_renamed_keys(number_string: :string, number_code: :code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }

      # With zero except keys.
      specify { expect(iterate { |result| result.with_except_keys.with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys.with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys.with_only_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys.with_only_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys.with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys.with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys.with_except_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys.with_except_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys.with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys.with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys.with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys.with_renamed_keys(number_string: :string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys.with_renamed_keys(number_string: :string, number_code: :code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }

      # With one except key.
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_only_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_only_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_except_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_except_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_renamed_keys(number_string: :string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string).with_renamed_keys(number_string: :string, number_code: :code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }

      # With many except keys.
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_only_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_only_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_except_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_except_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_renamed_keys(number_string: :string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_except_keys(:number_string, :number_code).with_renamed_keys(number_string: :string, number_code: :code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }

      # With zero extra key.
      specify { expect(iterate { |result| result.with_extra_keys.with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys.with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys.with_only_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys.with_only_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys.with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys.with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys.with_except_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys.with_except_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys.with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys.with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys.with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys.with_renamed_keys(number_string: :string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys.with_renamed_keys(number_string: :string, number_code: :code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }

      # With one extra key.
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_only_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_only_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_except_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_except_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_extra_keys(number_char: "2") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_renamed_keys(number_string: :string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_extra_keys(number_char: "1").with_renamed_keys(number_string: :string, number_code: :code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }

      # With zero renamed key.
      specify { expect(iterate { |result| result.with_renamed_keys.with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_only_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_only_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_except_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_except_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_renamed_keys(number_string: :string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys.with_renamed_keys(number_string: :string, number_code: :code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }

      # With one renamed key.
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_only_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_only_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_except_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_except_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_renamed_keys(number_string: :string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string).with_renamed_keys(number_string: :string, number_code: :code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }

      # With many renamed keys.
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_none_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_only_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_only_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_only_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_all_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_except_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_except_keys(:number_string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_except_keys(:number_string, :number_code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_extra_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_extra_keys(number_char: "1") }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_renamed_keys }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_renamed_keys(number_string: :string) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { |result| result.with_renamed_keys(number_string: :string, number_code: :code).with_renamed_keys(number_string: :string, number_code: :code) }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
    end
  end

  example_group "steps" do
    def iterate(&block)
      service_instance
        .service_aware_enumerable(collection)
        .service_aware_map { |number| service_instance.step number_service, in: [number: -> { number }], **yield }
        .result
    end

    example_group "success/failure" do
      let(:collection) { [1, 0] }

      specify { expect(iterate { {} }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { {out: []} }).to be_success.with_data(values: [true, false]) }
      specify { expect(iterate { {out: :number_string} }).to be_success.with_data(values: ["one", nil]) }
      specify { expect(iterate { {out: [:number_string, :number_code]} }).to be_success.with_data(values: [{number_string: "one", number_code: 49}, nil]) }
      specify { expect(iterate { {out: [number_char: -> { "1" }]} }).to be_success.with_data(values: ["1", nil]) }
      specify { expect(iterate { {out: [:number_string, number_char: -> { "1" }]} }).to be_success.with_data(values: [{number_string: "one", number_char: "1"}, nil]) }
    end

    example_group "error" do
      let(:collection) { [-1, :exception] }

      specify { expect(iterate { {} }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { {out: []} }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { {out: :number_string} }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { {out: [:number_string, :number_code]} }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { {out: [number_char: "1"]} }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
      specify { expect(iterate { {out: [:number_string, number_char: "1"]} }).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz) }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass, RSpec/ExampleLength, RSpec/MissingExampleGroupArgument, RSpec/MultipleExpectations
