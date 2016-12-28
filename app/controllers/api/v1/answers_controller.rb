module Api
  module V1
    class AnswersController < Api::V1::ApiController
      before_action :set_question, only: [:index, :create]
      def index
        respond_with @question.answers.order(id: :asc)
      end

      def show
        respond_with Answer.find(params[:id]), serializer: DetailedAnswerSerializer
      end

      def create
        answer = current_resource_owner.answers.create(answer_params.merge(question_id: params[:question_id]))
        respond_with answer
      end

      private

      def set_question
        @question = Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
