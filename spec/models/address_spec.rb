require 'rails_helper'

RSpec.describe Address, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe "Delegates" do
    it { should delegate_method(:name).to(:user).with_prefix(true) }
    it { should delegate_method(:email).to(:user).with_prefix(true) }
  end

  describe "validates" do
    subject { FactoryBot.create :address }

    it "is valid with valid attributes" do
        is_expected.to be_valid
    end

    context "name" do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_least(Settings.length.min_5).is_at_most(Settings.length.max_250) }
    end

    context "phone" do
      it { is_expected.to validate_presence_of(:phone) }
      it { is_expected.to validate_length_of(:phone).is_at_least(Settings.length.min_5).is_at_most(Settings.length.max_250) }
    end

    context "address" do
      it { is_expected.to validate_presence_of(:address) }
      it { is_expected.to validate_length_of(:address).is_at_least(Settings.length.min_5).is_at_most(Settings.length.max_250) }
    end
  end
end
