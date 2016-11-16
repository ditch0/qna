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

      it 'renders index view' do
        expect(response).to render_template(:show)
      end

      it 'assigns @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'assigns new answer model to @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
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
        post 'create', params: { question: attributes_for(:question) }
        expect(response).to redirect_to(new_user_session_url)
      end

      it 'does not create new question in database' do
        expect do
          post 'create', params: { question: attributes_for(:question) }
        end.not_to change(Question, :count)
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
            post 'create', params: { question: attributes_for(:question) }
          end.to change(Question, :count).by(1)
        end

        it 'redirects to questions list' do
          post 'create', params: { question: attributes_for(:question) }
          expect(response).to redirect_to(questions_url)
        end
      end

      context 'invalid question' do
        it 'does not create new question in database' do
          expect do
            post 'create', params: { question: attributes_for(:invalid_question) }
          end.not_to change(Question, :count)
        end

        it 'renders new view' do
          post 'create', params: { question: attributes_for(:invalid_question) }
          expect(response).to render_template(:new)
        end
      end
    end
  end
end
