# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "test_helper"

require "convenient_service"

require_relative "shared/stub_variants"

class ConvenientService::E2E::StubbedServiceResultsTest < Minitest::Test
  context "Service" do
    context "class methods" do
      describe ".result" do
        extend ConvenientService::E2E::Shared::StubVariants

        variants.each do |variant_name|
          context variant_name do
            context "arguments" do
              setup do
                @service_class =
                  Class.new do
                    include ConvenientService::Standard::Config

                    def initialize(*args, **kwargs, &block)
                    end

                    def result
                      success(from: "original result")
                    end
                  end

                @args = [:foo]
                @kwargs = {foo: :bar}
                @block = proc { :foo }

                @other_args = [:bar]
                @other_kwargs = {bar: :baz}
                @other_block = proc { :bar }
              end

              context "when NO stubs" do
                should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
              end

              context "when one stub" do
                context "when first stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                end

                context "when first stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                end

                context "when first stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@other_args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@other_kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@other_block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end
              end

              context "when multiple stubs" do
                context "when first stub with default (any arguments), second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").unregister
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register do
                        @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                end

                context "when first stub with default (any arguments), second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").unregister
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register do
                        @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                end

                context "when first stub with default (any arguments), second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").unregister
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register do
                        @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                end

                context "when first stub with default (any arguments), second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").unregister
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register do
                        @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@other_args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                end

                context "when first stub with default (any arguments), second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").unregister
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register do
                        @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@other_kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                end

                context "when first stub with default (any arguments), second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").unregister
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@other_block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                end

                context "when first stub without arguments, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").unregister
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register do
                        @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                end

                context "when first stub without arguments, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").unregister
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register do
                        @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub without arguments, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").unregister
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register do
                        @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                end

                context "when first stub without arguments, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").unregister
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register do
                        @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@other_args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub without arguments, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").unregister
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register do
                        @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@other_kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub without arguments, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").unregister
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@other_block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with any arguments, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").unregister
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register do
                        @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                end

                context "when first stub with any arguments, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").unregister
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register do
                        @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                end

                context "when first stub with any arguments, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").unregister
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register do
                        @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                end

                context "when first stub with any arguments, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").unregister
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register do
                        @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@other_args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                end

                context "when first stub with any arguments, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").unregister
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register do
                        @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@other_kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                end

                context "when first stub with any arguments, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").unregister
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@other_block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                end

                context "when first stub with args, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").unregister
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register do
                        @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@other_args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                end

                context "when first stub with args, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").unregister
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register do
                        @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@other_args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with args, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").unregister
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register do
                        @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@other_args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                end

                context "when first stub with args, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").unregister
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register do
                        @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@other_args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with args, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").unregister
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register do
                        @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@other_args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@other_kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with args, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").unregister
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from first stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@other_args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@other_block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with kwargs, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").unregister
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register do
                        @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@other_kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                end

                context "when first stub with kwargs, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").unregister
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register do
                        @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@other_kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with kwargs, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").unregister
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register do
                        @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@other_kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                end

                context "when first stub with kwargs, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").unregister
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register do
                        @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@other_kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@other_args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with kwargs, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").unregister
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register do
                        @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@other_kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with kwargs, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").unregister
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from first stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@other_kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@other_block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with block, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").unregister
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register do
                        @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@other_block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                end

                context "when first stub with block, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").unregister
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register do
                        @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@other_block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with block, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").unregister
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register do
                        @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@other_block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                end

                context "when first stub with block, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").unregister
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register do
                        @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@other_block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@other_args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with block, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").unregister
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register do
                        @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from second stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from first stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@other_kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@other_block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with block, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").unregister
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from second stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args, **@kwargs, &@block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@other_block).then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end
              end
            end

            context "comparison" do
              setup do
                @klass =
                  Class.new do
                    attr_reader :id

                    def initialize(id)
                      @id = id
                    end

                    def ==(other)
                      return unless other.instance_of?(self.class)

                      id == other.id
                    end

                    def ===(other)
                      raise "Comparison by `===`"
                    end

                    def eql?(other)
                      raise "Comparison by `eql?`"
                    end

                    def equal?(other)
                      raise "Comparison by `equal?`"
                    end
                  end

                @foo = @klass.new(:foo)
                @bar = @klass.new(:bar)
                @baz = @klass.new(:baz)

                @service_class =
                  Class.new do
                    include ConvenientService::Standard::Config

                    def initialize(*args, **kwargs, &block)
                    end

                    def result
                      success(from: "original result")
                    end
                  end

                @args = [@foo]
                @kwargs = {@foo => @bar}
                @block = proc { @foo }

                @other_args = [@bar]
                @other_kwargs = {@bar => @baz}
                @other_block = proc { @bar }
              end

              extend ConvenientService::E2E::Shared::StubVariants

              teardown do
                ##
                # NOTE: First `teardown` is executed the last.
                #
                assert_equal(true, @service_class.stubbed_results.parent.empty?)
              end

              variant "stub/unstub" do
                setup do
                  @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stub without arguments").register
                  @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stub with args").register
                  @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from third stub with kwargs").register
                  @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from fourth stub with block").register
                end

                teardown do
                  @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                  @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                  @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                  @service_class.unstub_result.without_arguments.to_return_result_mock.register
                end
              end

              variant "register/unregister" do
                setup do
                  @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stub without arguments").register
                  @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stub with args").register
                  @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from third stub with kwargs").register
                  @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from fourth stub with block").register
                end

                teardown do
                  @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from fourth stub with block").unregister
                  @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from third stub with kwargs").unregister
                  @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stub with args").unregister
                  @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stub without arguments").unregister
                end
              end

              variant "register(&block)" do
                around do |test|
                  @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stub without arguments").register do
                    @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stub with args").register do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from third stub with kwargs").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from fourth stub with block").register(&test)
                      end
                    end
                  end
                end
              end

              should("work (#{__LINE__})") { assert_equal(true, @service_class.result.then { |result| result.failure? && result.message.to_s == "from first stub without arguments" }) }
              should("work (#{__LINE__})") { assert_equal(true, @service_class.result(*@args).then { |result| result.failure? && result.message.to_s == "from second stub with args" }) }
              should("work (#{__LINE__})") { assert_equal(true, @service_class.result(**@kwargs).then { |result| result.failure? && result.message.to_s == "from third stub with kwargs" }) }
              should("work (#{__LINE__})") { assert_equal(true, @service_class.result(&@block).then { |result| result.failure? && result.message.to_s == "from fourth stub with block" }) }
            end
          end
        end
      end
    end

    context "instance methods" do
      describe "#result" do
        extend ConvenientService::E2E::Shared::StubVariants

        variants.each do |variant_name|
          context variant_name do
            context "arguments" do
              setup do
                @service_class =
                  Class.new do
                    include ConvenientService::Standard::Config

                    def initialize(*args, **kwargs, &block)
                    end

                    def result
                      success(from: "original result")
                    end
                  end

                @args = [:foo]
                @kwargs = {foo: :bar}
                @block = proc { :foo }

                @other_args = [:bar]
                @other_kwargs = {bar: :baz}
                @other_block = proc { :bar }
              end

              context "when NO stubs" do
                should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
              end

              context "when one stub" do
                context "when first stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                end

                context "when first stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                end

                context "when first stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@other_args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@other_kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@other_block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end
              end

              context "when multiple stubs" do
                context "when first stub with default (any arguments), second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").unregister
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register do
                        @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                end

                context "when first stub with default (any arguments), second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").unregister
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register do
                        @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                end

                context "when first stub with default (any arguments), second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").unregister
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register do
                        @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                end

                context "when first stub with default (any arguments), second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").unregister
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register do
                        @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@other_args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                end

                context "when first stub with default (any arguments), second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").unregister
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register do
                        @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@other_kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                end

                context "when first stub with default (any arguments), second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                      @service_class.unstub_result.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").unregister
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.to_return_failure.with_message("from first stubbed result with default (any arguments)").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@other_block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with default (any arguments)" }) }
                end

                context "when first stub without arguments, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").unregister
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register do
                        @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                end

                context "when first stub without arguments, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").unregister
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register do
                        @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub without arguments, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").unregister
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register do
                        @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                end

                context "when first stub without arguments, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").unregister
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register do
                        @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@other_args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub without arguments, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").unregister
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register do
                        @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@other_kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub without arguments, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").unregister
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stubbed result without arguments").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@other_block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with any arguments, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").unregister
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register do
                        @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                end

                context "when first stub with any arguments, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").unregister
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register do
                        @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                end

                context "when first stub with any arguments, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").unregister
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register do
                        @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                end

                context "when first stub with any arguments, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").unregister
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register do
                        @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@other_args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                end

                context "when first stub with any arguments, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").unregister
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register do
                        @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@other_kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                end

                context "when first stub with any arguments, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").unregister
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from first stubbed result with any arguments").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@other_block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with any arguments" }) }
                end

                context "when first stub with args, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").unregister
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register do
                        @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@other_args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                end

                context "when first stub with args, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").unregister
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register do
                        @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@other_args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with args, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").unregister
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register do
                        @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@other_args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                end

                context "when first stub with args, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").unregister
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register do
                        @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@other_args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with args, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").unregister
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register do
                        @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@other_args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@other_kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with args, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").unregister
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from first stubbed result with args").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@other_args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@other_block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with kwargs, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").unregister
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register do
                        @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@other_kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                end

                context "when first stub with kwargs, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").unregister
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register do
                        @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@other_kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with kwargs, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").unregister
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register do
                        @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@other_kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                end

                context "when first stub with kwargs, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").unregister
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register do
                        @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@other_kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@other_args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with kwargs, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").unregister
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register do
                        @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@other_kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with kwargs, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").unregister
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from first stubbed result with kwargs").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@other_kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@other_block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with block, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.unstub_result.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register
                    end

                    teardown do
                      @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").unregister
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register do
                        @service_class.stub_result.to_return_failure.with_message("from second stubbed result with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@other_block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with default (any arguments)" }) }
                end

                context "when first stub with block, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.without_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register
                    end

                    teardown do
                      @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").unregister
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register do
                        @service_class.stub_result.without_arguments.to_return_failure.with_message("from second stubbed result without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result without arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@other_block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with block, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.unstub_result.with_any_arguments.to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register
                    end

                    teardown do
                      @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").unregister
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register do
                        @service_class.stub_result.with_any_arguments.to_return_failure.with_message("from second stubbed result with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@other_block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with any arguments" }) }
                end

                context "when first stub with block, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").unregister
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register do
                        @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stubbed result with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with args" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@other_block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@other_args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with block, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").unregister
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register do
                        @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from second stubbed result with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with kwargs" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from first stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@other_kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@other_block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end

                context "when first stub with block, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @service_class.stubbed_results.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                      @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register
                    end

                    teardown do
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").unregister
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from first stubbed result with block").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from second stubbed result with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from second stubbed result with block" }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args, **@kwargs, &@block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }

                  should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@other_block).result.then { |result| result.success? && result.data.to_h == {from: "original result"} }) }
                end
              end
            end

            context "comparison" do
              setup do
                @klass =
                  Class.new do
                    attr_reader :id

                    def initialize(id)
                      @id = id
                    end

                    def ==(other)
                      return unless other.instance_of?(self.class)

                      id == other.id
                    end

                    def ===(other)
                      raise "Comparison by `===`"
                    end

                    def eql?(other)
                      raise "Comparison by `eql?`"
                    end

                    def equal?(other)
                      raise "Comparison by `equal?`"
                    end
                  end

                @foo = @klass.new(:foo)
                @bar = @klass.new(:bar)
                @baz = @klass.new(:baz)

                @service_class =
                  Class.new do
                    include ConvenientService::Standard::Config

                    def initialize(*args, **kwargs, &block)
                    end

                    def result
                      success(from: "original result")
                    end
                  end

                @args = [@foo]
                @kwargs = {@foo => @bar}
                @block = proc { @foo }

                @other_args = [@bar]
                @other_kwargs = {@bar => @baz}
                @other_block = proc { @bar }
              end

              extend ConvenientService::E2E::Shared::StubVariants

              teardown do
                ##
                # NOTE: First `teardown` is executed the last.
                #
                assert_equal(true, @service_class.stubbed_results.parent.empty?)
              end

              variant "stub/unstub" do
                setup do
                  @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stub without arguments").register
                  @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stub with args").register
                  @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from third stub with kwargs").register
                  @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from fourth stub with block").register
                end

                teardown do
                  @service_class.unstub_result.with_arguments(&@block).to_return_result_mock.register
                  @service_class.unstub_result.with_arguments(**@kwargs).to_return_result_mock.register
                  @service_class.unstub_result.with_arguments(*@args).to_return_result_mock.register
                  @service_class.unstub_result.without_arguments.to_return_result_mock.register
                end
              end

              variant "register/unregister" do
                setup do
                  @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stub without arguments").register
                  @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stub with args").register
                  @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from third stub with kwargs").register
                  @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from fourth stub with block").register
                end

                teardown do
                  @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from fourth stub with block").unregister
                  @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from third stub with kwargs").unregister
                  @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stub with args").unregister
                  @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stub without arguments").unregister
                end
              end

              variant "register(&block)" do
                around do |test|
                  @service_class.stub_result.without_arguments.to_return_failure.with_message("from first stub without arguments").register do
                    @service_class.stub_result.with_arguments(*@args).to_return_failure.with_message("from second stub with args").register do
                      @service_class.stub_result.with_arguments(**@kwargs).to_return_failure.with_message("from third stub with kwargs").register do
                        @service_class.stub_result.with_arguments(&@block).to_return_failure.with_message("from fourth stub with block").register(&test)
                      end
                    end
                  end
                end
              end

              should("work (#{__LINE__})") { assert_equal(true, @service_class.new.result.then { |result| result.failure? && result.message.to_s == "from first stub without arguments" }) }
              should("work (#{__LINE__})") { assert_equal(true, @service_class.new(*@args).result.then { |result| result.failure? && result.message.to_s == "from second stub with args" }) }
              should("work (#{__LINE__})") { assert_equal(true, @service_class.new(**@kwargs).result.then { |result| result.failure? && result.message.to_s == "from third stub with kwargs" }) }
              should("work (#{__LINE__})") { assert_equal(true, @service_class.new(&@block).result.then { |result| result.failure? && result.message.to_s == "from fourth stub with block" }) }
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
