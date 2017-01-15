require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  shared_examples 'public access to question' do
    describe 'GET #index' do
      before { get :index }

      it 'renders index view' do
        expect(response).to render_template(:index)
      end

      it 'assigns list of all questions to @questions' do
        expect(assigns(:questions)).to match_array(Question.all)
      end
    end

    describe 'GET #show' do
      let(:question) { create(:question) }
      before { get :show, params: { id: question.id } }

      it 'renders show view' do
        expect(response).to render_template(:show)
      end

      it 'assigns @question' do
        expect(assigns(:question)).to eq(question)
      end
    end
  end

  context 'guest user' do
    it_behaves_like 'public access to question'

    describe 'GET #new' do
      before { get :new }

      it 'redirects to login page' do
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'POST #create' do
      it 'redirects to login page' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to(new_user_session_url)
      end

      it 'does not create new question in database' do
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.not_to change(Question, :count)
      end
    end

    describe 'DELETE #destroy' do
      let!(:question) { create(:question) }

      it 'redirects to login page' do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to(new_user_session_url)
      end

      it 'does not create new question in database' do
        expect do
          delete :destroy, params: { id: question.id }
        end.not_to change(Question, :count)
      end
    end

    describe 'PATCH #update' do
      let!(:question) { create(:question) }

      it 'return 401 Unauthorized' do
        patch :update, params: { id: question.id, question: attributes_for(:question) }, xhr: true
        expect(response).to have_http_status(401)
      end

      it 'does not update question title in database' do
        expect do
          patch :update, params: { id: question.id, question: attributes_for(:question) }, xhr: true
          question.reload
        end.not_to change(question, :title)
      end

      it 'does not update question body in database' do
        expect do
          patch :update, params: { id: question.id, question: attributes_for(:question) }, xhr: true
          question.reload
        end.not_to change(question, :body)
      end
    end

    describe 'POST #vote_up' do
      let!(:question) { create(:question) }

      it 'return 401 Unauthorized' do
        post :vote_up, params: { id: question.id }, xhr: true
        expect(response).to have_http_status(401)
      end
    end

    describe 'POST #vote_down' do
      let!(:question) { create(:question) }

      it 'return 401 Unauthorized' do
        post :vote_down, params: { id: question.id }, xhr: true
        expect(response).to have_http_status(401)
      end
    end

    describe 'POST #reset_vote' do
      let!(:question) { create(:question) }

      it 'return 401 Unauthorized' do
        post :reset_vote, params: { id: question.id }, xhr: true
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'authenticated user' do
    sign_in_user
    it_behaves_like 'public access to question'

    describe 'GET #new' do
      before { get :new }

      it 'renders new view' do
        expect(response).to render_template(:new)
      end

      it 'assigns new question model @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end
    end

    describe 'POST #create' do
      context 'valid question' do
        it 'creates new question in database' do
          expect do
            post :create, params: { question: attributes_for(:question) }
          end.to change(Question, :count).by(1)
        end

        it 'creates nested attachment' do
          post :create, params: {
            question: {
              title: 'Question title',
              body:  'Question text',
              attachments_attributes: {
                '0': { file: fixture_file_upload('uploads/a_file.txt', 'text/plain') }
              }
            }
          }
          expect(Question.last.attachments.count).to eq(1)
        end

        it 'creates question owned by current user' do
          post :create, params: { question: attributes_for(:question) }
          expect(Question.last.user_id).to eq(@user.id)
        end

        it 'redirects to questions list' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to(questions_url)
        end

        it 'publishes question to ActionCable' do
          allow(ApplicationController).to receive(:render) { 'rendered question' }
          expect(ActionCable.server).to receive(:broadcast).with('questions', 'rendered question');
          post :create, params: { question: attributes_for(:question) }
        end
      end

      context 'invalid question' do
        it 'does not create new question in database' do
          expect do
            post :create, params: { question: attributes_for(:invalid_question) }
          end.not_to change(Question, :count)
        end

        it 'renders new view' do
          post :create, params: { question: attributes_for(:invalid_question) }
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'own question' do
        let!(:question) { create(:question, user: @user) }

        it 'redirects to question list' do
          delete :destroy, params: { id: question.id }
          expect(response).to redirect_to(questions_url)
          expect(flash[:notice]).to eq('Question is deleted.')
        end

        it 'deletes question in database' do
          expect do
            delete :destroy, params: { id: question.id }
          end.to change(Question, :count).by(-1)
        end
      end

      context 'other user\' question' do
        let!(:question) { create(:question) }

        it 'redirects to home page' do
          delete :destroy, params: { id: question.id }
          expect(response).to redirect_to(root_url)
          expect(flash[:alert]).to eq('Not allowed.')
        end

        it 'does not delete question in database' do
          expect do
            delete :destroy, params: { id: question.id }
          end.not_to change(Question, :count)
        end
      end
    end

    describe 'PATCH #update' do
      context 'own question with valid attributes' do
        let!(:question) { create(:question, user: @user) }
        let!(:update_attributes) { attributes_for(:question) }

        before do
          patch :update, params: { id: question.id, question: update_attributes }, xhr: true
        end

        it 'renders update view' do
          expect(response).to render_template(:update)
        end

        it 'assigns updated question' do
          expect(assigns(:question)).to have_attributes(update_attributes.slice(:title, :body))
        end

        it 'updates question in database' do
          question.reload
          expect(question).to have_attributes(update_attributes.slice(:title, :body))
        end
      end

      context 'own question with invalid attributes' do
        let!(:question) { create(:question, user: @user) }
        let!(:update_attributes) { attributes_for(:question, title: '') }

        it 'renders update view' do
          patch :update, params: { id: question.id, question: update_attributes }, xhr: true
          expect(response).to render_template(:update)
        end

        it 'assigns question with errors' do
          patch :update, params: { id: question.id, question: update_attributes }, xhr: true
          expect(assigns(:question).errors.present?).to be_truthy
        end

        it 'does not update question title in database' do
          expect do
            patch :update, params: { id: question.id, question: update_attributes }, xhr: true
            question.reload
          end.not_to change(question, :title)
        end

        it 'does not update question body in database' do
          expect do
            patch :update, params: { id: question.id, question: update_attributes }, xhr: true
            question.reload
          end.not_to change(question, :body)
        end
      end

      context 'other user\' question with valid attributes' do
        let!(:question) { create(:question) }

        it 'return 403 Forbidden' do
          patch :update, params: { id: question.id, question: attributes_for(:question) }, xhr: true
          expect(response).to have_http_status(403)
        end

        it 'does not update question title in database' do
          expect do
            patch :update, params: { id: question.id, question: attributes_for(:question) }, xhr: true
            question.reload
          end.not_to change(question, :title)
        end

        it 'does not update question body in database' do
          expect do
            patch :update, params: { id: question.id, question: attributes_for(:question) }, xhr: true
            question.reload
          end.not_to change(question, :body)
        end
      end
    end

    it_behaves_like 'votable controller', :question
  end
end
