# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Utils::Method::Remove, type: :standard do
  example_group "class methods" do
    describe ".call" do
      let(:method) { :foo }

      let(:util_result) { described_class.call(method, klass, public: public, protected: protected, private: private) }
      let(:public) { false }
      let(:protected) { false }
      let(:private) { false }

      context "when `public` is NOT passed" do
        let(:util_result) { described_class.call(method, klass, protected: protected, private: private) }

        let(:klass) do
          Class.new do
            public

            def foo
            end
          end
        end

        it "defaults to `true`" do
          expect(util_result).to eq(klass)
        end
      end

      context "when `protected` is NOT passed" do
        let(:util_result) { described_class.call(method, klass, public: public, private: private) }

        let(:klass) do
          Class.new do
            protected

            def foo
            end
          end
        end

        it "defaults to `true`" do
          expect(util_result).to eq(klass)
        end
      end

      context "when `private` is NOT passed" do
        let(:util_result) { described_class.call(method, klass, public: public, protected: protected) }

        let(:klass) do
          Class.new do
            private

            def foo
            end
          end
        end

        it "defaults to `false`" do
          expect(util_result).to be_nil
        end
      end

      context "when `public` is `true`, `protected` is `false`, `private` is `false`" do
        let(:public) { true }
        let(:protected) { false }
        let(:private) { false }

        context "when `class` does NOT have `method`" do
          let(:klass) { Class.new }

          it "returns `nil`" do
            expect(util_result).to be_nil
          end
        end

        context "when `class` has `method`" do
          context "when that `method` is `public`" do
            let(:klass) do
              Class.new do
                public

                def foo
                end
              end
            end

            it "returns `klass`" do
              expect(util_result).to eq(klass)
            end

            it "removes `method`" do
              expect { util_result }.to change { klass.public_method_defined?(method) }.from(true).to(false)
            end
          end

          context "when that `method` is `protected`" do
            let(:klass) do
              Class.new do
                protected

                def foo
                end
              end
            end

            it "returns `nil`" do
              expect(util_result).to be_nil
            end

            it "does NOT remove `method`" do
              expect { util_result }.not_to change { klass.protected_method_defined?(method) }.from(true)
            end
          end

          context "when that `method` is `private`" do
            let(:klass) do
              Class.new do
                private

                def foo
                end
              end
            end

            it "returns `nil`" do
              expect(util_result).to be_nil
            end

            it "does NOT remove `method`" do
              expect { util_result }.not_to change { klass.private_method_defined?(method) }.from(true)
            end
          end
        end
      end

      context "when `public` is `false`, `protected` is `true`, `private` is `false`" do
        let(:public) { false }
        let(:protected) { true }
        let(:private) { false }

        context "when `class` does NOT have `method`" do
          let(:klass) { Class.new }

          it "returns `nil`" do
            expect(util_result).to be_nil
          end
        end

        context "when `class` has `method`" do
          context "when that `method` is `public`" do
            let(:klass) do
              Class.new do
                public

                def foo
                end
              end
            end

            it "returns `nil`" do
              expect(util_result).to be_nil
            end

            it "does NOT remove `method`" do
              expect { util_result }.not_to change { klass.public_method_defined?(method) }.from(true)
            end
          end

          context "when that `method` is `protected`" do
            let(:klass) do
              Class.new do
                protected

                def foo
                end
              end
            end

            it "returns `klass`" do
              expect(util_result).to eq(klass)
            end

            it "removes `method`" do
              expect { util_result }.to change { klass.protected_method_defined?(method) }.from(true).to(false)
            end
          end

          context "when that `method` is `private`" do
            let(:klass) do
              Class.new do
                private

                def foo
                end
              end
            end

            it "returns `nil`" do
              expect(util_result).to be_nil
            end

            it "does NOT remove `method`" do
              expect { util_result }.not_to change { klass.private_method_defined?(method) }.from(true)
            end
          end
        end
      end

      context "when `public` is `false`, `protected` is `false`, `private` is `true`" do
        let(:public) { false }
        let(:protected) { false }
        let(:private) { true }

        context "when `class` does NOT have `method`" do
          let(:klass) { Class.new }

          it "returns `nil`" do
            expect(util_result).to be_nil
          end
        end

        context "when `class` has `method`" do
          context "when that `method` is `public`" do
            let(:klass) do
              Class.new do
                public

                def foo
                end
              end
            end

            it "returns `nil`" do
              expect(util_result).to be_nil
            end

            it "does NOT remove `method`" do
              expect { util_result }.not_to change { klass.public_method_defined?(method) }.from(true)
            end
          end

          context "when that `method` is `protected`" do
            let(:klass) do
              Class.new do
                protected

                def foo
                end
              end
            end

            it "returns `nil`" do
              expect(util_result).to be_nil
            end

            it "does NOT remove `method`" do
              expect { util_result }.not_to change { klass.protected_method_defined?(method) }.from(true)
            end
          end

          context "when that `method` is `private`" do
            let(:klass) do
              Class.new do
                private

                def foo
                end
              end
            end

            it "returns `klass`" do
              expect(util_result).to eq(klass)
            end

            it "removes `method`" do
              expect { util_result }.to change { klass.private_method_defined?(method) }.from(true).to(false)
            end
          end
        end
      end

      context "when `public` is `true`, `protected` is `true`, `private` is `false`" do
        let(:public) { true }
        let(:protected) { true }
        let(:private) { false }

        context "when `class` does NOT have `method`" do
          let(:klass) { Class.new }

          it "returns `nil`" do
            expect(util_result).to be_nil
          end
        end

        context "when `class` has `method`" do
          context "when that `method` is `public`" do
            let(:klass) do
              Class.new do
                public

                def foo
                end
              end
            end

            it "returns `klass`" do
              expect(util_result).to eq(klass)
            end

            it "removes `method`" do
              expect { util_result }.to change { klass.public_method_defined?(method) }.from(true).to(false)
            end
          end

          context "when that `method` is `protected`" do
            let(:klass) do
              Class.new do
                protected

                def foo
                end
              end
            end

            it "returns `klass`" do
              expect(util_result).to eq(klass)
            end

            it "removes `method`" do
              expect { util_result }.to change { klass.protected_method_defined?(method) }.from(true).to(false)
            end
          end

          context "when that `method` is `private`" do
            let(:klass) do
              Class.new do
                private

                def foo
                end
              end
            end

            it "returns `nil`" do
              expect(util_result).to be_nil
            end

            it "does NOT remove `method`" do
              expect { util_result }.not_to change { klass.private_method_defined?(method) }.from(true)
            end
          end
        end
      end

      context "when `public` is `true`, `protected` is `false`, `private` is `true`" do
        let(:public) { true }
        let(:protected) { false }
        let(:private) { true }

        context "when `class` does NOT have `method`" do
          let(:klass) { Class.new }

          it "returns `nil`" do
            expect(util_result).to be_nil
          end
        end

        context "when `class` has `method`" do
          context "when that `method` is `public`" do
            let(:klass) do
              Class.new do
                public

                def foo
                end
              end
            end

            it "returns `klass`" do
              expect(util_result).to eq(klass)
            end

            it "removes `method`" do
              expect { util_result }.to change { klass.public_method_defined?(method) }.from(true).to(false)
            end
          end

          context "when that `method` is `protected`" do
            let(:klass) do
              Class.new do
                protected

                def foo
                end
              end
            end

            it "returns `nil`" do
              expect(util_result).to be_nil
            end

            it "does NOT remove `method`" do
              expect { util_result }.not_to change { klass.protected_method_defined?(method) }.from(true)
            end
          end

          context "when that `method` is `private`" do
            let(:klass) do
              Class.new do
                private

                def foo
                end
              end
            end

            it "returns `klass`" do
              expect(util_result).to eq(klass)
            end

            it "removes `method`" do
              expect { util_result }.to change { klass.private_method_defined?(method) }.from(true).to(false)
            end
          end
        end
      end

      context "when `public` is `false`, `protected` is `true`, `private` is `true`" do
        let(:public) { false }
        let(:protected) { true }
        let(:private) { true }

        context "when `class` does NOT have `method`" do
          let(:klass) { Class.new }

          it "returns `nil`" do
            expect(util_result).to be_nil
          end
        end

        context "when `class` has `method`" do
          context "when that `method` is `public`" do
            let(:klass) do
              Class.new do
                public

                def foo
                end
              end
            end

            it "returns `nil`" do
              expect(util_result).to be_nil
            end

            it "does NOT remove `method`" do
              expect { util_result }.not_to change { klass.public_method_defined?(method) }.from(true)
            end
          end

          context "when that `method` is `protected`" do
            let(:klass) do
              Class.new do
                protected

                def foo
                end
              end
            end

            it "returns `klass`" do
              expect(util_result).to eq(klass)
            end

            it "removes `method`" do
              expect { util_result }.to change { klass.protected_method_defined?(method) }.from(true).to(false)
            end
          end

          context "when that `method` is `private`" do
            let(:klass) do
              Class.new do
                private

                def foo
                end
              end
            end

            it "returns `klass`" do
              expect(util_result).to eq(klass)
            end

            it "removes `method`" do
              expect { util_result }.to change { klass.private_method_defined?(method) }.from(true).to(false)
            end
          end
        end
      end

      context "when `public` is `true`, `protected` is `true`, `private` is `true`" do
        let(:public) { true }
        let(:protected) { true }
        let(:private) { true }

        context "when `class` does NOT have `method`" do
          let(:klass) { Class.new }

          it "returns `nil`" do
            expect(util_result).to be_nil
          end
        end

        context "when `class` has `method`" do
          context "when that `method` is `public`" do
            let(:klass) do
              Class.new do
                public

                def foo
                end
              end
            end

            it "returns `klass`" do
              expect(util_result).to eq(klass)
            end

            it "removes `method`" do
              expect { util_result }.to change { klass.public_method_defined?(method) }.from(true).to(false)
            end
          end

          context "when that `method` is `protected`" do
            let(:klass) do
              Class.new do
                protected

                def foo
                end
              end
            end

            it "returns `klass`" do
              expect(util_result).to eq(klass)
            end

            it "removes `method`" do
              expect { util_result }.to change { klass.protected_method_defined?(method) }.from(true).to(false)
            end
          end

          context "when that `method` is `private`" do
            let(:klass) do
              Class.new do
                private

                def foo
                end
              end
            end

            it "returns `klass`" do
              expect(util_result).to eq(klass)
            end

            it "removes `method`" do
              expect { util_result }.to change { klass.private_method_defined?(method) }.from(true).to(false)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
