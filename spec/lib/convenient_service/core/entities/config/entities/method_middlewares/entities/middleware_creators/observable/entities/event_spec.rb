# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Observable::Entities::Event, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:event) { described_class.new(type: type) }
  let(:type) { :before_call }

  let(:observer_class) do
    Class.new do
      def handle_before_call(...)
      end
    end
  end

  let(:observer) { observer_class.new }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { event }

      it { is_expected.to have_attr_reader(:type) }
    end

    describe "#default_handler_name" do
      it "returns `handle_\#{type}`" do
        expect(event.default_handler_name).to eq("handle_#{type}")
      end
    end

    describe "#add_observer" do
      context "when `func` is NOT passed" do
        specify do
          event.add_observer(observer)

          expect { event.notify_observers(*args, **kwargs, &block) }
            .to delegate_to(observer, event.default_handler_name)
            .with_arguments(*args, **kwargs, &block)
        end
      end

      context "when `func` is passed" do
        let(:observer_class) do
          Class.new do
            def foo(...)
            end
          end
        end

        let(:func) { :foo }

        specify do
          event.add_observer(observer, func)

          expect { event.notify_observers(*args, **kwargs, &block) }
            .to delegate_to(observer, func)
            .with_arguments(*args, **kwargs, &block)
        end
      end
    end

    describe "#notify_observers" do
      before do
        event.add_observer(observer)
      end

      specify do
        expect { event.notify_observers(*args, **kwargs, &block) }
          .to delegate_to(observer, event.default_handler_name)
          .with_arguments(*args, **kwargs, &block)
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(event == other).to be_nil
          end
        end

        context "when `other` has different `type`" do
          let(:other) { described_class.new(type: :after_call) }

          it "returns `false`" do
            expect(event == other).to be(false)
          end
        end

        context "when `other` has different `observers`" do
          let(:other) { described_class.new(type: type).tap { |event| event.add_observer(observer) } }

          it "returns `false`" do
            expect(event == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(type: type) }

          it "returns `true`" do
            expect(event == other).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
