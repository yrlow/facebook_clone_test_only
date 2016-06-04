require 'rails_helper'

RSpec.describe StatusesController, type: :controller do


  let(:user) {User.create(name: "Josh Teng", email: "josh@na.com", password: "123456", password_confirmation: "123456")}
  let(:valid_params) {{ title: "Day One Healthy Challenge", content: "Banana Chocolate Smoothie", user_id: user.id}}
  let(:invalid_params) {{ title: "Day", content: "Banana Chocolate Smoothie", user_id: user.id}}
  let(:valid_params_update) {{ title: "Day One Healthy Challengesss", content: "Banana Chocolate Smoothie", user_id: user.id}}
  let(:invalid_params_update) {{ title: "Day1", content: "Banana Chocolate Smoothie", user_id: user.id}}

  describe "GET #new" do
    before do
      session[:user_id] = user.id
      get :new
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders the new template" do
      expect(response).to render_template("new")
    end

    it "assigns instance post" do
      expect(assigns[:status]).to be_a Status
    end
  end


  describe "POST #create" do
    before do
      session[:user_id] = user.id
    end
    # happy_path
    context "valid_params" do
      it "creates new status if params are correct" do
        expect {post :create, :status => valid_params}.to change(Status, :count).by(1)
      end

      it 'redirects to post path and displays flash notice after status is created successfully' do
        post :create, status: valid_params
        expect(response).to redirect_to(Status.last)
        expect(flash[:notice]).to eq "Status is created successfully."
      end
    end

    # unhappy_path
    context "invalid_params" do
      before do
        session[:user_id] = user.id
        post :create, status: invalid_params
      end

      it "displays flash alert message" do
        expect(flash[:alert]).to include "Error creating status."
      end

      it "renders new template again" do
        expect(response).to render_template("new")
      end
    end
  end

  describe "GET #edit" do
    before do
      session[:user_id] = user.id
      status = FactoryGirl.create(:status, :id=> user.id)
      get :edit, {:id => status.to_param}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders the edit template" do
      expect(response).to render_template("edit")
    end

  end


  describe "PUT #update" do
    before do
      session[:user_id] = user.id
    end
  # happy_path
    context "with valid update params" do
      it "updates the requested status" do
        status = FactoryGirl.create(:status, :id=> user.id)
        put :update, {:id => status.to_param, :status => valid_params_update}
        status.reload
        expect( status.title).to eq valid_params_update[:title]
      end

      it 'redirects to status path and displays flash notice after status is updated successfully' do
        status = FactoryGirl.create(:status, :id=> user.id)
        put :update, {:id => status.to_param, :status=> valid_params_update}
        status.reload
        expect(response).to redirect_to(status_path(status))
        expect(flash[:notice]).to eq "Status is updated successfully."
      end
    end
    # unhappy_path
    context "with invalid update params" do
      it "re-renders the 'edit' template" do
        status = FactoryGirl.create(:status, :id=> user.id)
        put :update, {:id => status.to_param, :status=> invalid_params_update}
        expect(response).to render_template("edit")
      end
    end

  end


  describe "DELETE #destroy" do
    before do
      session[:user_id] = user.id
    end

    it "destroys the requested status" do
      status = FactoryGirl.create(:status, :id=> user.id)
      expect {
        delete :destroy, {:id => status.to_param}
      }.to change(Status, :count).by(-1)
    end

    it "redirects to the statuses_path" do
      status = FactoryGirl.create(:status, :id=> user.id)
      delete :destroy, {:id => status.to_param}
      expect(response).to redirect_to(statuses_path)
      expect(flash[:notice]).to eq "Status is deleted."
    end
  end

end
