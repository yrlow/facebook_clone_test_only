require 'rails_helper'

RSpec.describe "welcome/index.html.erb", type: :view do
  it "displays the home button that links to root path" do
    render
    expect(rendered).to have_link("Home", href: root_path)
  end

  context "logged in" do
    it "display log out button" do
      user = FactoryGirl.create(:user)
      session[:user_id] = user.id
      render
      expect(rendered).to have_link("Log Out", href: signout_path)
    end
  end

  context "not logged in" do
    it "display log in button" do
      render
      expect(rendered).to have_link("Log In", href: new_session_path)
    end
  end
end


