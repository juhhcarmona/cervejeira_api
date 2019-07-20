Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do

      resources :cervejas do
        collection do
          get 'cerveja/:temperatura', to: 'cervejas#cerveja'
        end
      end

    end
  end
end
