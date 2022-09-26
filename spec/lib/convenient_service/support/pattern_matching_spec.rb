# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::PatternMatching do
  example_group "class methoods" do
    describe "#anything" do
      let(:others) do
        [
          nil,
          false,
          true,
          42,
          "foo",
          :foo,
          [],
          {},
          Object.new,
          Module.new,
          Class.new
        ]
      end

      ##
      # NOTE:
      #   The following spec can NOT universally prove that an object with `==` method that always return `true` is returned.
      #   Its purpose to catch syntax errors.
      #
      #   https://ruby-doc.org/core-3.1.2/BasicObject.html#method-c-new
      #   https://ruby-doc.org/core-3.1.2/Object.html#method-i-define_singleton_method
      #
      it "return object with `==` method that always return `true`" do
        expect(others.map { |other| described_class.anything == other }.uniq).to eq([true])
      end
    end

    ##
    # NOTE:
    #   The following specs can NOT universally prove that an unique object per whole Ruby process is returned.
    #   Their purpose to catch syntax errors.
    #
    #   https://ruby-doc.org/core-3.1.2/BasicObject.html#method-c-new
    #
    describe "#unique_value" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      it "return unique object per whole Ruby process" do
        ##
        # NOTE:
        #   The following expection won't work since stub is too global.
        #   `Object.new` can be used somewhere inside `RSpec` for example.
        #
        #   expect { described_class.unique_value }.to delegate_to(Object, :new).and_return_its_value
        #
        # NOTE: Check only syntax.
        #
        expect { described_class.unique_value }.not_to raise_error
      end

      context "when called multiple times" do
        it "return multiple unique objects per whole Ruby process" do
          expect(described_class.unique_value).not_to eq(described_class.unique_value)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
