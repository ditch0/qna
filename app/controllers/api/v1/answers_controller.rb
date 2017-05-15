module Api
  module V1
    class AnswersController < Api::V1::ApiController
      before_action :set_answer, only: :show

      def index
        authorize Answer
        respond_with Answer.where(question_id: params[:question_id]).order(:created_at)
      end

      def show
        respond_with @answer, serializer: DetailedAnswerSerializer
      end

      def create
        authorize Answer
        answer = current_resource_owner.answers.create(answer_params.merge(question_id: params[:question_id]))
        respond_with answer
      end

      private

      def answer_params
        params.require(:answer).permit(:body)
      end

      def set_answer
        @answer = Answer.find(params[:id])
        authorize @answer
      end
    end
  end
end
