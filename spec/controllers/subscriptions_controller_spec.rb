require "rails_helper"

RSpec.describe SubscriptionsController, :vcr, :type => :controller do
  render_views

  it "responds with errors when no data is specified" do
    post :create

    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(:unprocessable_entity)

    json = JSON.parse(response.body, :symbolize_names => true)

    expect(json.dig(:errors, :subscription)).to eq ["is missing"]
  end

  it "responds with a subscription when all the data is specified" do
    post :create, :params => build(:create_subscription_params)

    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(:created)

    json = JSON.parse(response.body, :symbolize_names => true)

    expect(json.dig(:data, :subscription, :id)).to be_instance_of Integer
  end
end
