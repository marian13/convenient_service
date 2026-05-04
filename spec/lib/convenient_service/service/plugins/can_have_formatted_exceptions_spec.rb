# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveFormattedExceptions, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".default_max_backtrace_size" do
      specify do
        expect(described_class.default_max_backtrace_size).to eq(described_class::Constants::DEFAULT_MAX_BACKTRACE_SIZE)
      end
    end

    describe ".format_exception" do
      let(:exception) do
        raise ZeroDivisionError, "exception message", caller.take(5)
      rescue => error
        error
      end

      let(:args) { [:foo, :bar] }
      let(:kwargs) { {foo: :bar, baz: :qux} }
      let(:block) { proc { :foo } }
      let(:max_backtrace_size) { 20 }

      specify do
        expect { described_class.format_exception(exception, args: args, kwargs: kwargs, block: block, max_backtrace_size: max_backtrace_size) }
          .to delegate_to(described_class::Commands::FormatException, :call)
          .with_arguments(exception: exception, args: args, kwargs: kwargs, block: block, max_backtrace_size: max_backtrace_size)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
