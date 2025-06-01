# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Arguments pattern matching", type: [:standard, :e2e] do
  let(:first_step) do
    Class.new do
      include ConvenientService::Standard::Config

      def initialize(foo:, bar:)
        @foo = foo
        @bar = bar
      end

      def self.name
        "FirstStep"
      end

      def result
        success(baz: :first_step_baz, qux: :first_step_qux)
      end
    end
  end

  let(:out) { Tempfile.new }
  let(:output) { out.tap(&:rewind).read }

  let(:result) { service.result(out: out) }
  let(:result_output) { result && output }

  example_group "arguments in around callback" do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(first_step) do |first_step|
          include ConvenientService::Standard::Config

          attr_reader :out

          def initialize(out:)
            @out = out
          end

          private

          def foo
            :foo
          end

          def bar
            :bar
          end

          define_method(:first_step) { first_step }
        end
      end
    end

    specify do
      service.step first_step,
        in: [:foo, :bar],
        out: [:baz, :qux]

      service.around :step do |chain, arguments|
        case arguments
        in [[action]] if action == first_step
          out.print "Matched action"
        end

        chain.yield
      end

      expect { result_output }.to raise_error(NoMatchingPatternError)
    end

    specify do
      service.step first_step,
        in: [:foo, :bar],
        out: [:baz, :qux]

      service.around :step do |chain, arguments|
        case arguments
        in [[action], *] if action == first_step
          out.print "Matched action"
        end

        chain.yield
      end

      expect(result_output).to eq("Matched action")
    end

    ##
    # TODO: Matching of `in`, `out`, `fallback`, `strict`, etc.
    ##
  end
end
