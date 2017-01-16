shared_examples_for 'vote action' do |action_name, user_vote_value, votable_factory|
  context 'votable by other user' do
    let!(:votable) { create(votable_factory) }

    it 'renders json' do
      post action_name, params: { id: votable.id }, xhr: true
      expect(response.header['Content-Type']).to include('application/json')
    end

    it 'returns updated voting info' do
      post action_name, params: { id: votable.id }, xhr: true
      response_data = JSON.parse(response.body, symbolize_names: true)
      expect(response_data[:rating]).to eq(user_vote_value)
      expect(response_data[:user_vote]).to eq(user_vote_value)
    end

    it 'updates rating in database' do
      expect do
        post action_name, params: { id: votable.id }, xhr: true
      end.to change(votable, :rating).by(user_vote_value)
    end
  end

  context 'votable by same user' do
    let!(:votable) { create(votable_factory, user: @user) }

    it 'return 403 Forbidden' do
      post action_name, params: { id: votable.id }, xhr: true
      expect(response).to have_http_status(403)
    end

    it 'does not update votable rating in database' do
      expect do
        post action_name, params: { id: votable.id }, xhr: true
      end.not_to change(votable, :rating)
    end
  end
end
