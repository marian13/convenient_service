# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Module::GetOwnInstanceMethod do
  describe ".call" do
    let(:method_name) { :result }

    def create_module_with_result_method
      Module.new do
        def result
          super
        end
      end
    end

    context "when `klass` does NOT have prepended modules" do
      context "when `klass` does NOT have own method" do
        let(:klass) { Class.new }

        it "returns `nil`" do
          expect(described_class.call(klass, method_name)).to be_nil
        end
      end

      context "when `klass` has own method" do
        let(:klass) do
          Class.new do
            def result
            end
          end
        end

        let(:own_method) { klass.instance_method(method_name) }

        it "returns method from `klass`" do
          expect(described_class.call(klass, method_name)).to eq(own_method)
        end
      end
    end

    context "when `klass` has prepended modules" do
      context "when `klass` does NOT have more than `ConvenientService::Support::FiniteLoop::MAX_ITERATION_COUNT` prepended modules" do
        context "when `klass` does NOT have own method" do
          let(:klass) do
            mod_1 = create_module_with_result_method
            mod_2 = create_module_with_result_method

            Class.new do
              prepend mod_1
              prepend mod_2
            end
          end

          it "returns `nil`" do
            expect(described_class.call(klass, method_name)).to be_nil
          end
        end

        context "when `klass` has own method" do
          let(:klass) do
            mod_1 = create_module_with_result_method
            mod_2 = create_module_with_result_method

            Class.new do
              prepend mod_1
              prepend mod_2

              def result
              end
            end
          end

          let(:own_method) { klass.instance_method(method_name).super_method.super_method }

          it "returns method from `klass`" do
            expect(described_class.call(klass, method_name)).to eq(own_method)
          end
        end
      end

      context "when `klass` has more than `ConvenientService::Support::FiniteLoop::MAX_ITERATION_COUNT` prepended modules" do
        let(:klass) do
          mod_1 = create_module_with_result_method
          mod_2 = create_module_with_result_method
          mod_3 = create_module_with_result_method

          Class.new do
            prepend mod_1
            prepend mod_2
            prepend mod_3

            def result
            end
          end
        end

        let(:own_method) { klass.instance_method(method_name).super_method.super_method.super_method }

        let(:max_iteration_count) { 2 }

        let(:error_message) do
          <<~TEXT
            Max iteration count is exceeded. Current limit is #{max_iteration_count}.

            Consider using `max_iteration_count` or `raise_on_exceedance` options if that is not the expected behavior.
          TEXT
        end

        before do
          stub_const("ConvenientService::Support::FiniteLoop::MAX_ITERATION_COUNT", max_iteration_count)
        end

        it "raises `ConvenientService::Support::FiniteLoop::Exceptions::MaxIterationCountExceeded`" do
          expect { described_class.call(klass, method_name) }
            .to raise_error(ConvenientService::Support::FiniteLoop::Exceptions::MaxIterationCountExceeded)
            .with_message(error_message)
        end

        it "supports `max_iteration_count` option" do
          expect(described_class.call(klass, method_name, max_iteration_count: 10)).to eq(own_method)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
