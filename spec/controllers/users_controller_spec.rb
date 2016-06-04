require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_params) {{ name: "Josh Teng", email: "josh@na.com", password: "123456", password_confirmation: "123456"}}
  let(:invalid_params) {{ name: "Josh Teng", email: "joshna.com", password: "123456", password_confirmation: "123456"}}
  let(:valid_params_update) {{ name: "Josh", email: "josh@nextacademy1.com", password: "123456", password_confirmation: "123456"}}
  let(:invalid_params_update) {{ name: "Josh", email: "joshnextacademy1.com", password: "123456", password_confirmation: "123456"}}

  let(:user){User.create(valid_params)}
  let(:user1){User.create(name: "Audrey", email:"audrey@na.com", password: "123456", password_confirmation: "123456")}

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

    it "assigns instance user" do
      expect(assigns[:user]).to be_a User
    end
  end


  describe "POST #create" do
    # happy_path
    context "valid_params" do
      it "creates new user if params are correct" do
        expect {post :create, :user => valid_params}.to change(User, :count).by(1)
      end

      it 'redirects to user path and displays flash notice after user created successfully' do
        post :create, user: valid_params
        expect(response).to redirect_to(User.last)
        expect(flash[:notice]).to eq "Account created. Please log in now."
      end
    end

    # unhappy_path
    context "invalid_params" do
      before do
        post :create, user: invalid_params
      end

      it "displays flash alert message" do
        expect(flash[:alert]).to include "Error creating account: "
      end

      it "renders new template again" do
        expect(response).to render_template("new")
      end
    end
  end



  describe "GET #edit" do
    before do
      session[:user_id] = user.id
      get :edit, {:id => user.to_param}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders the edit template" do
      expect(response).to render_template("edit")
    end

  end


  describe "PUT #update" do
  # happy_path
    context "with valid update params" do
      it "updates the requested user" do
        user = user1
        put :update, {:id => user.to_param, :user => valid_params_update}
        user.reload
        expect( user.email ).to eq valid_params_update[:email]
      end

      it 'redirects to user path and displays flash notice after user profile is updated successfully' do

        put :update, {:id => user.to_param, :user => valid_params_update}
        user.reload
        expect(response).to redirect_to(user_path(user))
        expect(flash[:notice]).to eq "Account is updated successfully."
      end
    end
    # unhappy_path
    context "with invalid update params" do
      it "re-renders the 'edit' template" do
        put :update, {:id => user.to_param, :user => invalid_params_update}
        expect(response).to render_template("edit")
      end
    end

  end


  describe "DELETE #destroy" do

    it "destroys the requested user" do
      user = user1
      expect {
        delete :destroy, {:id => user.to_param}
      }.to change(User, :count).by(-1)
    end

    it "redirects to the statuses_path" do
      user = user1
      delete :destroy, {:id => user.to_param}
      expect(response).to redirect_to(statuses_path)
      expect(flash[:notice]).to eq "Account is deleted"
    end
  end

end
