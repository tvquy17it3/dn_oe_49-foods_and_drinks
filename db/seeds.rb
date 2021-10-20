# Fake accounts and address
10.times do |n|
  name = Faker::Name.unique.name
  email = "example-#{rand(252...4350)}@test-example.com"
  password = "password123"
  phone = Faker::PhoneNumber.phone_number
  address = Faker::Address.full_address
  u = User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   status: true,
                   role: 0)
  u.addresses.create!(name: name,
                      phone: phone,
                      address: address)
end

# Fake category
10.times do |n|
  name = Faker::Food.ingredient
  description = Faker::Food.description
  Category.create!(name: name, description: description)
end

# Fake products
categories = Category.order(:created_at).take(6)
30.times do |n|
  name = Faker::Food.fruits
  price = 200000
  description = Faker::Food.description
  status = true
  categories.each do |category|
    category.products.create!(name: name,
                              price: price,
                              description: description,
                              quantity: 3,
                              status: status)
  end
end

# Fake address and set is_default: true
User.all.each do |user|
  2.times do
  user.addresses.create(
    name: Faker::Name.unique.name,
    phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address)
  end
  user.addresses.last.update_column :is_default, true
end

# Fake orders
User.all.sample(10).each do |user|
  address1 = user.addresses.sample(1)
  product = Product.all.sample(1)
  order = user.orders.build(
    phone: address1[0].phone,
    address: address1[0].address,
    total_price: product[0].price,
    address_id: address1[0].id)
  order.order_details.build(
    quantity: 2,
    price: product[0].price,
    product_id: product[0].id)
  order.save
end
