RSpec.describe 'layouts/application' do
  before do
    ENV['CONTACT_EMAIL'] = 'rawr@gmail.com'
    ENV['DOWNLOAD_LINK'] = 'www.google.com'
    render
  end

  it 'has the HTML title' do
    expect(response).to have_css('title',
                                 text: I18n.t('layouts.application.title'),
                                 visible: false)
  end

  it 'has a link to the home page' do
    expect(response).to have_css("a[href='#{root_path}']",
                                 text: I18n.t('layouts.application.home'))
  end
end
