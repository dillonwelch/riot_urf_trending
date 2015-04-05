module ViewHelpers
  RSpec.shared_context 'a stubbed template' do |name, content|
    before do
      stub_template "#{name}.html.haml" => content
    end
  end

  RSpec.shared_examples 'renders a partial' do |name, content|
    include_context 'a stubbed template', name, content

    it "renders the #{name} partial" do
      render
      expect(response).to render_template(name)
    end

    it "renders the #{name} content" do
      render
      expect(response).to have_content(content)
    end
  end
end
