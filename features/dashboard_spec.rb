require 'feature_helper'

feature 'Visit the dashboard an show the questions for the day' do
  before(:each) do
    DBHelpers.load_feature_fixtures
    @pq, _ = PQA::QuestionLoader.new.load_and_import
    create_pq_session
  end

  scenario 'can view the questions tabled for today' do
    visit dashboard_path
    expect(page).to have_content(@pq.text)
  end
end
