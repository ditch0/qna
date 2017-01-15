require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  context 'guest user' do
    describe 'GET #new' do
      before { get :new, params: { question_id: question.id } }

      it 'redirects to login page' do
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'POST #create' do
      let(:answer_params) { { answer: attributes_for(:answer), question_id: question } }

      it 'redirects to login page' do
        post :create, params: answer_params
        expect(response).to redirect_to(new_user_session_url)
      end

      it 'does not create new answer in database' do
        expect do
          post :create, params: answer_params
        end.not_to change(Answer, :count)
      end
    end

    describe 'DELETE #destroy' do
      let!(:answer) { create(:answer) }

      it 'returns 401 Unauthorized' do
        delete :destroy, params: { id: answer.id, question_id: answer.question.id }, xhr: true
        expect(response).to have_http_status(401)
      end

      it 'does not delete answer in database' do
        expect do
          delete :destroy, params: { id: answer.id, question_id: answer.question.id }, xhr: true
        end.not_to change(Answer, :count)
      end
    end

    describe 'PATCH #update' do
      let!(:answer) { create(:answer, question: question) }
      let!(:request_params) do
        {
          id: answer.id,
          question_id: question.id,
          answer: attributes_for(:answer)
        }
      end

      it 'returns 401 Unauthorized' do
        patch :update, params: request_params, xhr: true
        expect(response).to have_http_status(401)
      end

      it 'does not update answer in database' do
        expect do
          patch :update, params: request_params, xhr: true
          answer.reload
        end.not_to change(answer, :body)
      end
    end

    describe 'POST #set_is_best' do
      let!(:answer) { create(:answer, question: question) }
      before do
        post :set_is_best, params: { question_id: question.id, id: answer.id, is_best: true }, xhr: true
      end

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(401)
      end

      it 'does not update answer in database' do
        answer.reload
        expect(answer.is_best).to be_falsey
      end
    end

    describe 'POST #vote_up' do
      let!(:answer) { create(:answer) }

      it 'return 401 Unauthorized' do
        post :vote_up, params: { id: answer.id }, xhr: true
        expect(response).to have_http_status(401)
      end
    end

    describe 'POST #vote_down' do
      let!(:answer) { create(:answer) }

      it 'return 401 Unauthorized' do
        post :vote_down, params: { id: answer.id }, xhr: true
        expect(response).to have_http_status(401)
      end
    end

    describe 'POST #reset_vote' do
      let!(:answer) { create(:answer) }

      it 'return 401 Unauthorized' do
        post :reset_vote, params: { id: answer.id }, xhr: true
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'authenticated user' do
    sign_in_user

    describe 'GET #new' do
      before { get :new, params: { question_id: question.id } }

      it 'renders new view' do
        expect(response).to render_template(:new)
      end

      it 'assigns new answer model @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end
    end

    describe 'POST #create' do
      context 'valid answer' do
        let(:answer_params) { { answer: attributes_for(:answer), question_id: question } }

        it 'creates answer in database' do
          expect do
            post :create, params: answer_params, xhr: true
          end.to change(question.answers, :count).by(1)
        end

        it 'creates nested attachment' do
          post :create, xhr: true, params: {
            answer: {
              body:  'Answer text',
              attachments_attributes: {
                '0': { file: fixture_file_upload('uploads/a_file.txt', 'text/plain') }
              }
            },
            question_id: question
          }
          expect(Answer.last.attachments.count).to eq(1)
        end

        it 'creates answer owned by current user' do
          post :create, params: answer_params, xhr: true
          expect(Answer.last.user_id).to eq(@user.id)
        end

        it 'renders create template' do
          post :create, params: answer_params, xhr: true
          expect(response).to render_template(:create)
        end
      end

      context 'invalid answer' do
        let(:answer_params) { { answer: attributes_for(:invalid_answer), question_id: question } }

        it 'does not create answer in database' do
          expect do
            post :create, params: answer_params, xhr: true
          end.not_to change(Answer, :count)
        end

        it 'renders create view' do
          post :create, params: answer_params, xhr: true
          expect(response).to render_template(:create)
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'own answer' do
        let!(:answer) { create(:answer, user: @user) }

        it 'renders destroy view' do
          delete :destroy, params: { id: answer.id, question_id: answer.question.id }, xhr: true
          expect(response).to render_template(:destroy)
        end

        it 'deletes answer in database' do
          expect do
            delete :destroy, params: { id: answer.id, question_id: answer.question.id }, xhr: true
          end.to change(Answer, :count).by(-1)
        end
      end

      context 'other user\'s answer' do
        let!(:answer) { create(:answer) }

        it 'returns 403 Forbidden' do
          delete :destroy, params: { id: answer.id, question_id: answer.question.id }, xhr: true
          expect(response).to have_http_status(403)
        end

        it 'does not delete answer in database' do
          expect do
            delete :destroy, params: { id: answer.id, question_id: answer.question.id }, xhr: true
          end.not_to change(Answer, :count)
        end
      end
    end

    describe 'PATCH #update' do
      context 'own answer with valid attributes' do
        let!(:answer) { create(:answer, user: @user) }
        let!(:request_params) do
          {
            id: answer.id,
            question_id: answer.question_id,
            answer: { body: 'Updated answer text' }
          }
        end

        before do
          patch :update, params: request_params, xhr: true
        end

        it 'renders update view' do
          expect(response).to render_template(:update)
        end

        it 'assigns updated answer' do
          expect(assigns(:answer)).to have_attributes(body: 'Updated answer text')
        end

        it 'updates answer in database' do
          answer.reload
          expect(answer).to have_attributes(body: 'Updated answer text')
        end
      end

      context 'own answer with invalid attributes' do
        let!(:answer) { create(:answer, user: @user) }
        let!(:request_params) do
          {
            id: answer.id,
            question_id: answer.question_id,
            answer: { body: '' }
          }
        end

        it 'renders update view' do
          patch :update, params: request_params, xhr: true
          expect(response).to render_template(:update)
        end

        it 'assigns answer with errors' do
          patch :update, params: request_params, xhr: true
          expect(assigns(:answer).errors.present?).to be_truthy
        end

        it 'does not update answer in database', skip_before: true do
          expect do
            patch :update, params: request_params, xhr: true
            answer.reload
          end.not_to change(answer, :body)
        end
      end

      context 'other user\'s answer with valid attributes' do
        let!(:answer) { create(:answer) }
        let!(:request_params) do
          {
            id: answer.id,
            question_id: answer.question_id,
            answer: attributes_for(:answer)
          }
        end

        it 'returns 403 Forbidden' do
          patch :update, params: request_params, xhr: true
          expect(response).to have_http_status(403)
        end

        it 'does not update answer in database' do
          expect do
            patch :update, params: request_params, xhr: true
            answer.reload
          end.not_to change(answer, :body)
        end
      end
    end

    describe 'POST #set_is_best' do
      context 'own question' do
        let!(:own_question) { create(:question, user: @user) }
        let!(:answer) { create(:answer, question: own_question) }

        before do
          post :set_is_best, params: { question_id: own_question.id, id: answer.id, is_best: true }, xhr: true
        end

        it 'renders set_is_best view' do
          expect(response).to render_template(:set_is_best)
        end

        it 'assigns @answers' do
          expect(assigns(:answers)).not_to be_nil
        end

        it 'updates answer in database' do
          answer.reload
          expect(answer.is_best).to be_truthy
        end
      end

      context 'other user\'s question' do
        let!(:answer) { create(:answer, question: question) }

        before do
          post :set_is_best, params: { question_id: question.id, id: answer.id, is_best: true }, xhr: true
        end

        it 'returns 403 Forbidden' do
          expect(response).to have_http_status(403)
        end

        it 'does not update answer in database' do
          answer.reload
          expect(answer.is_best).to be_falsey
        end
      end
    end

    describe 'POST #vote_up' do
      it_behaves_like 'vote action', 'vote_up', 1, :answer
    end

    describe 'POST #vote_down' do
      it_behaves_like 'vote action', 'vote_down', -1, :answer
    end

    describe 'POST #reset_vote' do
      context 'answer by other user' do
        let!(:answer) { create(:answer) }
        before { answer.vote_up(@user) }

        it 'renders json' do
          post :reset_vote, params: { id: answer.id }, xhr: true
          expect(response.header['Content-Type']).to include('application/json')
        end

        it 'returns updated voting info' do
          post :reset_vote, params: { id: answer.id }, xhr: true
          response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response_data[:rating]).to eq(0)
          expect(response_data[:user_vote]).to be_nil
        end

        it 'updates rating in database' do
          expect do
            post :reset_vote, params: { id: answer.id }, xhr: true
          end.to change(answer, :rating).by(-1)
        end
      end

      context 'answer by same user' do
        let!(:answer) { create(:answer, user: @user) }

        it 'return 403 Forbidden' do
          post :reset_vote, params: { id: answer.id }, xhr: true
          expect(response).to have_http_status(403)
        end

        it 'does not update answer rating in database' do
          expect do
            post :reset_vote, params: { id: answer.id }, xhr: true
          end.not_to change(answer, :rating)
        end
      end
    end
  end
end
