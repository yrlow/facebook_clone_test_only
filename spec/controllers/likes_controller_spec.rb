require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user){User.create(name: "ping", email:"ping@na.com", password: "123456", password_confirmation: "123456")}
  let(:status){user.statuses.create(title: "hello world!", content: "Coding is fun!")}
  let(:status1){user.statuses.create(title: "hello world!!!", content: "Coding is fun!")}

  describe "POST #create" do
    context "successfully liked" do

      before do
        session[:user_id] = user.id
        post :create, :like=> {status: status, user: user}
      end

      it "status likes will increase by 1" do
        expect(status.likes.count).to eq 1
      end

      it 'redirects to root_path and displays flash notice after successfully liked status' do
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to eq "You liked #{status.title}!"
      end
    end

    context "duplicate like" do

      before do
        session[:user_id] = user.id
        Like.create(user_id: user.id, status_id: status.id)
      end

      it "status likes count will not change" do
        expect{post :create, :like=> {user: user, status: status}}.to change(Like, :count).by(0)
      end

      it 'displays flash alert message' do
        post :create, :like=> {user: user, status: status}
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq "You liked before!"
      end

    end

  end



  describe "DELETE #destroy" do
    before do
      session[:user_id] = user.id
    end

    it "destroys the requested like" do
      like =  Like.create(user_id: user.id, status_id: status1.id)
      expect {delete :destroy, {:id => like.to_param}}.to change(Like, :count).by(-1)
    end

    it "redirects to the status_path" do
      like =  Like.create(user_id: user.id, status_id: status1.id)
      delete :destroy, {:id => like.to_param}
      expect(response).to redirect_to(status_path(status1))
      expect(flash[:notice]).to eq "You unlike."
    end
  end



end
