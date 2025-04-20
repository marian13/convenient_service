# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasInspect::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { data_class }

      let(:data_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    describe "#inspect" do
      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def self.name
            "ImportantService"
          end

          def result
            success(data: {foo: +"bar"})
          end
        end
      end

      let(:data) { service.result.unsafe_data }

      before do
        ##
        # TODO: Remove when Core implements auto committing from `inspect`.
        #
        data.class.commit_config!
      end

      it "returns `inspect` representation of result" do
        expect(data.inspect).to eq("<ImportantService::Result::Data foo: \"bar\">")
      end

      specify do
        expect { data.inspect }
          .to delegate_to(data[:foo], :inspect)
          .without_arguments
      end

      context "when `data` has no values" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def self.name
              "ImportantService"
            end

            def result
              success
            end
          end
        end

        it "returns `inspect` representation of result" do
          expect(data.inspect).to eq("<ImportantService::Result::Data>")
        end
      end

      context "when `data` has multiple values" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def self.name
              "ImportantService"
            end

            def result
              success(data: {foo: :bar, baz: :qux})
            end
          end
        end

        it "returns `inspect` representation of result" do
          expect(data.inspect).to eq("<ImportantService::Result::Data foo: :bar, baz: :qux>")
        end
      end

      context "when `data` has long value" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def self.name
              "ImportantService"
            end

            def result
              success(data: {foo: "x" * 16})
            end
          end
        end

        it "truncates that long value" do
          expect(data.inspect).to eq("<ImportantService::Result::Data foo: \"#{"x" * 11}...>")
        end
      end

      context "when service class is anonymous" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(data: {foo: "bar"})
            end
          end
        end

        it "uses custom class name" do
          expect(data.inspect).to eq("<AnonymousClass(##{service.object_id})::Result::Data foo: \"bar\">")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
