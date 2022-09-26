# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::FiniteLoop do
  example_group "constants" do
    describe "::MAX_ITERATION_COUNT" do
      it "is equal to 100" do
        expect(described_class::MAX_ITERATION_COUNT).to eq(100)
      end
    end
  end

  example_group "instance_methods" do
    describe "finite_loop" do
      let(:base_klass) do
        Class.new do
          include ConvenientService::Support::FiniteLoop
        end
      end

      let(:instance) { klass.new }

      let(:max_iteration_count) { 5 }

      before do
        stub_const("ConvenientService::Support::FiniteLoop::MAX_ITERATION_COUNT", max_iteration_count)
      end

      context "when iteration happens" do
        let(:klass) do
          Class.new(base_klass) do
            ##
            # NOTE: finite_loop is intentionally private. That's why this wrapper is used.
            #
            def foo
              finite_loop do |index|
                break if index >= 3

                print index
              end
            end
          end
        end

        it "passes iteration index to block" do
          expect { instance.foo }.to output("012").to_stdout
        end
      end

      context "when NO block is given" do
        let(:klass) do
          Class.new(base_klass) do
            ##
            # NOTE: finite_loop is intentionally private. That's why this wrapper is used.
            #
            def foo
              finite_loop
            end
          end
        end

        let(:error_message) do
          <<~TEXT
            `finite_loop` always expects a block to be given.
          TEXT
        end

        it "raises ConvenientService::Support::FiniteLoop::Errors::NoBlockGiven" do
          expect { instance.foo }
            .to raise_error(ConvenientService::Support::FiniteLoop::Errors::NoBlockGiven)
            .with_message(error_message)
        end
      end

      context "when `max_iteration_count` is NOT exceeded" do
        let(:klass) do
          Class.new(base_klass) do
            ##
            # NOTE: finite_loop is intentionally private. That's why this wrapper is used.
            #
            def foo
              finite_loop do |index|
                break index if index >= 3
              end
            end
          end
        end

        it "returns `break` value" do
          expect(instance.foo).to eq(3)
        end
      end

      context "when `max_iteration_count` is exceeded" do
        let(:error_message) do
          <<~TEXT
            Max iteration count is exceeded. Current limit is #{max_iteration_count}.

            Consider using `max_iteration_count` or `raise_on_exceedance` options if that is not the expected behavior.
          TEXT
        end

        context "when `raise_on_exceedance` is NOT passed" do
          let(:klass) do
            Class.new(base_klass) do
              ##
              # NOTE: finite_loop is intentionally private. That's why this wrapper is used.
              #
              def foo
                finite_loop do |index|
                  # NOTE: No `break` to exceed max iteration count.
                end
              end
            end
          end

          it "defaults `raise_on_exceedance` to `true`" do
            expect { instance.foo }
              .to raise_error(ConvenientService::Support::FiniteLoop::Errors::MaxIterationCountExceeded)
              .with_message(error_message)
          end
        end

        context "when `raise_on_exceedance` is set to `false`" do
          let(:klass) do
            Class.new(base_klass) do
              ##
              # NOTE: finite_loop is intentionally private. That's why this wrapper is used.
              #
              def foo
                finite_loop(raise_on_exceedance: false) do |index|
                  # NOTE: No `break` to exceed max iteration count.
                end
              end
            end
          end

          it "returns nil" do
            expect(instance.foo).to be_nil
          end
        end

        context "when `raise_on_exceedance` is set to `true`" do
          let(:klass) do
            Class.new(base_klass) do
              ##
              # NOTE: finite_loop is intentionally private. That's why this wrapper is used.
              #
              def foo
                finite_loop(raise_on_exceedance: true) do |index|
                  # NOTE: No `break` to exceed max iteration count.
                end
              end
            end
          end

          it "raises ConvenientService::Support::FiniteLoop::Errors::MaxIterationCountExceeded" do
            expect { instance.foo }
              .to raise_error(ConvenientService::Support::FiniteLoop::Errors::MaxIterationCountExceeded)
              .with_message(error_message)
          end
        end
      end

      context "when `max_iteration_count` is NOT passed" do
        let(:klass) do
          Class.new(base_klass) do
            ##
            # NOTE: finite_loop is intentionally private. That's why this wrapper is used.
            #
            def foo
              finite_loop do |index|
                break index if index >= 3

                puts "foo"
              end
            end
          end
        end

        it "uses `ConvenientService::Support::FiniteLoop::MAX_ITERATION_COUNT` as `max_iteration_count` default value" do
          ##
          # NOTE:
          # - MAX_ITERATION_COUNT is stubbed to 5.
          # - max_iteration_count is NOT passed.
          # - foo uses finite loop.
          # - finite loop puts "foo" string on each iteration.
          # - if foo prints "foo" 3 times, test can considered as successful.
          #
          expect { instance.foo }.to output("foo\n" * 3).to_stdout
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
