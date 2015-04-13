# RSpec.describe 'user visits the by win rate page', js: true do
#   let(:c1) { create(:champion) }
#   let(:c2) { create(:champion) }
#   let(:time) { (Time.zone.now - 30.minutes).to_i * 1000 }
#
#   before do
#     Timecop.travel(Time.utc(2015, 4, 5, 9, 7, 26))
#     match1 = create(:match, start_time: time)
#     match2 = create(:match, start_time: time)
#     match3 = create(:match, start_time: time)
#     create(:champion_match, champion: c1, match: match1, victory: true)
#     create(:champion_match, champion: c1, match: match2, victory: true)
#     create(:champion_match, champion: c1, match: match3, victory: false)
#     create(:champion_match, champion: c2, match: match1, victory: true)
#     create(:champion_match, champion: c2, match: match2, victory: false)
#     create(:champion_match, champion: c2, match: match3, victory: false)
#     visit champions_by_win_rate_path
#   end
#
#   after do
#     Timecop.return
#   end
#
#   it 'puts the top champion first' do
#     expect(page).to have_content "#1: #{c1.name}"
#   end
#
#   it 'puts the second champion second' do
#     expect(page).to have_content "#2: #{c2.name}"
#   end
# end
