RSpec.describe 'application/index' do
  before do
    render
  end

  it 'has the title' do
    expect(response).to have_css('.header h1',
                                 text: I18n.t('application.index.title'))
  end

  it 'has matches sampled' do
    expect(response).to have_content I18n.t('application.index.matches_sampled')
  end

  it 'has total kills' do
    expect(response).to have_content I18n.t('application.index.total_kills')
  end

  it 'has total deaths' do
    expect(response).to have_content I18n.t('application.index.total_deaths')
  end

  it 'has the teemo counter' do
    expect(response).to have_content I18n.t('application.index.teemo_corpses')
  end
end
