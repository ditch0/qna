require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    before { get :index }

    it 'renders index view' do
      expect(response).to render_template(:index)
    end

    it 'assigns list of all questions to @questions' do
      expect(assigns(:questions)).to match_array(Question.all)
    end
  end

  describe 'GET #new' do
    before  { get :new }

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
      it 'does not new question in database' do
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
