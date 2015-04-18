RSpec.describe 'user searches for a champion', :js do
  let!(:champion) { create(:champion, name: 'Teemo') }
  let!(:cm) do
    create(:champion_match, kills: 1, deaths: 2, champion: champion)
  end
  let!(:cms)      { create(:champion_matches_stat, champion: champion) }

  def search_for(champion)
    within 'form' do
      fill_in 'name', with: champion
      click_button I18n.t('layouts.application.search')
    end
  end

  before do
    visit root_path
  end

  scenario 'goes to the champion detail page' do
    search_for(champion.name)

    expect(page).to have_content champion.name
    expect(page).to have_content I18n.t('champions.show.chart_title')
  end

  describe 'with a misspelled name' do
    context 'with a common misspelling' do
      context 'Dr. Mundo' do
        let!(:mundo) { create(:champion, name: 'Dr. Mundo') }
        let!(:cms2)  { create(:champion_matches_stat, champion: mundo) }

        scenario 'corrects the spelling' do
          search_for('Mundo')

          expect(page).to have_content mundo.name
          expect(page).to have_content I18n.t('champions.show.chart_title')
        end
      end

      context "Champion with ' in the name" do
        let!(:khazix) { create(:champion, name: "Kha'Zix") }
        let!(:cms2)  { create(:champion_matches_stat, champion: khazix) }

        scenario 'corrects the spelling' do
          search_for('Khazix')

          expect(page).to have_content khazix.name
          expect(page).to have_content I18n.t('champions.show.chart_title')
        end
      end
    end

    context 'nonexistent champion' do
      scenario 'goes to the no results page' do
        search_for('timo')

        expect(page).to have_content I18n.t('champions.empty_search.no_results',
                                            name: 'timo')
      end
    end
  end
end
