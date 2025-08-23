# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass
RSpec.describe ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom::Constants, type: :standard do
  example_group "constants" do
    describe "::INITIAL_MIDDLEWARE" do
      it "returns `Proc` object" do
        expect(described_class::INITIAL_MIDDLEWARE).to be_instance_of(Proc)
      end

      it "returns lambda" do
        expect(described_class::INITIAL_MIDDLEWARE).to be_lambda
      end

      example_group "lamdba" do
        let(:lamdba) { described_class::INITIAL_MIDDLEWARE }
        let(:env) { {foo: :bar, baz: :qux} }

        it "returns object passed to it" do
          expect(lamdba.call(env)).to eq(env)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/DescribeClass
