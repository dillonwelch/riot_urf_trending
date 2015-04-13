RSpec.describe 'user visits the home page', js: true do
  let!(:teemo)   { create(:champion, name: 'Teemo') }
  let!(:cmteemo) do
    create(:champion_match, champion: teemo, kills: 2, deaths: 3)
  end

  before do
    visit root_path
  end

  it 'has the right match count' do
    matches = "1 #{I18n.t('application.index.matches_sampled')}"
    expect(page).to have_content matches
  end

  it 'has the right kill count' do
    kill = "2 #{I18n.t('application.index.total_kills')}"
    expect(page).to have_content kill
  end

  it 'has the right execution count' do
    executions = "1 #{I18n.t('application.index.total_deaths')}"
    expect(page).to have_content executions
  end

  it 'has the right Teemo corpse count' do
    teemo_corpses = "3 #{I18n.t('application.index.teemo_corpses')}"
    expect(page).to have_content teemo_corpses
  end
end
