# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "test_helper"

require "convenient_service"

require_relative "shared/stub_variants"

class ConvenientService::E2E::StubbedFeatureEntriesTest < Minitest::Test
  context "Feature" do
    context "class methods" do
      describe "some entry" do
        extend ConvenientService::E2E::Shared::StubVariants

        variants.each do |variant_name|
          context variant_name do
            context "arguments" do
              setup do
                @feature_class =
                  Class.new do
                    include ConvenientService::Feature::Standard::Config

                    entry :main

                    def main(*args, **kwargs, &block)
                      :value_from_main_entry
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
                should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }
              end

              context "when one stub" do
                context "when first stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                end

                context "when first stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }
                end

                context "when first stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from first stubbed entry with any arguments") }
                end

                context "when first stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@other_args) == :value_from_main_entry) }
                end

                context "when first stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@other_kwargs) == :value_from_main_entry) }
                end

                context "when first stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@other_block) == :value_from_main_entry) }
                end
              end

              context "when multiple stubs" do
                context "when first stub with default (any arguments), second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").unregister
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
                        @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                end

                context "when first stub with default (any arguments), second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").unregister
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
                        @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                end

                context "when first stub with default (any arguments), second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").unregister
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
                        @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from second stubbed entry with any arguments") }
                end

                context "when first stub with default (any arguments), second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").unregister
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
                        @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@other_args) == "from first stubbed entry with default (any arguments)") }
                end

                context "when first stub with default (any arguments), second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").unregister
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
                        @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@other_kwargs) == "from first stubbed entry with default (any arguments)") }
                end

                context "when first stub with default (any arguments), second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").unregister
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@other_block) == "from first stubbed entry with default (any arguments)") }
                end

                context "when first stub without arguments, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").unregister
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register do
                        @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                end

                context "when first stub without arguments, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").unregister
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register do
                        @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }
                end

                context "when first stub without arguments, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").unregister
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register do
                        @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from second stubbed entry with any arguments") }
                end

                context "when first stub without arguments, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").unregister
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register do
                        @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@other_args) == :value_from_main_entry) }
                end

                context "when first stub without arguments, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").unregister
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register do
                        @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@other_kwargs) == :value_from_main_entry) }
                end

                context "when first stub without arguments, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").unregister
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@other_block) == :value_from_main_entry) }
                end

                context "when first stub with any arguments, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").unregister
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register do
                        @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                end

                context "when first stub with any arguments, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").unregister
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register do
                        @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from first stubbed entry with any arguments") }
                end

                context "when first stub with any arguments, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").unregister
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register do
                        @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from second stubbed entry with any arguments") }
                end

                context "when first stub with any arguments, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").unregister
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register do
                        @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from first stubbed entry with any arguments") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@other_args) == "from first stubbed entry with any arguments") }
                end

                context "when first stub with any arguments, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").unregister
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register do
                        @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from first stubbed entry with any arguments") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@other_kwargs) == "from first stubbed entry with any arguments") }
                end

                context "when first stub with any arguments, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").unregister
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from first stubbed entry with any arguments") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@other_block) == "from first stubbed entry with any arguments") }
                end

                context "when first stub with args, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").unregister
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register do
                        @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@other_args) == "from second stubbed entry with default (any arguments)") }
                end

                context "when first stub with args, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").unregister
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register do
                        @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@other_args) == :value_from_main_entry) }
                end

                context "when first stub with args, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").unregister
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register do
                        @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from second stubbed entry with any arguments") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@other_args) == "from second stubbed entry with any arguments") }
                end

                context "when first stub with args, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").unregister
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register do
                        @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@other_args) == :value_from_main_entry) }
                end

                context "when first stub with args, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").unregister
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register do
                        @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@other_args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@other_kwargs) == :value_from_main_entry) }
                end

                context "when first stub with args, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").unregister
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from first stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@other_args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@other_block) == :value_from_main_entry) }
                end

                context "when first stub with kwargs, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").unregister
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register do
                        @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@other_kwargs) == "from second stubbed entry with default (any arguments)") }
                end

                context "when first stub with kwargs, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").unregister
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register do
                        @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@other_kwargs) == :value_from_main_entry) }
                end

                context "when first stub with kwargs, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").unregister
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register do
                        @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from second stubbed entry with any arguments") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@other_kwargs) == "from second stubbed entry with any arguments") }
                end

                context "when first stub with kwargs, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").unregister
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register do
                        @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@other_kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@other_args) == :value_from_main_entry) }
                end

                context "when first stub with kwargs, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").unregister
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register do
                        @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@other_kwargs) == :value_from_main_entry) }
                end

                context "when first stub with kwargs, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").unregister
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from first stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@other_kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@other_block) == :value_from_main_entry) }
                end

                context "when first stub with block, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").unregister
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register do
                        @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@other_block) == "from second stubbed entry with default (any arguments)") }
                end

                context "when first stub with block, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").unregister
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register do
                        @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@other_block) == :value_from_main_entry) }
                end

                context "when first stub with block, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").unregister
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register do
                        @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == "from second stubbed entry with any arguments") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@other_block) == "from second stubbed entry with any arguments") }
                end

                context "when first stub with block, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").unregister
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register do
                        @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@other_block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@other_args) == :value_from_main_entry) }
                end

                context "when first stub with block, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").unregister
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register do
                        @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from second stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from first stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@other_kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@other_block) == :value_from_main_entry) }
                end

                context "when first stub with block, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").unregister
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from second stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@other_block) == :value_from_main_entry) }
                end
              end
            end

            context "comparison" do
              setup do
                @klass =
                  Class.new do
                    attr_reader :id

                    def initialize(id)
                      @@id = id
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

                @feature_class =
                  Class.new do
                    include ConvenientService::Feature::Standard::Config

                    entry :main

                    def main(*args, **kwargs, &block)
                      :value_from_main_entry
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
                assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
              end

              variant "stub/unstub" do
                setup do
                  @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stub without arguments").register
                  @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stub with args").register
                  @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from third stub with kwargs").register
                  @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from fourth stub with block").register
                end

                teardown do
                  @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                  @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                  @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                  @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                end
              end

              variant "register/unregister" do
                setup do
                  @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stub without arguments").register
                  @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stub with args").register
                  @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from third stub with kwargs").register
                  @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from fourth stub with block").register
                end

                teardown do
                  @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from fourth stub with block").unregister
                  @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from third stub with kwargs").unregister
                  @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stub with args").unregister
                  @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stub without arguments").unregister
                end
              end

              variant "register(&block)" do
                around do |test|
                  @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stub without arguments").register do
                    @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stub with args").register do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from third stub with kwargs").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from fourth stub with block").register(&test)
                      end
                    end
                  end
                end
              end

              should("work (#{__LINE__})") { assert_equal(true, @feature_class.main == "from first stub without arguments") }
              should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(*@args) == "from second stub with args") }
              should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(**@kwargs) == "from third stub with kwargs") }
              should("work (#{__LINE__})") { assert_equal(true, @feature_class.main(&@block) == "from fourth stub with block") }
            end
          end
        end
      end
    end

    context "instance methods" do
      describe "some entry" do
        extend ConvenientService::E2E::Shared::StubVariants

        variants.each do |variant_name|
          context variant_name do
            context "arguments" do
              setup do
                @feature_class =
                  Class.new do
                    include ConvenientService::Feature::Standard::Config

                    entry :main

                    def main(*args, **kwargs, &block)
                      :value_from_main_entry
                    end
                  end

                @feature_instance = @feature_class.new

                @args = [:foo]
                @kwargs = {foo: :bar}
                @block = proc { :foo }

                @other_args = [:bar]
                @other_kwargs = {bar: :baz}
                @other_block = proc { :bar }
              end

              context "when NO stubs" do
                should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }
              end

              context "when one stub" do
                context "when first stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                end

                context "when first stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }
                end

                context "when first stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from first stubbed entry with any arguments") }
                end

                context "when first stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@other_args) == :value_from_main_entry) }
                end

                context "when first stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@other_kwargs) == :value_from_main_entry) }
                end

                context "when first stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register(&test)
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@other_block) == :value_from_main_entry) }
                end
              end

              context "when multiple stubs" do
                context "when first stub with default (any arguments), second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").unregister
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
                        @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                end

                context "when first stub with default (any arguments), second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").unregister
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
                        @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                end

                context "when first stub with default (any arguments), second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").unregister
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
                        @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from second stubbed entry with any arguments") }
                end

                context "when first stub with default (any arguments), second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").unregister
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
                        @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@other_args) == "from first stubbed entry with default (any arguments)") }
                end

                context "when first stub with default (any arguments), second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").unregister
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
                        @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@other_kwargs) == "from first stubbed entry with default (any arguments)") }
                end

                context "when first stub with default (any arguments), second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").unregister
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).to_return_value("from first stubbed entry with default (any arguments)").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from first stubbed entry with default (any arguments)") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@other_block) == "from first stubbed entry with default (any arguments)") }
                end

                context "when first stub without arguments, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").unregister
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register do
                        @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                end

                context "when first stub without arguments, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").unregister
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register do
                        @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }
                end

                context "when first stub without arguments, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").unregister
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register do
                        @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from second stubbed entry with any arguments") }
                end

                context "when first stub without arguments, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").unregister
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register do
                        @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@other_args) == :value_from_main_entry) }
                end

                context "when first stub without arguments, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").unregister
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register do
                        @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@other_kwargs) == :value_from_main_entry) }
                end

                context "when first stub without arguments, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").unregister
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stubbed entry without arguments").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@other_block) == :value_from_main_entry) }
                end

                context "when first stub with any arguments, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").unregister
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register do
                        @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                end

                context "when first stub with any arguments, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").unregister
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register do
                        @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from first stubbed entry with any arguments") }
                end

                context "when first stub with any arguments, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").unregister
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register do
                        @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from second stubbed entry with any arguments") }
                end

                context "when first stub with any arguments, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").unregister
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register do
                        @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from first stubbed entry with any arguments") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@other_args) == "from first stubbed entry with any arguments") }
                end

                context "when first stub with any arguments, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").unregister
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register do
                        @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from first stubbed entry with any arguments") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@other_kwargs) == "from first stubbed entry with any arguments") }
                end

                context "when first stub with any arguments, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").unregister
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from first stubbed entry with any arguments").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from first stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from first stubbed entry with any arguments") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@other_block) == "from first stubbed entry with any arguments") }
                end

                context "when first stub with args, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").unregister
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register do
                        @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@other_args) == "from second stubbed entry with default (any arguments)") }
                end

                context "when first stub with args, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").unregister
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register do
                        @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@other_args) == :value_from_main_entry) }
                end

                context "when first stub with args, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").unregister
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register do
                        @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from second stubbed entry with any arguments") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@other_args) == "from second stubbed entry with any arguments") }
                end

                context "when first stub with args, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").unregister
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register do
                        @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@other_args) == :value_from_main_entry) }
                end

                context "when first stub with args, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").unregister
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register do
                        @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@other_args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@other_kwargs) == :value_from_main_entry) }
                end

                context "when first stub with args, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").unregister
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from first stubbed entry with args").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from first stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@other_args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@other_block) == :value_from_main_entry) }
                end

                context "when first stub with kwargs, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").unregister
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register do
                        @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@other_kwargs) == "from second stubbed entry with default (any arguments)") }
                end

                context "when first stub with kwargs, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").unregister
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register do
                        @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@other_kwargs) == :value_from_main_entry) }
                end

                context "when first stub with kwargs, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").unregister
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register do
                        @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from second stubbed entry with any arguments") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@other_kwargs) == "from second stubbed entry with any arguments") }
                end

                context "when first stub with kwargs, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").unregister
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register do
                        @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@other_kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@other_args) == :value_from_main_entry) }
                end

                context "when first stub with kwargs, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").unregister
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register do
                        @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@other_kwargs) == :value_from_main_entry) }
                end

                context "when first stub with kwargs, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").unregister
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from first stubbed entry with kwargs").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from first stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@other_kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@other_block) == :value_from_main_entry) }
                end

                context "when first stub with block, second stub with default (any arguments)" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").unregister
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register do
                        @feature_class.stub_entry(:main).to_return_value("from second stubbed entry with default (any arguments)").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from second stubbed entry with default (any arguments)") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@other_block) == "from second stubbed entry with default (any arguments)") }
                end

                context "when first stub with block, second stub without arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").unregister
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register do
                        @feature_class.stub_entry(:main).without_arguments.to_return_value("from second stubbed entry without arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry without arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@other_block) == :value_from_main_entry) }
                end

                context "when first stub with block, second stub with any arguments" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_any_arguments.to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").unregister
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register do
                        @feature_class.stub_entry(:main).with_any_arguments.to_return_value("from second stubbed entry with any arguments").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == "from second stubbed entry with any arguments") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == "from second stubbed entry with any arguments") }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@other_block) == "from second stubbed entry with any arguments") }
                end

                context "when first stub with block, second stub with args" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").unregister
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register do
                        @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stubbed entry with args").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stubbed entry with args") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@other_block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@other_args) == :value_from_main_entry) }
                end

                context "when first stub with block, second stub with kwargs" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").unregister
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register do
                        @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from second stubbed entry with kwargs").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from second stubbed entry with kwargs") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from first stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@other_block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@other_kwargs) == :value_from_main_entry) }
                end

                context "when first stub with block, second stub with block" do
                  extend ConvenientService::E2E::Shared::StubVariants

                  teardown do
                    ##
                    # NOTE: First `teardown` is executed the last.
                    #
                    assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
                  end

                  variant "stub/unstub" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                    end
                  end

                  variant "register/unregister" do
                    setup do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register
                    end

                    teardown do
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").unregister
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").unregister
                    end
                  end

                  variant "register(&block)" do
                    around do |test|
                      @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from first stubbed entry with block").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from second stubbed entry with block").register(&test)
                      end
                    end
                  end

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from second stubbed entry with block") }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs, &@block) == :value_from_main_entry) }
                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args, **@kwargs, &@block) == :value_from_main_entry) }

                  should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@other_block) == :value_from_main_entry) }
                end
              end
            end

            context "comparison" do
              setup do
                @klass =
                  Class.new do
                    attr_reader :id

                    def initialize(id)
                      @@id = id
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

                @feature_class =
                  Class.new do
                    include ConvenientService::Feature::Standard::Config

                    entry :main

                    def main(*args, **kwargs, &block)
                      :value_from_main_entry
                    end
                  end

                @feature_instance = @feature_class.new

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
                assert_equal(true, @feature_class.stubbed_entries.parent.empty?)
              end

              variant "stub/unstub" do
                setup do
                  @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stub without arguments").register
                  @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stub with args").register
                  @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from third stub with kwargs").register
                  @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from fourth stub with block").register
                end

                teardown do
                  @feature_class.unstub_entry(:main).with_arguments(&@block).to_return_value_mock.register
                  @feature_class.unstub_entry(:main).with_arguments(**@kwargs).to_return_value_mock.register
                  @feature_class.unstub_entry(:main).with_arguments(*@args).to_return_value_mock.register
                  @feature_class.unstub_entry(:main).without_arguments.to_return_value_mock.register
                end
              end

              variant "register/unregister" do
                setup do
                  @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stub without arguments").register
                  @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stub with args").register
                  @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from third stub with kwargs").register
                  @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from fourth stub with block").register
                end

                teardown do
                  @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from fourth stub with block").unregister
                  @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from third stub with kwargs").unregister
                  @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stub with args").unregister
                  @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stub without arguments").unregister
                end
              end

              variant "register(&block)" do
                around do |test|
                  @feature_class.stub_entry(:main).without_arguments.to_return_value("from first stub without arguments").register do
                    @feature_class.stub_entry(:main).with_arguments(*@args).to_return_value("from second stub with args").register do
                      @feature_class.stub_entry(:main).with_arguments(**@kwargs).to_return_value("from third stub with kwargs").register do
                        @feature_class.stub_entry(:main).with_arguments(&@block).to_return_value("from fourth stub with block").register(&test)
                      end
                    end
                  end
                end
              end

              should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main == "from first stub without arguments") }
              should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(*@args) == "from second stub with args") }
              should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(**@kwargs) == "from third stub with kwargs") }
              should("work (#{__LINE__})") { assert_equal(true, @feature_instance.main(&@block) == "from fourth stub with block") }
            end
          end
        end
      end
    end
  end
end
