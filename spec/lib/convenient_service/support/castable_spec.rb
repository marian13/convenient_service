# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Castable, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:klass) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  let(:instance) { klass.new }

  let(:other) { double }
  let(:casted) { double }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { klass }

      it { is_expected.to include_module(described_class::InstanceMethods) }
      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".cast" do
      let(:exception_message) do
        <<~TEXT
          `#{klass}` should implement abstract class method `cast`.
        TEXT
      end

      it "raises `ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden`" do
        expect { klass.cast(other) }
          .to raise_error(ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden)
          .with_message(exception_message)
      end

      specify do
        expect { ignoring_exception(ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden) { klass.cast(other) } }
          .to delegate_to(ConvenientService, :raise)
      end
    end

    describe ".cast!" do
      context "when `other` is NOT castable" do
        include ConvenientService::RSpec::Helpers::IgnoringException

        let(:message) do
          <<~TEXT
            Failed to cast `#{other.inspect}` into `#{klass}`.
          TEXT
        end

        before do
          allow(klass).to receive(:cast).and_return(nil)
        end

        it "delegates to `.cast`" do
          ##
          # NOTE: Error is NOT the purpose of this spec. That is why it is caught.
          # But if it is NOT caught, the spec should fail.
          #
          ignoring_exception(described_class::Exceptions::FailedToCast) { klass.cast!(other) }

          expect(klass).to have_received(:cast).with(other)
        end

        it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
          expect { klass.cast!(other) }
            .to raise_error(described_class::Exceptions::FailedToCast)
            .with_message(message)
        end

        specify do
          expect { ignoring_exception(described_class::Exceptions::FailedToCast) { klass.cast!(other) } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when `other` is castable" do
        before do
          allow(klass).to receive(:cast).and_return(casted)
        end

        it "delegates to `.cast`" do
          klass.cast!(other)

          expect(klass).to have_received(:cast).with(other)
        end

        it "returns casted `other`" do
          expect(klass.cast!(other)).to eq(casted)
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#cast" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod

            ##
            # NOTE: #cast is intentionally private. That's why this wrapper is used.
            #
            def public_cast(other)
              cast(other)
            end
          end
        end
      end

      before do
        allow(klass).to receive(:cast)
      end

      it "delegates to `.cast`" do
        instance.public_cast(other)

        expect(klass).to have_received(:cast)
      end

      it "returns result of `.cast`" do
        expect(instance.public_cast(other)).to eq(klass.cast(other))
      end
    end

    describe "#cast!" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod

            ##
            # NOTE: #cast! is intentionally private. That's why this wrapper is used.
            #
            def public_cast!(other)
              cast!(other)
            end
          end
        end
      end

      before do
        allow(klass).to receive(:cast!)
      end

      it "delegates to `.cast!`" do
        instance.public_cast!(other)

        expect(klass).to have_received(:cast!)
      end

      it "returns result of `.cast!`" do
        expect(instance.public_cast!(other)).to eq(klass.cast!(other))
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
