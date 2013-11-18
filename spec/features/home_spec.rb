describe 'Home Page' do
  before :each do
    visit root_path
  end

  it 'displays a welcome message' do
    page.should have_content('Home#index')
  end

  it 'shows the correct navigation links' do
    within('.nav') do
      expect(page).to have_link('Login')
      expect(page).to have_link('Sign up')
      expect(page).to_not have_link('Edit account')
      expect(page).to_not have_link('Logout')
    end
  end

  context 'when clicking login link' do
    it 'shows login page' do
      visit '/'
      click_link 'Login'
      current_path.should == new_user_session_path
    end
  end

  context 'when clicking signup link' do
    it 'shows sign up page' do
      visit '/'
      click_link 'Sign up'
      current_path.should == new_user_registration_path
    end
  end
end
