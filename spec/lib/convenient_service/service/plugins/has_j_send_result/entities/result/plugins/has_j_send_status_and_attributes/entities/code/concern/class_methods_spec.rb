# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".code_class?" do
      let(:klass) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code }

      context "when `code` is NOT class" do
        let(:code_class) { 42 }

        it "returns `false`" do
          expect(klass.code_class?(code_class)).to eq(false)
        end
      end

      context "when `code` is class" do
        context "when `code` is NOT code class" do
          let(:code_class) { Class.new }

          it "returns `false`" do
            expect(klass.code_class?(code_class)).to eq(false)
          end

          context "when `code` is entity class" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success
                end
              end
            end

            it "returns `false`" do
              expect(klass.code_class?(service_class)).to eq(false)
            end
          end
        end

        context "when `code` is code class" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          let(:code_class) { service_class.new.result.unsafe_code.class }

          it "returns `true`" do
            expect(klass.code_class?(code_class)).to eq(true)
          end
        end
      end
    end

    describe ".code?" do
      let(:klass) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code }

      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:code_class) { service_class.result_class.code_class }
      let(:data_instance) { service_class.result.unsafe_code }

      specify do
        expect { klass.code?(data_instance) }
          .to delegate_to(klass, :code_class?)
          .with_arguments(code_class)
          .and_return_its_value
      end
    end

    describe ".cast" do
      let(:casted) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { nil }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is symbol" do
        let(:other) { :foo }
        let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: other) }

        it "returns that symbol casted to code" do
          expect(casted).to eq(code)
        end
      end

      context "when `other` is string" do
        let(:other) { "foo" }
        let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: other.to_sym) }

        it "returns that string casted to code" do
          expect(casted).to eq(code)
        end
      end

      context "when `other` is code" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: :foo) }
        let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: other.value) }

        it "returns copy of `other`" do
          expect(casted).to eq(code)
        end
      end
    end

    describe ".===" do
      let(:code_class) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code }

      let(:other) { 42 }

      specify do
        expect { code_class === other }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code, :code?)
          .with_arguments(other)
      end

      it "returns `false`" do
        expect(code_class === other).to eq(false)
      end

      context "when `other` is code instance in terms of `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.code?`" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        let(:other) { service.result.unsafe_code }

        specify do
          expect { code_class === other }
            .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code, :code?)
            .with_arguments(other)
        end

        it "returns `true`" do
          expect(code_class === other).to eq(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code` instance" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.cast(:foo) }

        it "returns `true`" do
          expect(code_class === other).to eq(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code` descendant instance" do
        let(:descendant_class) { Class.new(code_class) }

        let(:other) { descendant_class.cast(:foo) }

        it "returns `true`" do
          expect(code_class === other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
