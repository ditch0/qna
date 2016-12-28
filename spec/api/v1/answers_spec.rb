require 'rails_helper'

describe 'Answers API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'Answers list' do
    it_should_behave_like 'authorized resource', '/api/v1/questions/1/answers.json'

    let!(:question) { create(:question_with_answers, answers_count: 5) }

    before do
      get "/api/v1/questions/#{question.id}/answers.json", params: { access_token: access_token.token }
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns array of five answers' do
      expect(response.body).to have_json_type(Array).at_path('answers')
      expect(response.body).to have_json_size(5).at_path('answers')
    end

    %w(id body is_best rating).each do |attr|
      it "returns answer #{attr}" do
        value = question.answers.first.send(attr.to_sym)
        expect(response.body).to be_json_eql(value.to_json).at_path("answers/0/#{attr}")
      end
    end
  end

  describe 'Single answer' do
    it_should_behave_like 'authorized resource', '/api/v1/answers/1.json'

    let!(:answer) { create(:answer) }
    let!(:attachments) { create_list(:attachment, 3, attachmentable: answer) }
    let!(:comments) { create_list(:comment, 4, commentable: answer) }

    before do
      get "/api/v1/answers/#{answer.id}.json", params: {access_token: access_token.token }
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end

    %w(id body is_best rating).each do |attr|
      it "returns answer #{attr}" do
        value = answer.send(attr.to_sym)
        expect(response.body).to be_json_eql(value.to_json).at_path("answer/#{attr}")
      end
    end

    it 'returns array of three attachments' do
      expect(response.body).to have_json_type(Array).at_path('answer/attachments')
      expect(response.body).to have_json_size(3).at_path('answer/attachments')
    end

    it 'returns attachments as strings' do
      expect(response.body).to have_json_type(String).at_path('answer/attachments/0')
    end

    it 'returns array of four comments' do
      expect(response.body).to have_json_type(Array).at_path('answer/comments')
      expect(response.body).to have_json_size(4).at_path('answer/comments')
    end

    %w(id body).each do |attr|
      it "returns comment #{attr}" do
        value = answer.comments.first.send(attr.to_sym)
        expect(response.body).to be_json_eql(value.to_json).at_path("answer/comments/0/#{attr}")
      end
    end
  end

  describe 'Create answer' do
    it_should_behave_like 'authorized resource', '/api/v1/questions/1/answers.json', :post

    let!(:question) { create(:question) }
    let(:url) { "/api/v1/questions/#{question.id}/answers.json" }

    context 'valid answer' do
      let(:request_params) do
        { answer: { body: 'An answer' }, access_token: access_token.token }
      end

      it 'returns status 201 Created' do
        post url, params: request_params
        expect(response).to have_http_status(201)
      end

      it 'creates answer' do
        expect do
          post url, params: request_params
        end.to change(Answer, :count).by(1)
      end
    end

    context 'invalid answer' do
      let(:request_params) do
        { answer: { body: '' }, access_token: access_token.token }
      end

      it 'returns status 422 Unprocessable Entity' do
        post url, params: request_params
        expect(response).to have_http_status(422)
      end

      it 'does not create answer' do
        expect do
          post url, params: request_params
        end.not_to change(Answer, :count)
      end
    end
  end
end
