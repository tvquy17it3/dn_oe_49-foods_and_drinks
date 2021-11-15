require 'rails_helper'

RSpec.describe OrderDetail, type: :model do
  describe "Associations" do
    it { should belong_to(:order) }
    it { should belong_to(:product) }
  end

  describe "Delegates" do
    it { should delegate_method(:name).to(:product).with_prefix(true) }
    it { should delegate_method(:thumbnail).to(:product).with_prefix(true) }
  end

  describe "validates" do
    subject { FactoryBot.create :order_detail }

    it "is valid with valid attributes" do
      is_expected.to be_valid
    end

    context "price" do
      it "is not valid without a price" do
        is_expected.to validate_presence_of(:price)
      end
      it "is not valid price < 0" do
        subject.price = Settings.rspec.length_negative_1
        expect(subject).to_not be_valid
      end
      it "is not valid price value string" do
        subject.price = "foo"
        expect(subject).to_not be_valid
      end
    end

    context "quantity" do
      it "is not valid without a quantity" do
        is_expected.to validate_presence_of(:quantity)
      end
      it "is not valid quantity < 0" do
        subject.quantity = Settings.rspec.length_negative_1
        expect(subject).to_not be_valid
      end
      it "is not valid quantity value string" do
        subject.quantity = "foo"
        expect(subject).to_not be_valid
      end
      it "is not valid quantity value float" do
        subject.quantity = Settings.rspec.float1_1
        expect(subject).to_not be_valid
      end
    end
  end
end
