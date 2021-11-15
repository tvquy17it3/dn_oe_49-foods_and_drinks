require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "Associations" do
    it { should belong_to(:category) }
    it { should have_many(:order_details).dependent(:destroy) }
    it { should have_many(:orders).through(:order_details) }
    it { should have_one_attached(:thumbnail) }
    it { should have_many_attached(:images) }
    it { should accept_nested_attributes_for(:category).allow_destroy(true) }
  end

  describe "Delegates" do
    it { should delegate_method(:name).to(:category).with_prefix(true) }
  end

  describe "Enum" do
    it { should define_enum_for(:status) }
  end

  describe "Scopes" do
    let!(:category) {FactoryBot.create :category}
    let!(:product_1) {FactoryBot.create :product, category_id: category.id}
    let!(:product_2) {FactoryBot.create :product}

    context "find_name" do
      it "search name is exist" do
        expect(Product.find_name(product_1.name)).to eq [product_1]
      end
      it "search name not found" do
        expect(Product.find_name(Settings.rspec.length_negative_1)).to eq []
      end
    end

    it "recent_products sort DESC" do
      expect(Product.recent_products).to eq [product_2, product_1]
    end

    context "find products cart" do
      it "find products cart" do
        expect(Product.find_products_cart(product_1.id)).to eq [product_1]
      end
      it "find products not found" do
        expect(Product.find_products_cart(Settings.rspec.length_negative_1)).to eq []
      end
    end

    context "filter category" do
      it "category exist" do
        expect(Product.filter_category(category.id)).to eq [product_1]
      end
      it "category not found" do
        expect(Product.filter_category(Settings.rspec.length_negative_1)).to eq []
      end
    end
  end

  describe "validates" do
    subject {FactoryBot.create :product}

    it "is valid with valid attributes" do
        is_expected.to be_valid
    end

    context "name" do
      it {is_expected.to validate_presence_of(:name)}
      it "when too short is invalid" do
        is_expected.to_not validate_length_of(:name).is_at_most(Settings.rspec.length_4)
      end
      it "is not valid with too long" do
        is_expected.to_not validate_length_of(:name).is_at_most(Settings.rspec.length_251)
      end
    end

    context "price" do
      it { is_expected.to validate_presence_of(:price) }
      it { should_not allow_value(Settings.rspec.length_negative_1).for(:price) }
      it { should_not allow_value("foo").for(:price) }
    end

    context "quantity" do
      it { is_expected.to validate_presence_of(:quantity) }
      it { should_not allow_value(Settings.rspec.length_negative_1).for(:quantity) }
      it { should_not allow_value("foo").for(:quantity) }
      it { is_expected.to validate_numericality_of(:quantity).only_integer }
    end
  end
end
