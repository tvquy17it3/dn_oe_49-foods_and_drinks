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

# Fake address and set is_default true
User.all.each do |user|
  2.times do
  user.addresses.create(
    name: Faker::Name.unique.name,
    phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address)
  end
  user.addresses.last.update_column :is_default, true
end
