require 'rails_helper'

RSpec.describe Address, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe "Delegates" do
    it { should delegate_method(:name).to(:user).with_prefix(true) }
    it { should delegate_method(:email).to(:user).with_prefix(true) }
  end
end
