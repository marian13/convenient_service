# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "String representation", type: [:standard, :e2e] do
  let(:first_step) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end

      def self.name
        "FirstStep"
      end
    end
  end

  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(first_step) do |first_step|
        include ConvenientService::Standard::Config

        step first_step

        def self.name
          "Service"
        end
      end
    end
  end

  let(:service_instance) { service_class.new }

  let(:result_class) { success.class }
  let(:success) { service_instance.success(foo: :bar, baz: :qux) }
  let(:failure) { service_instance.failure("foo") }
  let(:error) { service_instance.error(:foo) }

  let(:data_class) { data_instance.class }
  let(:data_instance) { success.unsafe_data }

  let(:message_class) { message_instance.class }
  let(:message_instance) { failure.unsafe_message }

  let(:code_class) { code_instance.class }
  let(:code_instance) { error.unsafe_code }

  let(:step_class) { step_instance.class }
  let(:step_instance) { service_instance.steps.first }

  specify do
    expect(service_class.to_s).to match(/#<Class:.+?>/) # "#<Class:0x00007f01b3802da0>"
  end

  specify do
    expect(service_class.inspect).to match(/#<Class:.+?>/) # "#<Class:0x00007f01b3802da0>"
  end

  specify do
    expect(service_instance.to_s).to match(/#<#<Class:.+?>:.+?>/) # "#<#<Class:0x00007f01b3802da0>:0x00007f01b2a1a7b0>"
  end

  specify do
    expect(service_instance.inspect).to eq("<Service>")
  end

  specify do
    expect(result_class.to_s).to match(/#<Class:.+?>::Result/) # "#<Class:0x00007f5ad2929120>::Result"
  end

  specify do
    expect(result_class.inspect).to match(/#<Class:.+?>::Result/) # "#<Class:0x00007f5ad2929120>::Result"
  end

  specify do
    expect(success.to_s).to match(/#<#<Class:.+?>::Result:.+?>/) # "#<#<Class:0x00007f01b3802da0>::Result:0x00007f01b28f9778>"
  end

  specify do
    expect(success.inspect).to eq("<Service::Result status: :success, data_keys: [:foo, :baz]>")
  end

  specify do
    expect(failure.to_s).to match(/#<#<Class:.+?>::Result:.+?>/) # "#<#<Class:0x00007f01b3802da0>::Result:0x00007f01b28f9778>"
  end

  specify do
    expect(failure.inspect).to eq("<Service::Result status: :failure, message: \"foo\">")
  end

  specify do
    expect(error.to_s).to match(/#<#<Class:.+?>::Result:.+?>/) # "#<#<Class:0x00007f01b3802da0>::Result:0x00007f01b28f9778>"
  end

  specify do
    expect(error.inspect).to eq("<Service::Result status: :error, message: \"foo\">")
  end

  specify do
    expect(data_class.to_s).to match(/#<Class:.+?>::Result::Data/) # #<Class:0x00007f0155b1ac80>::Result::Data
  end

  specify do
    expect(data_class.inspect).to match(/#<Class:.+?>::Result::Data/) # #<Class:0x00007f0155b1ac80>::Result::Data
  end

  specify do
    ##
    # NOTE: Older Rubies display hashes with rocket syntax.
    #
    expect(data_instance.to_s).to eq({foo: :bar, baz: :qux}.to_s)
  end

  specify do
    expect(data_instance.inspect).to eq("<Service::Result::Data foo: :bar, baz: :qux>")
  end

  specify do
    expect(message_class.to_s).to match(/#<Class:.+?>::Result::Message/) # "#<Class:0x00007f8b2d9fa3c0>::Result::Message"
  end

  specify do
    expect(message_class.inspect).to match(/#<Class:.+?>::Result::Message/) # "#<Class:0x00007f8b2d9fa3c0>::Result::Message"
  end

  specify do
    expect(message_instance.to_s).to eq("foo")
  end

  specify do
    expect(message_instance.inspect).to eq("<Service::Result::Message text: \"foo\">")
  end

  specify do
    expect(code_class.to_s).to match(/#<Class:.+?>::Result::Code/) # "#<Class:0x00007f8b2d9fa3c0>::Result::Code"
  end

  specify do
    expect(code_class.inspect).to match(/#<Class:.+?>::Result::Code/) # "#<Class:0x00007f8b2d9fa3c0>::Result::Code"
  end

  specify do
    expect(code_instance.to_s).to eq("default_error")
  end

  specify do
    expect(code_instance.inspect).to eq("<Service::Result::Code value: :default_error>")
  end

  specify do
    expect(step_class.to_s).to match(/#<Class:.+?>::Step/) # "#<Class:0x00007f848eabad28>::Step"
  end

  specify do
    expect(step_class.inspect).to match(/#<Class:.+?>::Step/) # "#<Class:0x00007f848eabad28>::Step"
  end

  specify do
    expect(step_instance.to_s).to eq("FirstStep")
  end

  specify do
    expect(step_instance.inspect).to eq("<Service::Step service: FirstStep>")
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
