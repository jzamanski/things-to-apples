describe 'home page' do
  it 'displays for root URL' do
    visit '/'
    page.should have_content('Home#index')
  end

  context 'when not logged in' do
    it 'has a login link which redirects to the login page' do
      visit '/'
      page.should have_link('Login')
    end

    it 'has a signup link' do
      visit '/'
      page.should have_link('Sign up')
    end
  
    it 'does not have a logout link' do
      visit '/'
      page.should_not have_link('Logout')
    end

    it 'does not have an edit account link' do
      visit '/'
      page.should_not have_link('Edit account')
    end

    it 'clicking login link shows login page' do
      visit '/'
      click_link 'Login'
      current_path.should == new_user_session_path
    end

    it 'clicking signup link shows sign up page' do
      visit '/'
      click_link 'Sign up'
      current_path.should == new_user_registration_path
    end
  end

end
