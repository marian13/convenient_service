# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: `yard-junk` (actually `yard`) does NOT work with commonmarker v1+.
# - https://github.com/zverok/yard-junk/blob/v0.0.10/lib/yard-junk/janitor/resolver.rb#L37
#
# NOTE: Rubocop is disable to preserve original code styling.
# rubocop:disable all
require "yard"

##
# HACK: Monkey-patch for yard support of commonmarker v1+. See the full story:
# - https://github.com/lsegal/yard/pull/1601
# - https://github.com/lsegal/yard/pull/1540
##

##
# - https://github.com/lsegal/yard/commit/7b7a7d3762156aa92b96780e83980054ae11051a
# - https://github.com/lsegal/yard/blob/v0.9.38/lib/yard/templates/helpers/markup_helper.rb#L33
#
YARD::Templates::Helpers::MarkupHelper::MARKUP_PROVIDERS[:markdown] << {:lib => :commonmarker, :const => 'Commonmarker'}

##
# - https://github.com/lsegal/yard/commit/7b7a7d3762156aa92b96780e83980054ae11051a
# - https://github.com/lsegal/yard/blob/v0.9.38/lib/yard/templates/helpers/html_helper.rb#L96
#
module YARD
  module Templates::Helpers
    module HtmlHelper
      def html_markup_markdown(text)
        # TODO: other libraries might be more complex
        provider = markup_class(:markdown)
        case provider.to_s
        when  'RDiscount'
          provider.new(text, :autolink).to_html
        when 'RedcarpetCompat'
          provider.new(text, :autolink,
                             :fenced_code,
                             :gh_blockcode,
                             :lax_spacing,
                             :tables,
                             :with_toc_data,
                             :no_intraemphasis).to_html
        when 'CommonMarker'
          CommonMarker.render_html(text, %i[DEFAULT GITHUB_PRE_LANG], %i[autolink table])
        when 'Commonmarker'
          ##
          # - https://github.com/lsegal/yard/pull/1601/files#diff-69c282e77d5d9c0c4ecf51630ccc1304815b359f4c08d6c824971a1723323b6eR97
          # - https://github.com/gjtorikian/commonmarker?tab=readme-ov-file#render-options
          # - http://github.com/gjtorikian/commonmarker?tab=readme-ov-file#extension-options
          # - https://github.com/gjtorikian/commonmarker/tree/v0.23.12?tab=readme-ov-file#parse-options
          #
          Commonmarker.to_html(text, options: { extension: { header_ids: nil } }, plugins: {syntax_highlighter: nil})
        else
          provider.new(text).to_html
        end
      end
    end
  end
end
# rubocop:enable all

puts "[Convenient Service][YARD]: `yard-commonmarker` plugin loaded."
