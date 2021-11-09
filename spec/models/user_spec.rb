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
      it "is valid" do
        is_expected.to_not validate_length_of(:name).is_at_most(Settings.rspec.length_20)
      end
    end

    context "email" do
      it "when nil is invalid" do
        expect(FactoryBot.build(:user, email: nil)).to_not be_valid
      end
      it "must uniqueness" do
        is_expected.to validate_uniqueness_of(:email).case_insensitive
      end
      it "when too long is invalid" do
        is_expected.to_not allow_value("foo").for(:email)
      end
      it "when too long is invalid" do
        is_expected.to allow_value("foo@gmail.com").for(:email)
      end
    end

    context "password" do
      it "when nil is invalid" do
        subject.password = nil
        is_expected.to_not be_valid
      end
      it "when too short is invalid" do
        is_expected.to_not validate_length_of(:password).is_at_most(Settings.rspec.length_7)
      end
      it "when valid" do
        is_expected.to_not validate_length_of(:password).is_at_most(Settings.rspec.length_12)
      end
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

    it "forget user" do
      expect user.forget.should eq true
    end
  end
end
