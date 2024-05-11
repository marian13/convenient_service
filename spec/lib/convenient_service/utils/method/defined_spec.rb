# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Utils::Method::Defined, type: :standard do
  describe ".defined?" do
    let(:method) { :foo }

    let(:util_result) { described_class.call(method, klass, public: public, protected: protected, private: private) }
    let(:public) { false }
    let(:protected) { false }
    let(:private) { false }

    ##
    # TODO: Formalize testing strategies.
    #
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
        expect(util_result).to eq(true)
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
        expect(util_result).to eq(true)
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
        expect(util_result).to eq(false)
      end
    end

    context "when `public` is `true`, `protected` is `false`, `private` is `false`" do
      let(:public) { true }
      let(:protected) { false }
      let(:private) { false }

      context "when `class` does NOT have `method`" do
        let(:klass) { Class.new }

        it "returns `false`" do
          expect(util_result).to eq(false)
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

          it "returns `true`" do
            expect(util_result).to eq(true)
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

          it "returns `false`" do
            expect(util_result).to eq(false)
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

          it "returns `false`" do
            expect(util_result).to eq(false)
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

        it "returns `false`" do
          expect(util_result).to eq(false)
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

          it "returns `false`" do
            expect(util_result).to eq(false)
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

          it "returns `true`" do
            expect(util_result).to eq(true)
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

          it "returns `false`" do
            expect(util_result).to eq(false)
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

        it "returns `false`" do
          expect(util_result).to eq(false)
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

          it "returns `false`" do
            expect(util_result).to eq(false)
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

          it "returns `false`" do
            expect(util_result).to eq(false)
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

          it "returns `true`" do
            expect(util_result).to eq(true)
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

        it "returns `false`" do
          expect(util_result).to eq(false)
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

          it "returns `true`" do
            expect(util_result).to eq(true)
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

          it "returns `true`" do
            expect(util_result).to eq(true)
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

          it "returns `false`" do
            expect(util_result).to eq(false)
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

        it "returns `false`" do
          expect(util_result).to eq(false)
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

          it "returns `true`" do
            expect(util_result).to eq(true)
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

          it "returns `false`" do
            expect(util_result).to eq(false)
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

          it "returns `true`" do
            expect(util_result).to eq(true)
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

        it "returns `false`" do
          expect(util_result).to eq(false)
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

          it "returns `false`" do
            expect(util_result).to eq(false)
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

          it "returns `true`" do
            expect(util_result).to eq(true)
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

          it "returns `true`" do
            expect(util_result).to eq(true)
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

        it "returns `false`" do
          expect(util_result).to eq(false)
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

          it "returns `true`" do
            expect(util_result).to eq(true)
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

          it "returns `true`" do
            expect(util_result).to eq(true)
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

          it "returns `true`" do
            expect(util_result).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
