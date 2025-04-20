# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

##
# NOTE: This class is tested in behavior style, imagining having no knowledge about implementation.
# NOTE: Do not forget to check coverage when modifying source.
#
# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo, type: :standard do
  include ConvenientService::RSpec::PrimitiveHelpers::IgnoringException

  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  subject(:matcher_result) { matcher.matches?(block_expectation) }

  let(:matcher) { described_class.new(object, method) }

  let(:klass) do
    Class.new do
      def foo(...)
        bar(...)
      end

      def bar(...)
        "bar value"
      end
    end
  end

  let(:object) { klass.new }
  let(:method) { :bar }

  let(:block_expectation) { proc { object.foo } }
  let(:printable_method) { "#{klass}##{method}" }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "attributes" do
    include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

    subject { matcher }

    it { is_expected.to have_attr_reader(:inputs) }
    it { is_expected.to have_attr_reader(:outputs) }
  end

  example_group "class methods" do
    describe "#new" do
      let(:matcher) { described_class.new(object, method, block_expectation) }

      it "sets `inputs` initial value" do
        expect(matcher.inputs).to eq(described_class::Entities::Inputs.new(object: object, method: method, block_expectation: block_expectation))
      end

      it "sets `outputs` initial value" do
        expect(matcher.outputs).to eq(described_class::Entities::Outputs.new)
      end

      context "when `block_expectation` is NOT passed" do
        let(:matcher) { described_class.new(object, method) }

        it "defaults to empty proc" do
          ##
          # TODO: Introduce to `be_empty_proc` matcher.
          #
          expect([matcher.inputs.block_expectation.instance_of?(Proc), ConvenientService::Support::UNDEFINED[matcher.inputs.block_expectation.call]]).to all eq(true)
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#matches?" do
      context "when NO sub matcher``````                                                     is used" do
        let(:matcher) { described_class.new(object, method) }

        ##
        # NOTE: `expect {}.to delegate_to(object, :bar)`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates once without arguments" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args) }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates once with any arguments" do
            let(:block_expectation) { proc { object.foo(*args) } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { 3.times { object.foo } }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates all times without arguments" do
            let(:block_expectation) { proc { 3.times { object.foo } } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*kwargs); object.foo(&block) } }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates some times with arguments" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo(*kwargs)
                object.foo(&block)
              end
            end

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs, &block) } }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates all times with arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs, &block) } } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end
      end

      context "when used with `without_arguments`" do
        let(:matcher) { described_class.new(object, method).without_arguments }

        ##
        # NOTE: `expect {}.to delegate_to(object, :bar).without_arguments`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates once without arguments" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args) }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates once with any arguments" do
            let(:block_expectation) { proc { object.foo(*args) } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { 3.times { object.foo } }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates all times without arguments" do
            let(:block_expectation) { proc { 3.times { object.foo } } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*kwargs); object.foo(&block) } }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates some times with arguments" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo(*kwargs)
                object.foo(&block)
              end
            end

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs, &block) } }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates all times with arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs, &block) } } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end
        end
      end

      context "when used with `with_any_arguments`" do
        let(:matcher) { described_class.new(object, method).with_any_arguments }

        ##
        # NOTE: `expect {}.to delegate_to(object, :bar).with_any_arguments`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates once without arguments" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args) }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates once with any arguments" do
            let(:block_expectation) { proc { object.foo(*args) } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { 3.times { object.foo } }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates all times without arguments" do
            let(:block_expectation) { proc { 3.times { object.foo } } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*kwargs); object.foo(&block) } }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates some times with arguments" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo(*kwargs)
                object.foo(&block)
              end
            end

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs, &block) } }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates all times with arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs, &block) } } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end
      end

      context "when used with `with_arguments(*args, **kwargs, &block)` (concrete arguments)" do
        let(:matcher) { described_class.new(object, method).with_arguments(*args, **kwargs, &block) }

        ##
        # NOTE: `expect {}.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates once without arguments" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args) }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates once with any arguments" do
            let(:block_expectation) { proc { object.foo(*args) } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args, **kwargs, &block) }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates once with concrete arguments" do
            let(:block_expectation) { proc { object.foo(*args, **kwargs, &block) } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { 3.times { object.foo } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates all times without arguments" do
            let(:block_expectation) { proc { 3.times { object.foo } } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*kwargs); object.foo(&block) } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates some times with any arguments" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo(*kwargs)
                object.foo(&block)
              end
            end

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*args, **kwargs, &block); object.foo(&block) } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates some times with concrete arguments" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo(*args, **kwargs, &block)
                object.foo(&block)
              end
            end

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs) } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates all times with any arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs) } } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs, &block) } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates all times with concrete arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs, &block) } } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end
      end

      context "when used with `and_return_its_value`" do
        let(:matcher) { described_class.new(object, method).and_return_its_value }

        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar).and_return_its_value`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo; 42 }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` does NOT return delegation value" do
            let(:block_expectation) do
              proc do
                object.foo
                42
              end
            end

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` returns delegation value" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { object.foo; object.foo; 42 }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` does NOT return delegation value" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo
                42
              end
            end

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo; object.foo }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` returns delegation value" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo
                object.foo
              end
            end

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end
      end

      context "when used with `and_return`" do
        let(:matcher) { described_class.new(object, method).and_return { |delegation_value| delegation_value } }

        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar).and_return { |delegation_value| delegation_value }`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo; 42 }.to delegate_to(object, :bar).and_return { |delegation_value| delegation_value }`
          #
          context "when `block_expectation` does NOT return custom value" do
            let(:block_expectation) do
              proc do
                object.foo
                42
              end
            end

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).and_return { |delegation_value| delegation_value }`
          #
          context "when `block_expectation` returns custom value" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { object.foo; object.foo; 42 }.to delegate_to(object, :bar).and_return { |delegation_value| delegation_value }`
          #
          context "when `block_expectation` does NOT return custom value" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo
                42
              end
            end

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo; object.foo }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` returns custom value" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo
                object.foo
              end
            end

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end
      end
    end

    describe "#does_not_match?" do
      subject(:negative_matcher_result) { matcher.does_not_match?(block_expectation) }

      context "when NO sub matchers used" do
        let(:matcher) { described_class.new(object, method) }

        ##
        # NOTE: `expect {}.to delegate_to(object, :bar)`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `true`" do
            expect(negative_matcher_result).to eq(true)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates once without arguments" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args) }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates once with any arguments" do
            let(:block_expectation) { proc { object.foo(*args) } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { 3.times { object.foo } }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates all times without arguments" do
            let(:block_expectation) { proc { 3.times { object.foo } } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*kwargs); object.foo(&block) } }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates some times with arguments" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo(*kwargs)
                object.foo(&block)
              end
            end

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs, &block) } }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates all times with arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs, &block) } } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end
        end
      end

      context "when used with `without_arguments`" do
        let(:matcher) { described_class.new(object, method).without_arguments }

        ##
        # NOTE: `expect {}.to delegate_to(object, :bar).without_arguments`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `true`" do
            expect(negative_matcher_result).to eq(true)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates once without arguments" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args) }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates once with any arguments" do
            let(:block_expectation) { proc { object.foo(*args) } }

            it "returns `true`" do
              expect(negative_matcher_result).to eq(true)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { 3.times { object.foo } }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates all times without arguments" do
            let(:block_expectation) { proc { 3.times { object.foo } } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*kwargs); object.foo(&block) } }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates some times with arguments" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo(*kwargs)
                object.foo(&block)
              end
            end

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs, &block) } }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates all times with arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs, &block) } } }

            it "returns `true`" do
              expect(negative_matcher_result).to eq(true)
            end
          end
        end
      end

      context "when used with `with_any_arguments`" do
        let(:matcher) { described_class.new(object, method).with_any_arguments }

        ##
        # NOTE: `expect {}.to delegate_to(object, :bar).with_any_arguments`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `true`" do
            expect(negative_matcher_result).to eq(true)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates once without arguments" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args) }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates once with any arguments" do
            let(:block_expectation) { proc { object.foo(*args) } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { 3.times { object.foo } }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates all times without arguments" do
            let(:block_expectation) { proc { 3.times { object.foo } } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*kwargs); object.foo(&block) } }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates some times with arguments" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo(*kwargs)
                object.foo(&block)
              end
            end

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs, &block) } }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates all times with arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs, &block) } } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end
        end
      end

      context "when used with `with_arguments(*args, **kwargs, &block)` (concrete arguments)" do
        let(:matcher) { described_class.new(object, method).with_arguments(*args, **kwargs, &block) }

        ##
        # NOTE: `expect {}.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `true`" do
            expect(negative_matcher_result).to eq(true)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates once without arguments" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `true`" do
              expect(negative_matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args) }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates once with any arguments" do
            let(:block_expectation) { proc { object.foo(*args) } }

            it "returns `true`" do
              expect(negative_matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args, **kwargs, &block) }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates once with concrete arguments" do
            let(:block_expectation) { proc { object.foo(*args, **kwargs, &block) } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { 3.times { object.foo } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates all times without arguments" do
            let(:block_expectation) { proc { 3.times { object.foo } } }

            it "returns `true`" do
              expect(negative_matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*kwargs); object.foo(&block) } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates some times with any arguments" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo(*kwargs)
                object.foo(&block)
              end
            end

            it "returns `true`" do
              expect(negative_matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*args, **kwargs, &block); object.foo(&block) } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates some times with concrete arguments" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo(*args, **kwargs, &block)
                object.foo(&block)
              end
            end

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs) } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates all times with any arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs) } } }

            it "returns `true`" do
              expect(negative_matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs, &block) } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates all times with concrete arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs, &block) } } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end
        end
      end

      context "when used with `and_return_its_value`" do
        let(:matcher) { described_class.new(object, method).and_return_its_value }

        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar).and_return_its_value`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `true`" do
            expect(negative_matcher_result).to eq(true)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo; 42 }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` does NOT return delegation value" do
            let(:block_expectation) do
              proc do
                object.foo
                42
              end
            end

            it "returns `true`" do
              expect(negative_matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` returns delegation value" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { object.foo; object.foo; 42 }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` does NOT return delegation value" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo
                42
              end
            end

            it "returns `true`" do
              expect(negative_matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo; object.foo }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` returns delegation value" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo
                object.foo
              end
            end

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end
        end
      end

      context "when used with `and_return`" do
        let(:matcher) { described_class.new(object, method).and_return { |delegation_value| delegation_value } }

        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar).and_return { |delegation_value| delegation_value }`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `true`" do
            expect(negative_matcher_result).to eq(true)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo; 42 }.to delegate_to(object, :bar).and_return { |delegation_value| delegation_value }`
          #
          context "when `block_expectation` does NOT return custom value" do
            let(:block_expectation) do
              proc do
                object.foo
                42
              end
            end

            it "returns `true`" do
              expect(negative_matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).and_return { |delegation_value| delegation_value }`
          #
          context "when `block_expectation` returns custom value" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { object.foo; object.foo; 42 }.to delegate_to(object, :bar).and_return { |delegation_value| delegation_value }`
          #
          context "when `block_expectation` does NOT return custom value" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo
                42
              end
            end

            it "returns `true`" do
              expect(negative_matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo; object.foo }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` returns custom value" do
            let(:block_expectation) do
              proc do
                object.foo
                object.foo
                object.foo
              end
            end

            it "returns `false`" do
              expect(negative_matcher_result).to eq(false)
            end
          end
        end
      end
    end

    describe "#supports_block_expectations?" do
      it "returns `true`" do
        expect(matcher.supports_block_expectations?).to eq(true)
      end
    end

    describe "#description" do
      it "returns message" do
        matcher_result

        expect(matcher.description).to eq("delegate to `#{printable_method}`")
      end
    end

    describe "#failure_message" do
      it "returns `sub_matchers` failure message" do
        expect(matcher.failure_message).to eq(matcher.sub_matchers.failure_message)
      end
    end

    describe "#failure_message_when_negated" do
      it "returns `sub_matchers` failure message when negated" do
        expect(matcher.failure_message_when_negated).to eq(matcher.sub_matchers.failure_message_when_negated)
      end
    end

    describe "#with_arguments" do
      context "when arguments `sub_matcher` is NOT used yet" do
        it "sets `expected_arguments`" do
          matcher.with_arguments(*args, **kwargs, &block)

          expect(matcher.inputs.expected_arguments).to eq(ConvenientService::Support::Arguments.new(*args, **kwargs, &block))
        end

        it "sets `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::WithConcreteArguments` instance as argument sub matcher``````                                                    " do
          matcher.with_arguments(*args, **kwargs, &block)

          expect(matcher.sub_matchers.arguments).to be_instance_of(described_class::Entities::SubMatchers::WithConcreteArguments)
        end

        it "returns matcher" do
          expect(matcher.with_arguments(*args, **kwargs, &block)).to eq(matcher)
        end
      end

      context "when arguments `sub_matcher` is already used" do
        let(:exception_message) do
          <<~TEXT
            Arguments chaining is already set.

            Did you use `with_arguments`, `with_any_arguments` or `without_arguments` multiple times? Or a combination of them?
          TEXT
        end

        before do
          matcher.with_arguments(*args, **kwargs, &block)
        end

        it "raises `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::ArgumentsChainingIsAlreadySet`" do
          expect { matcher.with_arguments(*args, **kwargs, &block) }
            .to raise_error(described_class::Exceptions::ArgumentsChainingIsAlreadySet)
            .with_message(exception_message)
        end

        it "delegates to `ConvenientService.raise`" do
          allow(ConvenientService).to receive(:raise).and_call_original

          ignoring_exception(described_class::Exceptions::ArgumentsChainingIsAlreadySet) { matcher.with_arguments(*args, **kwargs, &block) }

          expect(ConvenientService).to have_received(:raise)
        end
      end
    end

    describe "#with_any_arguments" do
      context "when arguments `sub_matcher` is NOT used yet" do
        it "sets `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::WithAnyArguments` instance as argument sub matcher``````                                                   " do
          matcher.with_any_arguments

          expect(matcher.sub_matchers.arguments).to be_instance_of(described_class::Entities::SubMatchers::WithAnyArguments)
        end

        it "returns matcher" do
          expect(matcher.with_any_arguments).to eq(matcher)
        end
      end

      context "when arguments `sub_matcher` is already used" do
        let(:exception_message) do
          <<~TEXT
            Arguments chaining is already set.

            Did you use `with_arguments`, `with_any_arguments` or `without_arguments` multiple times? Or a combination of them?
          TEXT
        end

        before do
          matcher.with_any_arguments
        end

        it "raises `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::ArgumentsChainingIsAlreadySet`" do
          expect { matcher.with_any_arguments }
            .to raise_error(described_class::Exceptions::ArgumentsChainingIsAlreadySet)
            .with_message(exception_message)
        end

        it "delegates to `ConvenientService.raise`" do
          allow(ConvenientService).to receive(:raise).and_call_original

          ignoring_exception(described_class::Exceptions::ArgumentsChainingIsAlreadySet) { matcher.with_any_arguments }

          expect(ConvenientService).to have_received(:raise)
        end
      end
    end

    describe "#without_arguments" do
      context "when arguments `sub_matcher` is NOT used yet" do
        it "sets `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::WithoutArguments` instance as argument sub matcher``````                                                   " do
          matcher.without_arguments

          expect(matcher.sub_matchers.arguments).to be_instance_of(described_class::Entities::SubMatchers::WithoutArguments)
        end

        it "returns matcher" do
          expect(matcher.without_arguments).to eq(matcher)
        end
      end

      context "when arguments `sub_matcher` is already used" do
        let(:exception_message) do
          <<~TEXT
            Arguments chaining is already set.

            Did you use `with_arguments`, `with_any_arguments` or `without_arguments` multiple times? Or a combination of them?
          TEXT
        end

        before do
          matcher.without_arguments
        end

        it "raises `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::ArgumentsChainingIsAlreadySet`" do
          expect { matcher.without_arguments }
            .to raise_error(described_class::Exceptions::ArgumentsChainingIsAlreadySet)
            .with_message(exception_message)
        end

        it "delegates to `ConvenientService.raise`" do
          allow(ConvenientService).to receive(:raise).and_call_original

          ignoring_exception(described_class::Exceptions::ArgumentsChainingIsAlreadySet) { matcher.without_arguments }

          expect(ConvenientService).to have_received(:raise)
        end
      end
    end

    describe "#and_return_its_value" do
      context "when return value `sub_matcher` is NOT used yet" do
        it "sets `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::ReturnDelegationValue` instance as return value sub matcher``````                                                    " do
          matcher.and_return_its_value

          expect(matcher.sub_matchers.return_value).to be_instance_of(described_class::Entities::SubMatchers::ReturnDelegationValue)
        end

        it "returns matcher" do
          expect(matcher.and_return_its_value).to eq(matcher)
        end
      end

      context "when return value `sub_matcher` is already used" do
        let(:exception_message) do
          <<~TEXT
            Returns value chaining is already set.

            Did you use `and_return_its_value` or `and_return { |delegation_value| ... }` multiple times? Or a combination of them?
          TEXT
        end

        before do
          matcher.and_return_its_value
        end

        it "raises `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::ReturnValueChainingIsAlreadySet`" do
          expect { matcher.and_return_its_value }
            .to raise_error(described_class::Exceptions::ReturnValueChainingIsAlreadySet)
            .with_message(exception_message)
        end

        it "delegates to `ConvenientService.raise`" do
          allow(ConvenientService).to receive(:raise).and_call_original

          ignoring_exception(described_class::Exceptions::ReturnValueChainingIsAlreadySet) { matcher.and_return_its_value }

          expect(ConvenientService).to have_received(:raise)
        end
      end
    end

    describe "#and_return" do
      context "when return value `sub_matcher` is NOT used yet" do
        it "sets `expected_arguments`" do
          matcher.and_return(&block)

          expect(matcher.inputs.expected_return_value_block).to eq(block)
        end

        it "sets `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::ReturnCustomValue` instance as return value sub matcher``````                                                    " do
          matcher.and_return(&block)

          expect(matcher.sub_matchers.return_value).to be_instance_of(described_class::Entities::SubMatchers::ReturnCustomValue)
        end

        it "returns matcher" do
          expect(matcher.and_return(&block)).to eq(matcher)
        end
      end

      context "when return value `sub_matcher` is already used" do
        let(:exception_message) do
          <<~TEXT
            Returns value chaining is already set.

            Did you use `and_return_its_value` or `and_return { |delegation_value| ... }` multiple times? Or a combination of them?
          TEXT
        end

        before do
          matcher.and_return(&block)
        end

        it "raises `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::ReturnValueChainingIsAlreadySet`" do
          expect { matcher.and_return(&block) }
            .to raise_error(described_class::Exceptions::ReturnValueChainingIsAlreadySet)
            .with_message(exception_message)
        end

        it "delegates to `ConvenientService.raise`" do
          allow(ConvenientService).to receive(:raise).and_call_original

          ignoring_exception(described_class::Exceptions::ReturnValueChainingIsAlreadySet) { matcher.and_return(&block) }

          expect(ConvenientService).to have_received(:raise)
        end
      end
    end

    describe "#with_calling_original" do
      context "when call original `sub_matcher` is NOT used yet" do
        it "sets `inputs.should_call_original` as `true`" do
          matcher.with_calling_original

          expect(matcher.inputs.should_call_original?).to eq(true)
        end

        it "returns matcher" do
          expect(matcher.with_calling_original).to eq(matcher)
        end
      end

      context "when call original `sub_matcher` is already used" do
        let(:exception_message) do
          <<~TEXT
            Call original chaining is already set.

            Did you use `with_calling_original` or `without_calling_original` multiple times? Or a combination of them?
          TEXT
        end

        before do
          matcher.with_calling_original
        end

        it "raises `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::ChainingsCollection::Exceptions::CallOriginalChainingIsAlreadySet`" do
          expect { matcher.with_calling_original }
            .to raise_error(described_class::Exceptions::CallOriginalChainingIsAlreadySet)
            .with_message(exception_message)
        end

        it "delegates to `ConvenientService.raise`" do
          allow(ConvenientService).to receive(:raise).and_call_original

          ignoring_exception(described_class::Exceptions::CallOriginalChainingIsAlreadySet) { matcher.with_calling_original }

          expect(ConvenientService).to have_received(:raise)
        end
      end
    end

    describe "#without_calling_original" do
      context "when call original `sub_matcher` is NOT used yet" do
        it "sets `inputs.should_call_original` as `true`" do
          matcher.without_calling_original

          expect(matcher.inputs.should_call_original?).to eq(false)
        end

        it "returns matcher" do
          expect(matcher.without_calling_original).to eq(matcher)
        end
      end

      context "when call original `sub_matcher` is already used" do
        let(:exception_message) do
          <<~TEXT
            Call original chaining is already set.

            Did you use `with_calling_original` or `without_calling_original` multiple times? Or a combination of them?
          TEXT
        end

        before do
          matcher.without_calling_original
        end

        it "raises `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::ChainingsCollection::Exceptions::CallOriginalChainingIsAlreadySet`" do
          expect { matcher.without_calling_original }
            .to raise_error(described_class::Exceptions::CallOriginalChainingIsAlreadySet)
            .with_message(exception_message)
        end

        it "delegates to `ConvenientService.raise`" do
          allow(ConvenientService).to receive(:raise).and_call_original

          ignoring_exception(described_class::Exceptions::CallOriginalChainingIsAlreadySet) { matcher.without_calling_original }

          expect(ConvenientService).to have_received(:raise)
        end
      end
    end

    describe "#sub_matchers" do
      it "returns sub matcher collection" do
        expect(matcher.sub_matchers).to be_instance_of(described_class::Entities::SubMatcherCollection)
      end

      specify do
        expect { matcher.sub_matchers }.to cache_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:matcher) { described_class.new(object, method, block_expectation) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(matcher == other).to be_nil
          end
        end

        context "when `other` has different `object`" do
          let(:other) { described_class.new(Object.new, method, block_expectation) }

          it "returns `false`" do
            expect(matcher == other).to eq(false)
          end
        end

        context "when `other` has different `method`" do
          let(:other) { described_class.new(object, :qux, block_expectation) }

          it "returns `false`" do
            expect(matcher == other).to eq(false)
          end
        end

        context "when `other` has different `block_expectation`" do
          let(:other) { described_class.new(object, method, proc { :qux }) }

          it "returns `false`" do
            expect(matcher == other).to eq(false)
          end
        end

        context "when `other` has different `delegations`" do
          let(:other) { described_class.new(object, method, block_expectation).tap { |matcher| matcher.outputs.delegations << double } }

          it "returns `false`" do
            expect(matcher == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(object, method, block_expectation) }

          it "returns `true`" do
            expect(matcher == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
