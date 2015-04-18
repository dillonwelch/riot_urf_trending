RSpec.describe 'user visits the champion index page' do
  let!(:champion)   { create(:champion) }
  let!(:cms)        { create(:champion_matches_stat, champion: champion) }
  let!(:mb)         { create(:match_ban, champion: champion) }
  let!(:champion2)  { create(:champion, name: 'Amumu') }
  let!(:cms2)       { create(:champion_matches_stat, champion: champion2) }
  let!(:mb2)        { create(:match_ban, champion: champion2) }
  let!(:champion3)  { create(:champion, name: 'Murphy') }
  let!(:cms3)       { create(:champion_matches_stat, champion: champion3) }
  let!(:mb3)        { create(:match_ban, champion: champion3) }

  scenario 'has data for all champions' do
    visit champions_path

    expect(page).to have_content champion.name
    expect(page).to have_content cms.victories + cms.losses
    expect(page).to have_content champion2.name
    expect(page).to have_content cms2.victories + cms2.losses
    expect(page).to have_content champion3.name
    expect(page).to have_content cms3.victories + cms3.losses
  end
end
