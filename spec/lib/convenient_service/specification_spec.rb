# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

##
# NOTE: Looks like `frozen_string_literal: true` is NOT consistent in JRuby.
# - https://github.com/jruby/jruby/issues/4970#issuecomment-369459500
# - https://github.com/jruby/jruby/issues/5070
# - https://github.com/ruby/spec/blob/369c006a488f6a853b875d869871687e329faa02/core/string/freeze_spec.rb#L5-L7
#
return if ConvenientService::Dependencies.ruby.jruby?

RSpec.describe ConvenientService::Specification, type: :standard do
  example_group "constants" do
    describe "::VERSION" do
      it "returns name" do
        expect(described_class::NAME).to eq("convenient_service")
      end

      specify { expect(described_class::NAME).to be_frozen }
    end

    describe "::AUTHORS" do
      it "returns authors" do
        expect(described_class::AUTHORS).to eq(["Marian Kostyk"])
      end

      specify { expect(described_class::AUTHORS).to be_frozen }
      specify { expect(described_class::AUTHORS.first).to be_frozen }
    end

    describe "::HOMEPAGE" do
      it "returns homepage" do
        expect(described_class::HOMEPAGE).to eq("https://github.com/marian13/convenient_service")
      end

      specify { expect(described_class::HOMEPAGE).to be_frozen }
    end

    describe "::SUMMARY" do
      it "returns summary" do
        expect(described_class::SUMMARY).to eq(
          <<~TEXT
            Ruby Service Objects with Steps and more.
          TEXT
        )
      end

      specify { expect(described_class::SUMMARY).to be_frozen }
    end

    describe "::DESCRIPTION" do
      # rubocop:disable RSpec/ExampleLength
      it "returns description" do
        expect(described_class::DESCRIPTION).to eq(
          <<~TEXT
            Manage complex business logic in Ruby applications using Service Objects with Results and Steps.

            Hide technical details with Configs, Concerns and Middlewares.

            Group related code with Features and Entries.
          TEXT
        )
      end
      # rubocop:enable RSpec/ExampleLength

      specify { expect(described_class::DESCRIPTION).to be_frozen }
    end
  end
end
