RSpec.describe 'layouts/application' do
  before do
    ENV['CONTACT_EMAIL'] = 'rawr@gmail.com'
    ENV['DOWNLOAD_LINK'] = 'www.google.com'
    render
  end

  def contain_link(link, text)
    have_css("a[href='#{link}']", text: text)
  end

  def text(key)
    I18n.t("layouts.application.#{key}")
  end

  it 'has the HTML title' do
    expect(response).to have_css('title', text: text('title'), visible: false)
  end

  it 'has a link to the home page' do
    expect(response).to contain_link(root_path, text('home'))
  end

  it 'has a link to the roles index page' do
    expect(response).to contain_link(roles_path, text('roles_index'))
  end

  I18n.t('layouts.application.roles').each do |param, display_name|
    it "has a link to #{display_name}" do
      expect(response).
        to contain_link(champions_path(role: param), display_name)
    end
  end

  it 'has a link to the champion index page' do
    expect(response).to contain_link(champions_path, text('champions_index'))
  end

  I18n.t('layouts.application.overunder').each do |param, display_name|
    it "has a link to #{display_name}" do
      expect(response).
        to contain_link(champions_path(rated: param), display_name)
    end
  end

  it 'has a link to the URF awards page' do
    expect(response).to contain_link(urf_awards_path, text('urf_awards'))
  end

  it 'has a link to the spreadsheet' do
    expect(response).to contain_link(ENV['DOWNLOAD_LINK'], text('download'))
  end

  it 'has a contact email link' do
    expect(response).
      to contain_link("mailto:#{ENV['CONTACT_EMAIL']}", text('contact'))
  end

  it 'has a link to the about page' do
    expect(response).to contain_link(about_path, text('about'))
  end
end
