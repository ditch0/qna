module Api
  module V1
    class QuestionsController < Api::V1::ApiController
      before_action :set_question, only: :show

      def index
        authorize Question
        respond_with Question.all
      end

      def show
        respond_with @question, serializer: DetailedQuestionSerializer
      end

      def create
        authorize Question
        respond_with current_resource_owner.questions.create(question_params)
      end

      private

      def question_params
        params.require(:question).permit(:title, :body)
      end

      def set_question
        @question = Question.find(params[:id])
        authorize @question
      end
    end
  end
end
