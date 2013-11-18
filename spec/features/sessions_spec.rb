describe 'User Sessions' do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    visit root_path
    within('.nav') { click_link('Login') }
  end

  context 'failure' do
    before do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: ''
      click_button 'Sign in'
    end

    it 'displays an error message' do
      expect(page).to have_content('Invalid email or password.')
    end

    it 'shows the correct navigation links' do
      within('.nav') do
        expect(page).to have_link('Login')
        expect(page).to have_link('Sign up')
        expect(page).to_not have_link('Edit account')
        expect(page).to_not have_link('Logout')
      end
    end
  end

  context 'success' do
    before do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end

    it 'displays a welcome message' do
      expect(page).to have_content('Signed in successfully.')
    end

    it 'shows the correct navigation links' do
      within('.nav') do
        expect(page).to have_link('Edit account')
        expect(page).to have_link('Logout')
        expect(page).to_not have_link('Login')
        expect(page).to_not have_link('Sign up')
      end
    end
  end
end
