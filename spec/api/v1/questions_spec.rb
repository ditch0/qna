require 'rails_helper'

describe 'Questions API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'Questions list' do
    it_should_behave_like 'authorized resource', '/api/v1/questions.json'

    let!(:questions) { create_list(:question, 5) }

    before do
      get '/api/v1/questions.json', params: { access_token: access_token.token }
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns array of five questions' do
      expect(response.body).to have_json_type(Array).at_path('questions')
      expect(response.body).to have_json_size(5).at_path('questions')
    end

    %w(id title body rating).each do |attr|
      it "returns question #{attr}" do
        value = questions.first.send(attr.to_sym)
        expect(response.body).to be_json_eql(value.to_json).at_path("questions/0/#{attr}")
      end
    end
  end

  describe 'Single question' do
    it_should_behave_like 'authorized resource', '/api/v1/questions/1.json'

    let!(:question) { create(:question) }
    let!(:attachments) { create_list(:attachment, 3, attachmentable: question) }
    let!(:comments) { create_list(:comment, 4, commentable: question) }

    before do
      get "/api/v1/questions/#{question.id}.json", params: { access_token: access_token.token }
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end

    %w(id title body rating).each do |attr|
      it "returns question #{attr}" do
        value = question.send(attr.to_sym)
        expect(response.body).to be_json_eql(value.to_json).at_path("question/#{attr}")
      end
    end

    it 'returns array of three attachments' do
      expect(response.body).to have_json_type(Array).at_path('question/attachments')
      expect(response.body).to have_json_size(3).at_path('question/attachments')
    end

    it 'returns attachments as strings' do
      expect(response.body).to have_json_type(String).at_path('question/attachments/0')
    end

    it 'returns array of four comments' do
      expect(response.body).to have_json_type(Array).at_path('question/comments')
      expect(response.body).to have_json_size(4).at_path('question/comments')
    end

    %w(id body).each do |attr|
      it "returns comment #{attr}" do
        value = question.comments.first.send(attr.to_sym)
        expect(response.body).to be_json_eql(value.to_json).at_path("question/comments/0/#{attr}")
      end
    end
  end

  describe 'Create question' do
    it_should_behave_like 'authorized resource', '/api/v1/questions.json', :post

    context 'valid question' do
      let(:request_params) do
        { question: { title: 'Title', body: 'A question' }, access_token: access_token.token }
      end

      it 'returns status 201 Created' do
        post '/api/v1/questions.json', params: request_params
        expect(response).to have_http_status(201)
      end

      it 'creates question' do
        expect do
          post '/api/v1/questions.json', params: request_params
        end.to change(Question, :count).by(1)
      end
    end

    context 'invalid question' do
      let(:request_params) do
        { question: { title: '', body: 'A question' }, access_token: access_token.token }
      end

      it 'returns status 422 Unprocessable Entity' do
        post '/api/v1/questions.json', params: request_params
        expect(response).to have_http_status(422)
      end

      it 'does not create question' do
        expect do
          post '/api/v1/questions.json', params: request_params
        end.not_to change(Question, :count)
      end
    end
  end
end
