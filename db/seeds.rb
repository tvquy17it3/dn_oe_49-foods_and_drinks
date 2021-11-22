#Fake accounts and address
30.times do |n|
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
8.times do |n|
  name = Faker::Food.ingredient
  description = Faker::Food.description
  Category.create!(name: name, description: description)
end

# # Fake products
50.times do |n|
  categories = Category.order(:created_at).sample(1)
  name = Faker::Food.fruits
  price = 200000
  description = Faker::Food.description
  quantity = rand(0..50)
  status = rand(0..1)
  categories.each do |category|
    category.products.create!(name: name,
                              price: price,
                              description: description,
                              quantity: quantity,
                              status: status)
  end
end

# #Fake address and set is_default: true
User.all.each do |user|
  2.times do
  user.addresses.create(
    name: Faker::Name.unique.name,
    phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address)
  end
  user.addresses.last.update_column :is_default, true
end

phone = Faker::PhoneNumber.phone_number
address = Faker::Address.full_address
user = User.create!(name: "Admin",
                   email: "admin@gmail.com",
                   password: "123456789",
                   password_confirmation: "123456789",
                   status: true,
                   role: 1)
user.addresses.create!(name: user.name,
                       phone: phone,
                       address: address)

phone = Faker::PhoneNumber.phone_number
address = Faker::Address.full_address
user = User.create!(name: "Van Quy",
                   email: "vanquy.dev@gmail.com",
                   password: "123456789",
                   password_confirmation: "123456789",
                   status: true,
                   role: 0)
user.addresses.create!(name: user.name,
                       phone: phone,
                       address: address)

# Fake orders
User.all.sample(30).each do |user|
  address1 = user.addresses.sample(1)
  product = Product.all.sample(1)
  order = user.orders.build(
    name: address1[0].name,
    phone: address1[0].phone,
    address: address1[0].address,
    total_price: product[0].price,
    address_id: address1[0].id)
  order.order_details.build(
    quantity: rand(1..3),
    price: product[0].price,
    product_id: product[0].id)
  order.save!
end

# Fake orders
5.times do
  user = User.find_by email: "vanquy.dev@gmail.com"
  address1 = user.addresses.sample(1)
  product = Product.all.sample(1)
  order = user.orders.build(
    name: address1[0].name,
    phone: address1[0].phone,
    address: address1[0].address,
    total_price: product[0].price,
    address_id: address1[0].id)
  order.order_details.build(
    quantity: rand(1..3),
    price: product[0].price,
    product_id: product[0].id)
  order.save!
end
