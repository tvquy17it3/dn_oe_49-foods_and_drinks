require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:order_details).dependent(:destroy) }
    it { should have_many(:products).through(:order_details) }
  end

  describe "Delegates" do
    it { should delegate_method(:name).to(:user).with_prefix(true) }
    it { should delegate_method(:email).to(:user).with_prefix(true) }
    it { should delegate_method(:name).to(:user).with_prefix(true) }
  end

  describe "Scope" do
    let!(:order_1){FactoryBot.create :order}
    let!(:order_2){FactoryBot.create :order}

    it "return orders has sort DESC" do
      expect Order.recent_orders.should eq [order_2, order_1]
    end
  end

  describe "enums" do
    it "define status as an enum"do
      should define_enum_for(:status).with_values(
        open: Settings.open,
        confirmed: Settings.confirmed,
        shipping: Settings.shipping,
        completed: Settings.completed,
        cancelled: Settings.cancelled,
        disclaim: Settings.disclaim)
    end
  end

  describe "validates" do
    subject { FactoryBot.create :order }

    it "is valid with valid attributes" do
      is_expected.to be_valid
    end
    it "is not valid without a name" do
      is_expected.to validate_presence_of(:name)
    end
    it "is not valid without a phone" do
      is_expected.to validate_presence_of(:phone)
    end
    it "is not valid without a address" do
      is_expected.to validate_presence_of(:address)
    end
    it "is not valid with name too long" do
      is_expected.to_not validate_length_of(:name).is_at_most(Settings.rspec.length_251)
    end

    context "total price" do
      it "is not valid without a total_price" do
        is_expected.to validate_presence_of(:total_price)
      end
      it "is not valid total_price < 0" do
        subject.total_price = Settings.rspec.length_negative_1
        expect(subject).to_not be_valid
      end
      it "is not valid total_price value string" do
        subject.total_price = "foo"
        expect(subject).to_not be_valid
      end
    end
  end
end
