describe 'User Dashboard' do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    visit root_path
    within('.nav') { click_link('Login') }
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end

  it 'has a link to start a new game' do
    pending "expect(page).to have_link('New Game')"
  end

  it 'shows the users win/loss record'

  it 'shows the users active games'

  it 'show all games awaiting players'

end