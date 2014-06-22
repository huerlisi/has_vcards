require 'rails_helper'

describe HasVcards::PhoneNumbersController do
  routes { HasVcards::Engine.routes }
  before { @phone_number = FactoryGirl.create :phone_number }

  describe "GET 'show'" do

    it 'returns http success' do
      get :show, { id: @phone_number.id }
      expect(response).to be_success
    end

    it 'renders the show template' do
      get :show, { id: @phone_number.id }
      expect(response).to render_template('show')
    end

    it 'loads the specified record' do
      get :show, { id: @phone_number.id }
      expect(assigns(:phone_number)).to match(@phone_number)
    end
  end

  describe "GET 'index'" do

    it 'returns http success' do
      get :index
      expect(response).to be_success
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'loads all records' do
      get :index
      expect(assigns(:phone_numbers)).to match_array([@phone_number])
    end
  end
end
