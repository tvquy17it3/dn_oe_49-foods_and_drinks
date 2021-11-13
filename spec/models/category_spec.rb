require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "Associations" do
    it { should have_many(:products).dependent(:destroy) }
  end

  describe "validates" do
    subject { FactoryBot.create :category }

    it "is valid with valid attributes" do
        is_expected.to be_valid
    end

    context "name" do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_least(Settings.length.min_2).is_at_most(Settings.length.max_250) }
    end

    context "description" do
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_length_of(:description).is_at_least(Settings.length.min_2).is_at_most(Settings.length.max_250) }
    end
  end
end
