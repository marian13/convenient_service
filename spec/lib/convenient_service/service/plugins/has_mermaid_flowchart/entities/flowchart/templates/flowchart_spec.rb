# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "lib/convenient_service/service/plugins/has_mermaid_flowchart/entities/flowchart/templates/flowchart.html.erb", type: :standard do
  let(:template_path) { "lib/convenient_service/service/plugins/has_mermaid_flowchart/entities/flowchart/templates/flowchart.html.erb" }

  let(:template_html_erb) do
    <<~TEXT
      <!DOCTYPE html>
      <html>
        <head>
          <title><%= title %></title>

          <!-- https://www.w3schools.com/css/css_rwd_viewport.asp -->
          <meta name="viewport" content="width=device-width, initial-scale=1.0">

          <style>
            /**
             * https://www.w3schools.com/howto/howto_css_loader.asp
             * https://www.w3schools.com/howto/tryit.asp?filename=tryhow_css_loader
             */
            #loader {
              border: 16px solid #f3f3f3;
              border-radius: 50%;
              border-top: 16px solid #3498db;
              width: 120px;
              height: 120px;
              -webkit-animation: spin 2s linear infinite; /* Safari */
              animation: spin 2s linear infinite;
            }

            /* Safari */
            @-webkit-keyframes spin {
              0% { -webkit-transform: rotate(0deg); }
              100% { -webkit-transform: rotate(360deg); }
            }

            @keyframes spin {
              0% { transform: rotate(0deg); }
              100% { transform: rotate(360deg); }
            }

            /**
             * https://github.com/anvaka/panzoom
             */
            #diagram {
              height: 100%;
              width: 100%;

              /*
               * https://www.w3schools.com/howto/howto_js_toggle_hide_show.asp
               */
              display: none;
            }
          </style>
        </head>
        <body>
          <!-- https://www.w3schools.com/howto/howto_css_loader.asp -->
          <!-- https://www.w3schools.com/howto/tryit.asp?filename=tryhow_css_loader -->
          <div id="loader"></div>

          <!-- https://mermaid-js.github.io/mermaid/#/sequenceDiagram?id=sequence-diagrams -->
          <div id="diagram" class="mermaid">
            <%= code %>
          </div>

          <script type="module">
            /**
             * https://docs.skypack.dev/
             */
            import mermaid from 'https://cdn.skypack.dev/mermaid@^8.14.0';
            import panzoom from 'https://cdn.skypack.dev/panzoom@^9.4.3';

            /**
             * https://mermaid-js.github.io/mermaid/#/
             */
            mermaid.initialize({ startOnLoad: true });

            /**
             * https://github.com/anvaka/panzoom
             */
            const elementWithDiagram = document.getElementById('diagram');

            panzoom(elementWithDiagram);

            /**
             * https://www.w3schools.com/howto/howto_css_loader.asp
             * https://www.w3schools.com/howto/tryit.asp?filename=tryhow_css_loader
             */
            const loader = document.getElementById('loader');

            /*
             * https://developer.mozilla.org/en-US/docs/Web/API/Element/remove
             */
            loader.remove();

            /*
             * https://www.w3schools.com/howto/howto_js_toggle_hide_show.asp
             */
            elementWithDiagram.style.display = 'block';
          </script>
        </body>
      </html>
    TEXT
  end

  it "stores template HTML with ERB" do
    ##
    # TODO: JS specs.
    #
    expect(File.read(template_path)).to eq(template_html_erb)
  end
end
# rubocop:enable RSpec/DescribeClass
