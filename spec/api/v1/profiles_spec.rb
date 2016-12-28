require 'rails_helper'

describe 'Profiles API' do
  describe 'Own profile' do
    it_should_behave_like 'authorized resource', '/api/v1/profiles/me.json'

    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    before do
      get '/api/v1/profiles/me.json', params: { access_token: access_token.token }
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end

    %w(id email created_at updated_at).each do |attr|
      it "returns user #{attr}" do
        value = user.send(attr.to_sym)
        expect(response.body).to be_json_eql(value.to_json).at_path(attr)
      end
    end

    %w(password encrypted_password).each do |attr|
      it "does not contain user #{attr}" do
        expect(response.body).to_not have_json_path(attr)
      end
    end
  end

  describe 'Other users profiles' do
    it_should_behave_like 'authorized resource', '/api/v1/profiles.json'

    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:other_users) { create_list(:user, 5) }

    before do
      get '/api/v1/profiles.json', params: { access_token: access_token.token }
    end

    it 'returns array of five objects' do
      expect(body).to have_json_type(Array)
      expect(body).to have_json_size(5)
    end

    it 'does not return current user profile' do
      expect(body).not_to include_json(user.to_json)
    end
  end
end
