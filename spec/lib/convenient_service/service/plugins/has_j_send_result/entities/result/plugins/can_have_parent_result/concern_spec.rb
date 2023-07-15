# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveParentResult::Concern do
  include ConvenientService::RSpec::Matchers::CacheItsValue

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      let(:result_class) do
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
    describe "#parent" do
      let(:result) { service.result }

      context "when result has NO parent" do
        let(:service) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              success
            end
          end
        end

        it "returns `nil`" do
          expect(result.parent).to be_nil
        end
      end

      context "when result has parent" do
        let(:service) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Configs::Standard

              step first_step

              def result
                success
              end
            end
          end
        end

        let(:first_step) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              error
            end
          end
        end

        it "returns result parent" do
          expect(result.parent).to eq(first_step.result)
        end

        specify do
          expect { result.parent }.to cache_its_value
        end
      end
    end

    describe "#parents" do
      let(:result) { service.result }

      context "when result has NO parent" do
        let(:service) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              success
            end
          end
        end

        it "returns empty array" do
          expect(result.parents).to eq([])
        end

        specify do
          expect { result.parents }.not_to cache_its_value
        end
      end

      context "when result has one parent" do
        let(:service) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Configs::Standard

              step first_step

              def result
                success
              end
            end
          end
        end

        let(:first_step) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              error
            end
          end
        end

        let(:parents) { [first_step.result] }

        it "returns result parents" do
          expect(result.parents).to eq(parents)
        end

        specify do
          expect { result.parents }.not_to cache_its_value
        end
      end

      context "when result has multiple parent" do
        let(:service) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Configs::Standard

              step first_step

              def result
                success
              end
            end
          end
        end

        let(:first_step) do
          Class.new.tap do |klass|
            klass.class_exec(second_step) do |second_step|
              include ConvenientService::Configs::Standard

              step second_step

              def result
                success
              end
            end
          end
        end

        let(:second_step) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              error
            end
          end
        end

        let(:parents) { [first_step.result, second_step.result] }

        it "returns result parents" do
          expect(result.parents).to eq(parents)
        end

        specify do
          expect { result.parents }.not_to cache_its_value
        end
      end

      example_group "`include_self` option" do
        let(:service) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Configs::Standard

              step first_step

              def result
                success
              end
            end
          end
        end

        let(:first_step) do
          Class.new.tap do |klass|
            klass.class_exec(second_step) do |second_step|
              include ConvenientService::Configs::Standard

              step second_step

              def result
                success
              end
            end
          end
        end

        let(:second_step) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              error
            end
          end
        end

        context "when `include_self` is NOT passed" do
          let(:parents) { [first_step.result, second_step.result] }

          it "defaults to `false`" do
            expect(result.parents).to eq(parents)
          end
        end

        context "when `include_self` is passed" do
          context "when `include_self` is `false`" do
            let(:parents) { [first_step.result, second_step.result] }

            it "returns parents without result" do
              expect(result.parents(include_self: false)).to eq(parents)
            end
          end

          context "when `include_self` is `true`" do
            let(:parents) { [result, first_step.result, second_step.result] }

            it "returns parents with result" do
              expect(result.parents(include_self: true)).to eq(parents)
            end
          end
        end
      end

      example_group "`limit` option" do
        let(:service) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Configs::Standard

              step first_step

              def result
                success
              end
            end
          end
        end

        let(:first_step) do
          Class.new.tap do |klass|
            klass.class_exec(second_step) do |second_step|
              include ConvenientService::Configs::Standard

              step second_step

              def result
                success
              end
            end
          end
        end

        let(:second_step) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              error
            end
          end
        end

        context "when `limit` is NOT passed" do
          let(:parents) { [first_step.result] }

          before do
            stub_const("ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveParentResult::Constants::PARENTS_LIMIT", 1)
          end

          it "defaults to `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveParentResult::Constants::PARENTS_LIMIT`" do
            expect(result.parents).to eq(parents)
          end
        end

        context "when `limit` is passed" do
          let(:parents) { [first_step.result] }

          it "returns limited amount of parents" do
            expect(result.parents(limit: 1)).to eq(parents)
          end
        end
      end
    end

    describe "#parents_enum" do
      let(:result) { service.result }

      let(:service) do
        Class.new.tap do |klass|
          klass.class_exec(first_step) do |first_step|
            include ConvenientService::Configs::Standard

            step first_step

            def result
              success
            end
          end
        end
      end

      let(:first_step) do
        Class.new.tap do |klass|
          klass.class_exec(second_step) do |second_step|
            include ConvenientService::Configs::Standard

            step second_step

            def result
              success
            end
          end
        end
      end

      let(:second_step) do
        Class.new do
          include ConvenientService::Configs::Standard

          def result
            error
          end
        end
      end

      it "returns instance of `Enumerator`" do
        expect(result.parents_enum).to be_instance_of(Enumerator)
      end

      specify do
        expect { result.parents_enum }.not_to cache_its_value
      end

      ##
      # NOTE: Other `parents_enum` behavior is tested indirectly by `parents` specs.
      #
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
