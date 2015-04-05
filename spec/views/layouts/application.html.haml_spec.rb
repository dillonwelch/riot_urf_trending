RSpec.describe 'layouts/application' do
  before do
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

  it 'has a link to the by win rate champions page' do
    path = champions_by_win_rate_path
    text = I18n.t('layouts.application.champion_win_rate')
    expect(response).to have_css("ul li a[href='#{path}']", text: text)
  end
end
