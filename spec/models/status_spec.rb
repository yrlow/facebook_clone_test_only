require 'rails_helper'

RSpec.describe Status, type: :model do

  context "validations" do
    it "should have title and content and user_id" do
      should have_db_column(:title).of_type(:string)
      should have_db_column(:content).of_type(:text)
      should have_db_column(:user_id).of_type(:integer)
    end

    describe "validates presence of attributes" do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_presence_of(:content) }
    end

    describe "validates length of title & content" do
      it { should validate_length_of(:title).is_at_least(8).with_message(/title is too short/)}
      it { should validate_length_of(:content).is_at_least(10).with_message(/content is too short/)}
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }

  end

  context 'most recent status showed first' do
    it 'retrieves the most recent status first' do
      status_1 = Status.create(title: "How do you feel today?", content: "I feel good, what about you?")
      status_2= Status.create(title: "How r u today?",
        content: "I feel terribly bad, I m sick",
        created_at: Time.now + 1.hour
      )
      expect(Status.first).to eq(status_2)
    end
  end

end
