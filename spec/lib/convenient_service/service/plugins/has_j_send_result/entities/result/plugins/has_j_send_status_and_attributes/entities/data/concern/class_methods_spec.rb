# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".data_class?" do
      let(:klass) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data }

      context "when `data` is NOT class" do
        let(:data_class) { 42 }

        it "returns `false`" do
          expect(klass.data_class?(data_class)).to be(false)
        end
      end

      context "when `data` is class" do
        context "when `data` is NOT data class" do
          let(:data_class) { Class.new }

          it "returns `false`" do
            expect(klass.data_class?(data_class)).to be(false)
          end

          context "when `data` is entity class" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success
                end
              end
            end

            it "returns `false`" do
              expect(klass.data_class?(service_class)).to be(false)
            end
          end
        end

        context "when `data` is data class" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          let(:data_class) { service_class.new.result.unsafe_data.class }

          it "returns `true`" do
            expect(klass.data_class?(data_class)).to be(true)
          end
        end
      end
    end

    describe ".data?" do
      let(:klass) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data }

      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:data_class) { service_class.result_class.data_class }
      let(:data_instance) { service_class.result.unsafe_data }

      specify do
        expect { klass.data?(data_instance) }
          .to delegate_to(klass, :data_class?)
          .with_arguments(data_class)
          .and_return_its_value
      end
    end

    describe ".cast" do
      let(:casted) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { nil }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is hash" do
        let(:other) { {foo: :bar} }
        let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: other) }

        it "returns that hash casted to data" do
          expect(casted).to eq(data)
        end

        context "when that hash has string keys" do
          let(:other) { {"foo" => :bar} }
          let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: :bar}) }

          it "converts string keys to symbol keys" do
            expect(casted).to eq(data)
          end
        end
      end

      context "when `other` is data" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: :bar}) }
        let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: other.value) }

        it "returns copy of `other`" do
          expect(casted).to eq(data)
        end

        ##
        # NOTE: Ensures `ConvenientService::Plugins::Data::HasMethodReaders::Middleware` does NOT break `success(value: some_value)`.
        #
        specify do
          expect { casted }
            .to delegate_to(other, :__value__)
            .without_arguments
        end
      end
    end

    describe ".===" do
      let(:data_class) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data }

      let(:other) { 42 }

      specify do
        expect { data_class === other }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data, :data?)
          .with_arguments(other)
      end

      it "returns `false`" do
        expect(data_class === other).to be(false)
      end

      context "when `other` is data instance in terms of `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.data?`" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(data: {foo: :bar})
            end
          end
        end

        let(:other) { service.result.unsafe_data }

        specify do
          expect { data_class === other }
            .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data, :data?)
            .with_arguments(other)
        end

        it "returns `true`" do
          expect(data_class === other).to be(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data` instance" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.cast({foo: :bar}) }

        it "returns `true`" do
          expect(data_class === other).to be(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data` descendant instance" do
        let(:descendant_class) { Class.new(data_class) }

        let(:other) { descendant_class.cast({foo: :bar}) }

        it "returns `true`" do
          expect(data_class === other).to be(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
