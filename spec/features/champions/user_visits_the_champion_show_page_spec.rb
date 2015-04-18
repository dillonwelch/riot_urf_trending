RSpec.describe 'user visits the champion show page' do
  let!(:champion)   { create(:champion) }
  let!(:cms)        { create(:champion_matches_stat, champion: champion) }
  let!(:mb)         { create(:match_ban, champion: champion) }
  let!(:champion2)  { create(:champion, name: 'Amumu') }
  let!(:cms2)       { create(:champion_matches_stat, champion: champion2) }
  let!(:mb2)        { create(:match_ban, champion: champion2) }

  scenario 'only displays the correct champion' do
    visit champion_path(name: champion.name)

    expect(page).to have_content champion.name
    expect(page).to have_content cms.victories + cms.losses
    expect(page).not_to have_content champion2.name
    expect(page).not_to have_content cms2.victories + cms2.losses
  end
end
