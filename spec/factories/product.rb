FactoryBot.define do
  factory :product do
    name{"Fruit " << Faker::Food.fruits}
    description{Faker::Food.description}
    price{200000}
    quantity{10}
    status{1}
    category_id{create(:category).id}
  end
end
