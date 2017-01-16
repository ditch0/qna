require 'rails_helper'

describe CommentsController do
  shared_examples_for 'POST #create' do |commentable_type|
    let(:commentable) { create(commentable_type) }
    let(:valid_comment_params) do
      {
        comment: { body: 'A comment' },
        "#{commentable_type}_id": commentable.id
      }
    end
    let(:invalid_comment_params) do
      {
        comment: { body: '' },
        "#{commentable_type}_id": commentable.id
      }
    end

    context 'guest user' do
      describe 'POST #create' do
        it 'returns 401 Unauthorized' do
          post :create, params: valid_comment_params, xhr: true
          expect(response).to have_http_status(401)
        end

        it 'does not create comment' do
          expect do
            post :create, params: valid_comment_params, xhr: true
          end.not_to change(Comment, :count)
        end
      end
    end

    context 'authenticated user' do
      sign_in_user

      describe 'POST #create' do
        context 'valid comment' do
          it 'renders create template' do
            post :create, params: valid_comment_params, xhr: true
            expect(response).to render_template(:create)
          end

          it 'assigns @comment' do
            post :create, params: valid_comment_params, xhr: true
            expect(assigns(:comment)).to be_a(Comment)
          end

          it 'saves a comment' do
            expect do
              post :create, params: valid_comment_params, xhr: true
            end.to change(Comment, :count).by(1)
          end

          it 'publishes comment to ActionCable' do
            question_id = commentable.is_a?(Question) ? commentable.id : commentable.question_id
            expect(ActionCable.server).to receive(:broadcast).with("comments_#{question_id}", anything)
            post :create, params: valid_comment_params, xhr: true
          end
        end

        context 'invalid comment' do
          it 'renders create template' do
            post :create, params: invalid_comment_params, xhr: true
            expect(response).to render_template(:create)
          end

          it 'assigns @comment' do
            post :create, params: invalid_comment_params, xhr: true
            expect(assigns(:comment)).to be_a(Comment)
          end

          it 'does not save a comment' do
            expect do
              post :create, params: invalid_comment_params, xhr: true
            end.not_to change(Comment, :count)
          end

          it 'does not publishe comment to ActionCable' do
            expect(ActionCable.server).not_to receive(:broadcast)
            post :create, params: invalid_comment_params, xhr: true
          end
        end
      end
    end
  end

  context 'commenting question' do
    it_behaves_like 'POST #create', :question
  end

  context 'commenting question' do
    it_behaves_like 'POST #create', :answer
  end
end
