require 'rails_helper'
require 'byebug'

RSpec.describe 'API::V1::Cervejas', type: :request do

  describe 'GET /v1/cervejas' do
    let(:number_beers) { 5 }
    let(:body) { JSON.parse(response.body) }

    before do
      FactoryBot.create_list(:cerveja, number_beers)
      get '/api/v1/cervejas', nil
    end

    it 'return status ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'return array of beers' do
      expect(body['cervejas']).to be_a_kind_of(Array)
    end

    it 'return right amount of beers' do
      expect(body['cervejas'].count).to eql(number_beers)
    end

    it 'returns beers with expected keys' do
      expected = ["estilo", "id", "temperatura_max", "temperatura_min", "updated_at", "created_at"]
      expect(body['cervejas'].first.keys).to match_array(expected)
    end
  end

  describe 'GET /v1/cervejas/:id' do
    context 'when has a valid id' do
      let(:number_beers) { 5 }
      let(:beer) { FactoryBot.create(:cerveja) }
      let(:data) { JSON.parse(response.body)['cerveja'] }
      let(:cerveja) { body['cerveja'] }

      before do
        FactoryBot.create_list(:cerveja, number_beers)
        get "/api/v1/cervejas/#{beer.id}", nil
      end

      it 'return status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the right beer' do
        expect(data['id']).to eql(beer.id)
        expect(data['estilo']).to eql(beer.estilo)
        expect(data['temperatura_max']).to eql(beer.temperatura_max.to_s)
        expect(data['temperatura_min']).to eql(beer.temperatura_min.to_s)
      end
    end

    context 'when has an invalid id' do
      let(:number_beers) { 5 }

      before do
        FactoryBot.create_list(:cerveja, number_beers)
        get "/api/v1/cervejas/-1", nil
      end

      it 'return status not_found' do
        expect(response).to have_http_status(:not_found)
      end

    end
  end

  describe 'POST /v1/cervejas' do
    let(:beer_params) { { estilo: Faker::Lorem.word,
                          temperatura_max: rand(0.0..15.0),
                          temperatura_min: rand(-15.0..0.0)
                        } }
    let(:data) { JSON.parse(response.body) }

    context 'when have right params' do
      before do
        post '/api/v1/cervejas', beer_params
      end

      it 'then status is created' do

        expect(response).to have_http_status(:created)
      end

      it 'return beer with right values' do
        beer = data['cerveja']
        expect(beer['id']).not_to be_nil
        expect(beer['estilo']).to eql(beer_params[:estilo])
        expect(beer['temperatura_max']).to eql(beer_params[:temperatura_max].to_s)
        expect(beer['temperatura_min']).to eql(beer_params[:temperatura_min].to_s)
      end
    end

    context 'when have params without estilo' do
      before do
        beer_params[:estilo] = nil
        post '/api/v1/cervejas', beer_params
      end

      it 'then status is unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "return response with message: Estilo can't be blank" do
        expect(data['details']).to include("Estilo can't be blank")
      end
    end

    context 'when have params without temperatura_max' do
      before do
        beer_params[:temperatura_max] = nil
        post '/api/v1/cervejas', beer_params
      end

      it 'then status is unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "return response with message: Temperatura max can't be blank" do
        expect(data['details']).to include("Temperatura max can't be blank")
      end
    end

    context 'when have params without temperatura_min' do
      before do
        beer_params[:temperatura_min] = nil
        post '/api/v1/cervejas', beer_params
      end

      it 'then status is unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "return response with message: Temperatura min can't be blank" do
        expect(data['details']).to include("Temperatura min can't be blank")
      end
    end
  end

  describe 'DELETE /v1/cervejas/:id' do
    let(:data) { JSON.parse(response.body) }

    context 'when id is valid' do
      let(:beer) { FactoryBot.create(:cerveja) }

      before do
        delete "/api/v1/cervejas/#{beer.id}", nil
      end

      it 'then status is ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'return response with right message and right object' do
        expect(data['message']).to eql("Tipo de cerveja deletado com sucesso!")
        expect(data['cerveja']['id']).to eql(beer.id)
      end

      it 'the record is removed from the database' do
        expect(Cerveja.find_by(id: beer.id)).to be_nil
      end
    end

    context 'when id is invalid' do
      before do
        delete '/api/v1/cervejas/0', nil
      end

      it 'then status is not found' do
        expect(response).to have_http_status(:not_found)
      end

      it "return response with message: Couldn't find Cerveja with 'id'=0" do
        expect(data['details']).to include("Couldn't find Cerveja with 'id'=0")
      end
    end
  end

  describe 'PUT/PATCH /v1/cervejas/:id' do
    let(:beer) { FactoryBot.create(:cerveja) }
    let(:body) { JSON.parse(response.body) }

    context 'when have right params' do
      let(:beer_params) { { estilo: Faker::Lorem.word } }

      before do
        put "/api/v1/cervejas/#{beer.id}", beer_params
      end

      it 'returns http status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns beer with estilo updated' do
        estilo = body['cerveja']['estilo']
        expect(estilo).to eql(beer_params[:estilo])
      end

      it 'alters beer in database' do
        db_beer_estilo = Cerveja.select(:estilo).find(beer.id).estilo
        expect(db_beer_estilo).not_to eql(beer.estilo)
        expect(db_beer_estilo).to eql(beer_params[:estilo])
      end
    end

    context 'when have fields filled wrong' do
      let(:beer_params) { { estilo: nil } }

      before do
        put "/api/v1/cervejas/#{beer.id}", beer_params
      end

      it 'returns http status unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns right error message' do
        error_message = body['details']
        expect(error_message).to include("Estilo can't be blank")
      end
    end

    context 'when id is invalid' do
      let(:beer_params) { { estilo: Faker::Lorem.word } }

      before do
        put '/api/v1/cervejas/0', beer_params
      end

      it 'then status is not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'return response with error message' do
        expect(body['details']).to include("Couldn't find Cerveja with 'id'=0")
      end
    end
  end

  describe 'GET /v1/cervejas/cerveja/:temperatura' do
    context 'when has a valid temperature' do
      let(:number_beers) { 5 }
      let(:temperature) { rand(-3.0..3.0) }
      let(:data) { JSON.parse(response.body)['cerveja'] }
      let(:cerveja) { body['cerveja'] }

      before do
        FactoryBot.create_list(:cerveja, number_beers)
        get "/api/v1/cervejas/cerveja/#{temperature}", nil
      end

      it 'return status ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when has an invalid temperature' do
      let(:number_beers) { 5 }

      before do
        FactoryBot.create_list(:cerveja, number_beers)
        get "/api/v1/cervejas/cerveja/invalid_temperature", nil
      end

      it 'return status not_found' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end