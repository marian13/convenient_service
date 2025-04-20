# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Utils::Object::GetOwnMethod, type: :standard do
  describe ".call" do
    let(:util_result) { described_class.call(object, method_name, private: private) }

    let(:klass) do
      Class.new do
        def foo
        end
      end
    end

    let(:object) { klass.new }
    let(:method_name) { :foo }
    let(:private) { false }

    it "delegates to `ConvenientService::Utils::Module.get_own_instance_method`" do
      allow(ConvenientService::Utils::Module).to receive(:get_own_instance_method).with(klass, method_name, private: private).and_call_original

      util_result

      expect(ConvenientService::Utils::Module).to have_received(:get_own_instance_method).with(klass, method_name, private: private)
    end

    context "when `object` class does NOT have instance method" do
      let(:klass) { Class.new }

      it "returns `nil`" do
        expect(util_result).to be_nil
      end
    end

    context "when `object` class has inherited instance method" do
      let(:parent_klass) do
        Class.new do
          def foo
          end
        end
      end

      let(:klass) { Class.new(parent_klass) }

      it "returns `nil`" do
        expect(util_result).to be_nil
      end
    end

    context "when `object` class has own instance method" do
      context "when that own instance method is public" do
        let(:klass) do
          Class.new do
            def foo
            end
          end
        end

        it "returns that own public instance method" do
          expect(util_result).to eq(object.method(method_name))
        end
      end

      context "when that own instance method is protected" do
        let(:klass) do
          Class.new do
            protected

            def foo
            end
          end
        end

        it "returns that own protected instance method" do
          expect(util_result).to eq(object.method(method_name))
        end
      end

      context "when that own instance method is private" do
        let(:klass) do
          Class.new do
            private

            def foo
            end
          end
        end

        context "when `private` option is NOT passed" do
          let(:util_result) { described_class.call(object, method_name) }

          it "returns `nil` (`private` defaults to `false`)" do
            expect(util_result).to be_nil
          end
        end

        context "when `private` option is `false`" do
          let(:private) { false }

          it "returns `nil`" do
            expect(util_result).to be_nil
          end
        end

        context "when `private` option is `true`" do
          let(:private) { true }

          it "returns that own private instance method" do
            expect(util_result).to eq(object.method(method_name))
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
