require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Associations" do
    it "has many orders" do
      is_expected.to have_many(:orders)
    end
    it "has many addresses" do
      is_expected.to have_many(:addresses)
    end
  end

  describe "validates" do
    subject { FactoryBot.create :user }

    it "is valid with valid attributes" do
        is_expected.to be_valid
    end

    context "name" do
      it "when nil is invalid name" do
        is_expected.to validate_presence_of(:name)
      end
      it "when too short is invalid" do
        is_expected.to_not validate_length_of(:name).is_at_most(Settings.rspec.length_4)
      end
      it "is not valid with too long" do
        is_expected.to_not validate_length_of(:name).is_at_most(Settings.rspec.length_101)
      end
      it { is_expected.to validate_length_of(:name).is_at_least(Settings.length.min_5).is_at_most(Settings.length.max_100) }
    end
  end

  describe "methods" do
    let(:user){FactoryBot.create :user}

    context "recent_orders" do
      let!(:order_1){FactoryBot.create :order, user_id: user.id}
      let!(:order_2){FactoryBot.create :order, user_id: user.id}

      it "return orders of user has sort DESC" do
        expect user.all_orders.recent_orders.should eq [order_2, order_1]
      end
    end
  end
end
