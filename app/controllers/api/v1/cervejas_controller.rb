module Api
  module V1
    class CervejasController < ApplicationController

      def index
        cervejas = Cerveja.order(estilo: "asc");
        render json: { cervejas: cervejas }, status: :ok
      end

      def show
        cerveja = Cerveja.find(params[:id])
        render json: { cerveja: cerveja }, status: :ok
      end

      def create
        cerveja = Cerveja.new(cerveja_params)
        cerveja.save!
        render json: { cerveja: cerveja }, status: :created
      end

      def destroy
        cerveja = Cerveja.find(params[:id])
        cerveja.destroy
        render json: { message:'Tipo de cerveja deletado com sucesso!',
                       cerveja: cerveja}, status: :ok
      end

      def update
        cerveja = Cerveja.find(params[:id])
        cerveja.update!(cerveja_params)
        render json: { cerveja: cerveja }, status: :ok
      end

      def cerveja
        raise ActionController::BadRequest if params[:temperatura].match(/^[\-|0-9]*$/).nil?

        cerveja = Cerveja.cerveja_por_temperatura(params[:temperatura].to_i)

        raise ActiveRecord::RecordNotFound unless cerveja
        render json: { cerveja: cerveja }, status: :ok
      end

      private

      def cerveja_params
        params.permit(:estilo, :temperatura_max, :temperatura_min, :created_at, :updated_at)
      end

    end
  end
end