# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups

RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Commands::CreateObservableMiddleware, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  let(:command_result) { described_class.call(middleware: middleware) }

  let(:middleware) { Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base) }

  example_group "class methods" do
    describe ".call" do
      it "returns `middleware` observable descendant" do
        expect(command_result).to be_descendant_of(middleware)
      end

      example_group "`middleware` observable descendant" do
        let(:observable_middleware) { command_result }

        example_group "instance methods" do
          describe "#middleware" do
            it "returns original `middleware`" do
              expect(observable_middleware.middleware).to eq(middleware)
            end
          end

          example_group "comparison" do
            describe "#==" do
              context "when `other` does NOT respond `middleware`" do
                let(:other) { 42 }

                it "returns `nil`" do
                  expect(observable_middleware == other).to be_nil
                end
              end

              context "when `other` have different `middleware`" do
                let(:other) { described_class.call(middleware: Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base)) }

                it "returns `false`" do
                  expect(observable_middleware == other).to be(false)
                end
              end

              context "when `other` has same attributes" do
                let(:other) { described_class.call(middleware: middleware) }

                it "returns `true`" do
                  expect(observable_middleware == other).to be(true)
                end
              end
            end
          end

          describe "#inspect" do
            it "returns inspect representation" do
              expect(observable_middleware.inspect).to eq("Observable(#{middleware.inspect})")
            end

            specify do
              expect { observable_middleware.inspect }
                .to delegate_to(middleware, :inspect)
                .without_arguments
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
