RSpec.describe ChampionHistoryQuery do
  let(:champion) { create(:champion) }
  let(:id)       { champion.id }
  let(:result) do
    ChampionHistoryQuery.new(champion_id: id, start_time: Time.zone.now).
      run.to_a
  end
  let(:final_result) do
    [
      { 'victories' => '5', 'losses' => '0', 'champion_id' => id.to_s,
        'win_rate' => '100', 'time' => '1' },
      { 'victories' => '4', 'losses' => '1', 'champion_id' => id.to_s,
        'win_rate' => '80', 'time' => '2' },
      { 'victories' => '3', 'losses' => '2', 'champion_id' => id.to_s,
        'win_rate' => '60', 'time' => '3' },
      { 'victories' => '2', 'losses' => '3', 'champion_id' => id.to_s,
        'win_rate' => '40', 'time' => '4' },
      { 'victories' => '1', 'losses' => '4', 'champion_id' => id.to_s,
        'win_rate' => '20', 'time' => '5' },
      { 'victories' => '0', 'losses' => '5', 'champion_id' => id.to_s,
        'win_rate' => '0', 'time' => '6' }
    ]
  end

  before do
    Timecop.freeze(Time.utc(2015, 4, 5, 9, 7, 26))

    victories = [
      [true, true, true, true, true],
      [true, true, true, true, false],
      [true, true, true, false, false],
      [true, true, false, false, false],
      [true, false, false, false, false],
      [false, false, false, false, false]
    ]

    matches = []

    [Time.zone.now + 30.minutes,
     Time.zone.now - 30.minutes,
     Time.zone.now - 90.minutes,
     Time.zone.now - 150.minutes,
     Time.zone.now - 210.minutes,
     Time.zone.now - 270.minutes].each_with_index do |time, index|
      matches = create_list(:match, 5, start_time: time.to_i * 1000)
      matches.each_with_index do |match, subindex|
        victory = victories[index][subindex]
        create(:champion_match,
               champion: champion,
               match: match,
               victory: victory)
      end
    end
  end

  it 'returns the expected result' do
    expect(result).to eq final_result
  end
end
