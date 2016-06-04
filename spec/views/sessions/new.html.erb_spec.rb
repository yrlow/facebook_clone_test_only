
require 'rails_helper'

RSpec.describe "sessions/new.html.erb", type: :view do
  it "displays the login screen" do
    render

    expect(rendered).to match /Password/
    expect(rendered).to match /Email/
  end
end


