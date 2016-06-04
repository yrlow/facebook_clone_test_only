require 'rails_helper'

RSpec.describe Like, type: :model do
   context "validations" do
    it "should have status_id and user_id" do

      should have_db_column(:user_id).of_type(:integer)
      should have_db_column(:status_id).of_type(:integer)
    end

    describe "validates presence of attributes" do
      it { is_expected.to validate_presence_of(:user_id) }
      it { is_expected.to validate_presence_of(:status_id) }
    end


  end

  context "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:status) }
  end

end
