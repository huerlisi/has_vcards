require 'rails_helper'

describe HasVcards::VcardsController do
  routes { HasVcards::Engine.routes }
  before { @vcard = FactoryGirl.create :vcard }

  describe "GET 'show'" do

    it 'returns http success' do
      get :show, { id: @vcard.id }
      expect(response).to be_success
    end

    it 'renders the show template' do
      get :show, { id: @vcard.id }
      expect(response).to render_template('show')
    end

    it 'loads the specified record' do
      get :show, { id: @vcard.id }
      expect(assigns(:vcard)).to match(@vcard)
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
      expect(assigns(:vcards)).to match_array([@vcard])
    end
  end
end
