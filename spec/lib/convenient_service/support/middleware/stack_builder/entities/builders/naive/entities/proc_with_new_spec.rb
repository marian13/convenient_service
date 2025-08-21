# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Naive::Entities::ProcWithNew, type: :standard do
  let(:proc_wrapper) { described_class.new(proc) }

  # rubocop:disable Style/Proc
  let(:proc) { Proc.new { :foo } }
  # rubocop:enable Style/Proc

  let(:app) { double }

  example_group "instance methods" do
    describe "#new" do
      it "returns proc passed to constructor" do
        expect(proc_wrapper.new(app)).to eq(proc)
      end

      context "when `app` is NOT passed" do
        it "returns proc passed to constructor" do
          expect(proc_wrapper.new).to eq(proc)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
