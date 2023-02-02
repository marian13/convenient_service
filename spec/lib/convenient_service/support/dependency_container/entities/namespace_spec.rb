# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Entities::Namespace do
  let(:namespace) { described_class.new(name: name) }

  let(:name) { :foo }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { namespace }

    it { is_expected.to have_attr_reader(:name) }
  end

  example_group "instance methods" do
    describe "#body" do
      it "returns proc instance" do
        expect(namespace.body).to be_instance_of(Proc)
      end

      it "returns `lambda` proc" do
        expect(namespace.body.lambda?).to eq(true)
      end

      it "returns proc with zero arity" do
        expect(namespace.body.arity).to eq(0)
      end

      example_group "returned proc" do
        context "when called" do
          it "returns `self`" do
            expect(namespace.body.call.object_id).to eq(namespace.object_id)
          end
        end
      end
    end

    describe "#namespaces" do
      it "returns empty namespace collection" do
        expect(namespace.namespaces).to eq(ConvenientService::Support::DependencyContainer::Entities::NamespaceCollection.new)
      end
    end

    describe "#define_method" do
      let(:body) { proc { |*args, **kwargs, &block| [args, kwargs, block] } }

      it "defines singleton method for namespace" do
        namespace.define_method(name, &body)

        ##
        # NOTE: See `body` for return value.
        #
        expect(namespace.foo(*args, **kwargs, &block)).to eq([args, kwargs, block])
      end

      it "returns method name" do
        expect(namespace.define_method(name, &body)).to eq(name)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:namespace) { described_class.new(name: name) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(namespace == other).to be_nil
          end
        end

        context "when `other` has different `name`" do
          let(:other) { described_class.new(name: "bar") }

          it "returns `false`" do
            expect(namespace == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(name: name) }

          it "returns `true`" do
            expect(namespace == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
