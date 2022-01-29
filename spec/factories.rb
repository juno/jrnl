FactoryBot.define do
  factory :post do
    content { "This is test post." }
  end

  factory :author, class: "User" do
    email { "john.smith@example.com" }
    password { "secret-phrase" }
    password_confirmation { "secret-phrase" }
  end
end
