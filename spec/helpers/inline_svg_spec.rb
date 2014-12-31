require 'inline_svg'
require 'nokogiri'
require 'active_support/core_ext'

describe InlineSvg::ActionView::Helpers do

  let(:helper) { ( Class.new { include InlineSvg::ActionView::Helpers } ).new }

  describe "#inline_svg" do
    
    context "when passed an existing SVG file" do

      context "and no options" do
        it "returns a html safe version of the file's contents" do
          example_file = <<-SVG.sub(/\n$/, '')
  <svg xmlns="http://www.w3.org/2000/svg" role="presentation" xml:lang="en"><!-- This is a comment --></svg>
  SVG
          allow(InlineSvg::FindsFiles).to receive(:named).with('some-file').and_return(example_file)
          expect(helper.inline_svg('some-file')).to eq example_file
        end
      end

      context "and the 'title' option" do
        it "adds the title node to the SVG output" do
          input_svg = <<-SVG.sub(/\n$/, '')
<svg xmlns="http://www.w3.org/2000/svg" role="presentation" xml:lang="en"></svg>
SVG
          expected_output = <<-SVG.sub(/\n$/, '')
<svg xmlns="http://www.w3.org/2000/svg" role="presentation" xml:lang="en"><title>A title</title></svg>
SVG
          allow(InlineSvg::FindsFiles).to receive(:named).with('some-file').and_return(input_svg)
          expect(helper.inline_svg('some-file', title: 'A title')).to eq expected_output
        end
      end

      context "and the 'desc' option" do
        it "adds the description node to the SVG output" do
          input_svg = <<-SVG.sub(/\n$/, '')
<svg xmlns="http://www.w3.org/2000/svg" role="presentation" xml:lang="en"></svg>
SVG
          expected_output = <<-SVG.sub(/\n$/, '')
<svg xmlns="http://www.w3.org/2000/svg" role="presentation" xml:lang="en"><desc>A description</desc></svg>
SVG
          allow(InlineSvg::FindsFiles).to receive(:named).with('some-file').and_return(input_svg)
          expect(helper.inline_svg('some-file', desc: 'A description')).to eq expected_output
        end
      end

      context "and the 'nocomment' option" do
        it "strips comments and other unknown/unsafe nodes from the output" do
          input_svg = <<-SVG.sub(/\n$/, '')
<svg xmlns="http://www.w3.org/2000/svg" role="presentation" xml:lang="en"><!-- This is a comment --></svg>
SVG
          expected_output = <<-SVG.sub(/\n$/, '')
<svg xmlns="http://www.w3.org/2000/svg" xml:lang="en"></svg>
SVG
          allow(InlineSvg::FindsFiles).to receive(:named).with('some-file').and_return(input_svg)
          expect(helper.inline_svg('some-file', nocomment: true)).to eq expected_output
        end
      end

      context "and all options" do
        it "applies all expected transformations to the output" do
          input_svg = <<-SVG.sub(/\n$/, '')
<svg xmlns="http://www.w3.org/2000/svg" role="presentation" xml:lang="en"><!-- This is a comment --></svg>
SVG
          expected_output = <<-SVG.sub(/\n$/, '')
<svg xmlns="http://www.w3.org/2000/svg" xml:lang="en"><title>A title</title>
<desc>A description</desc></svg>
SVG
          allow(InlineSvg::FindsFiles).to receive(:named).with('some-file').and_return(input_svg)
          expect(helper.inline_svg('some-file', title: 'A title', desc: 'A description', nocomment: true)).to eq expected_output
        end
      end
    end
  end
end
