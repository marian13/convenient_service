# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::FiniteLoop, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "constants" do
    describe "::MAX_ITERATION_COUNT" do
      it "is equal to 1000" do
        expect(described_class::MAX_ITERATION_COUNT).to eq(1_000)
      end
    end
  end

  example_group "exceptions" do
    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    specify { expect(described_class::Exceptions::MaxIterationCountExceeded < ConvenientService::Exception).to eq(true) }
    specify { expect(described_class::Exceptions::NoBlockGiven < ConvenientService::Exception).to eq(true) }
  end

  example_group "instance methods" do
    describe "#finite_loop" do
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

        let(:exception_message) do
          <<~TEXT
            `finite_loop` always expects a block to be given.
          TEXT
        end

        it "raises `ConvenientService::Support::FiniteLoop::Exceptions::NoBlockGiven`" do
          expect { instance.foo }
            .to raise_error(described_class::Exceptions::NoBlockGiven)
            .with_message(exception_message)
        end

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
        specify do
          expect(ConvenientService).to receive(:raise).and_call_original

          expect { instance.foo }.to raise_error(described_class::Exceptions::NoBlockGiven)
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies
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
        let(:exception_message) do
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
              .to raise_error(described_class::Exceptions::MaxIterationCountExceeded)
              .with_message(exception_message)
          end

          ##
          # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
          #
          # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
          specify do
            expect(ConvenientService).to receive(:raise).and_call_original

            expect { instance.foo }.to raise_error(described_class::Exceptions::MaxIterationCountExceeded)
          end
          # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies
        end

        context "when `raise_on_exceedance` is set to `false`" do
          context "when `default` is NOT passed" do
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

            it "returns `nil`" do
              expect(instance.foo).to be_nil
            end
          end

          context "when `default` is passed" do
            let(:klass) do
              Class.new(base_klass) do
                ##
                # NOTE: finite_loop is intentionally private. That's why this wrapper is used.
                #
                def foo
                  finite_loop(raise_on_exceedance: false, default: 42) do |index|
                    # NOTE: No `break` to exceed max iteration count.
                  end
                end
              end
            end

            it "returns `default`" do
              expect(instance.foo).to eq(42)
            end
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

          it "raises `ConvenientService::Support::FiniteLoop::Exceptions::MaxIterationCountExceeded`" do
            expect { instance.foo }
              .to raise_error(described_class::Exceptions::MaxIterationCountExceeded)
              .with_message(exception_message)
          end

          ##
          # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
          #
          # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
          specify do
            expect(ConvenientService).to receive(:raise).and_call_original

            expect { instance.foo }.to raise_error(described_class::Exceptions::MaxIterationCountExceeded)
          end
          # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies
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

  example_group "class methods" do
    describe ".finite_loop" do
      let(:max_iteration_count) { 5 }

      before do
        stub_const("ConvenientService::Support::FiniteLoop::MAX_ITERATION_COUNT", max_iteration_count)
      end

      context "when iteration happens" do
        let(:loop_result) do
          described_class.finite_loop do |index|
            break if index >= 3

            print index
          end
        end

        it "passes iteration index to block" do
          expect { loop_result }.to output("012").to_stdout
        end
      end

      context "when NO block is given" do
        let(:loop_result) { described_class.finite_loop }

        let(:exception_message) do
          <<~TEXT
            `finite_loop` always expects a block to be given.
          TEXT
        end

        it "raises `ConvenientService::Support::FiniteLoop::Exceptions::NoBlockGiven`" do
          expect { loop_result }
            .to raise_error(described_class::Exceptions::NoBlockGiven)
            .with_message(exception_message)
        end

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
        specify do
          expect(ConvenientService).to receive(:raise).and_call_original

          expect { loop_result }.to raise_error(described_class::Exceptions::NoBlockGiven)
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies
      end

      context "when `max_iteration_count` is NOT exceeded" do
        let(:loop_result) do
          described_class.finite_loop do |index|
            break index if index >= 3
          end
        end

        it "returns `break` value" do
          expect(loop_result).to eq(3)
        end
      end

      context "when `max_iteration_count` is exceeded" do
        let(:exception_message) do
          <<~TEXT
            Max iteration count is exceeded. Current limit is #{max_iteration_count}.

            Consider using `max_iteration_count` or `raise_on_exceedance` options if that is not the expected behavior.
          TEXT
        end

        context "when `raise_on_exceedance` is NOT passed" do
          let(:loop_result) do
            described_class.finite_loop do |index|
              # NOTE: No `break` to exceed max iteration count.
            end
          end

          it "defaults `raise_on_exceedance` to `true`" do
            expect { loop_result }
              .to raise_error(described_class::Exceptions::MaxIterationCountExceeded)
              .with_message(exception_message)
          end

          ##
          # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
          #
          # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
          specify do
            expect(ConvenientService).to receive(:raise).and_call_original

            expect { loop_result }.to raise_error(described_class::Exceptions::MaxIterationCountExceeded)
          end
          # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies
        end

        context "when `raise_on_exceedance` is set to `false`" do
          context "when `default` is NOT passed" do
            let(:loop_result) do
              described_class.finite_loop(raise_on_exceedance: false) do |index|
                # NOTE: No `break` to exceed max iteration count.
              end
            end

            it "returns `nil`" do
              expect(loop_result).to be_nil
            end
          end

          context "when `default` is passed" do
            let(:loop_result) do
              described_class.finite_loop(raise_on_exceedance: false, default: 42) do |index|
                # NOTE: No `break` to exceed max iteration count.
              end
            end

            it "returns `default`" do
              expect(loop_result).to eq(42)
            end
          end
        end

        context "when `raise_on_exceedance` is set to `true`" do
          let(:loop_result) do
            described_class.finite_loop(raise_on_exceedance: true) do |index|
              # NOTE: No `break` to exceed max iteration count.
            end
          end

          it "raises `ConvenientService::Support::FiniteLoop::Exceptions::MaxIterationCountExceeded`" do
            expect { loop_result }
              .to raise_error(described_class::Exceptions::MaxIterationCountExceeded)
              .with_message(exception_message)
          end

          ##
          # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
          #
          # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
          specify do
            expect(ConvenientService).to receive(:raise).and_call_original

            expect { loop_result }.to raise_error(described_class::Exceptions::MaxIterationCountExceeded)
          end
          # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies
        end
      end

      context "when `max_iteration_count` is NOT passed" do
        let(:loop_result) do
          described_class.finite_loop do |index|
            break if index >= 3

            puts "foo"
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
          expect { loop_result }.to output("foo\n" * 3).to_stdout
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
