FactoryBot.define do
  factory :order_detail do
    quantity{2}
    price{200000}
    order_id{create(:order).id}
    product_id{create(:product).id}
  end
end
