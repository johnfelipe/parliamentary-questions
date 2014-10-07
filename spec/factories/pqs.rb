# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :Pq do
    uin 'hl1234'
    house_id 1
    raising_member_id 1
    tabled_date "2014-05-08 13:45:31"
    response_due "2014-05-08 13:45:31"
    question "MyString"
    answer nil

    factory :answered_pq do
      preview_url Faker::Internet.url
    end
  end
end
