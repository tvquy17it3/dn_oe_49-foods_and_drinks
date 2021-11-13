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
end
