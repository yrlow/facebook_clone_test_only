require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  let(:user) { create(:user, password: "123456", password_confirmation: "123456") }
  let(:valid_params) {{session: {email: user.email, password: "123456", password_confirmation: "123456"}}}
  let(:invalid_params) {{session: {email: user.email, password: "1234567", password_confirmation: "1234567"}}}

  describe "GET #new" do

    before do
      get :new
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders the new template" do
      expect(response).to render_template("new")
    end

  end

  describe "POST #create" do
    # happy path
    context "valid log in params" do

      before do
        post :create, valid_params
      end

      it "sets session user_id" do
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to statuses_path" do
        expect(response).to redirect_to(statuses_path)
      end

      it "greets the user" do
        expect(flash[:notice]).to be_present
        expect(flash[:notice]).to eq "Welcome, joshhhh@nextacademy.com!"
      end
    end

    # unhappy path
    context "invalid log in params" do

      before do
        post :create, invalid_params
      end

      it "does not set session user_id" do
        expect(session[:user_id]).to be nil
      end


      it "displays flash alert message" do
        expect(flash[:alert]).to include "Please log in again"
      end

      it "renders new template again" do
        expect(response).to render_template("new")
      end
    end


  end

  describe "DELETE #destroy" do

    before do
      post :create, valid_params
      delete :destroy
    end

    it "deletes the cookie" do
      expect(session[:user_id]).to eq nil
    end

    it "redirects back to the root path" do
      expect(response).to redirect_to(root_path)
    end
  end

end
