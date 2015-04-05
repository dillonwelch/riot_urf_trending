RSpec.describe 'champions/by_win_rate' do
  before do
    render
  end

  it 'has the title' do
    expect(response).to have_css 'h1',
                                 text: I18n.t('champions.by_win_rate.title')
  end

  describe 'charts' do
    (1..5).each do |num|
      describe "chart#{num}" do
        it 'has the title tag' do
          expect(response).to have_selector("span#title#{num}")
        end

        it 'has the image tag' do
          expect(response).to have_selector("img#image#{num}")
        end

        it 'has the canvas element' do
          expect(response).to have_selector("canvas#chart#{num}")
        end
      end
    end
  end
end
