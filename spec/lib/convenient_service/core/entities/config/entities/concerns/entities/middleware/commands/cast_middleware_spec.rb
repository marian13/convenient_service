# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware::Commands::CastMiddleware, type: :standard do
  example_group "class methods" do
    describe ".call" do
      let(:casted) { described_class.call(other: other) }

      context "when `other` is NOT castable" do
        let(:other) { 42 }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is Class" do
        context "when that Class is NOT `ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware` descendant" do
          let(:other) { Class.new }

          it "returns `nil`" do
            expect(casted).to be_nil
          end
        end

        context "when that Class is `ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware` descendant" do
          let(:other) do
            ::Class.new(ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware).tap do |klass|
              klass.class_exec(Module.new) do |mod|
                define_singleton_method(:concern) { mod }
              end
            end
          end

          it "returns middleware copy" do
            expect(casted).to eq(other.dup)
          end
        end
      end

      context "when `other` is Module" do
        let(:other) { Module.new }

        let(:middleware) do
          ::Class.new(ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware).tap do |klass|
            klass.class_exec(other) do |mod|
              define_singleton_method(:concern) { mod }
            end
          end
        end

        it "returns other casted to middleware" do
          expect(casted).to eq(middleware)
        end
      end

      example_group "generated middleware" do
        let(:concern) { Module.new }

        let(:generated_middleware) { described_class.call(other: concern) }

        describe ".concern" do
          it "returns concern" do
            expect(generated_middleware.concern).to eq(concern)
          end
        end

        describe ".original_two_equals" do
          context "when other is NOT `ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware`" do
            let(:other) { 42 }

            it "returns `false`" do
              expect(generated_middleware.original_two_equals(other)).to be(false)
            end
          end

          context "when other is `ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware`" do
            let(:other) { ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware }

            it "returns `false`" do
              expect(generated_middleware.original_two_equals(other)).to be(false)
            end
          end

          context "when other is `ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware` descendant" do
            context "when that descendant is NOT same instance" do
              let(:other) do
                ::Class.new(generated_middleware).tap do |klass|
                  klass.class_exec(concern) do |mod|
                    define_singleton_method(:concern) { mod }
                  end
                end
              end

              it "returns `false`" do
                expect(generated_middleware.original_two_equals(other)).to be(false)
              end
            end

            context "when that descendant is same instance" do
              let(:other) { generated_middleware }

              it "returns `true`" do
                expect(generated_middleware.original_two_equals(other)).to be(true)
              end
            end
          end
        end

        describe ".==" do
          context "when other is NOT `ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware`" do
            context "when other is NOT instance of Class" do
              let(:other) { 42 }

              it "returns `nil`" do
                expect(generated_middleware == other).to be_nil
              end
            end

            context "when other is instance of Class" do
              context "when that Class is NOT `ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware` descendant" do
                let(:other) { Class.new }

                it "returns `nil`" do
                  expect(generated_middleware == other).to be_nil
                end
              end

              context "when that Class is `ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware` descendant" do
                context "when that descendant concern is NOT same" do
                  let(:other) do
                    ::Class.new(ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware).tap do |klass|
                      klass.class_exec(Module.new) do |mod|
                        define_singleton_method(:concern) { mod }
                      end
                    end
                  end

                  it "returns `false`" do
                    expect(generated_middleware == other).to be(false)
                  end
                end

                context "when that descendant concern is same" do
                  let(:other) do
                    ::Class.new(ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware).tap do |klass|
                      klass.class_exec(concern) do |concern|
                        define_singleton_method(:concern) { concern }
                      end
                    end
                  end

                  it "returns `true`" do
                    expect(generated_middleware == other).to be(true)
                  end
                end
              end
            end
          end

          context "when other is `ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware`" do
            it "returns `nil`" do
              expect(generated_middleware == ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware).to be_nil
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
