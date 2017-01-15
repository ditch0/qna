shared_examples_for 'votable controller' do |votable_factory|
  describe 'POST #vote_up' do
    it_behaves_like 'vote action', 'vote_up', 1, votable_factory
  end

  describe 'POST #vote_down' do
    it_behaves_like 'vote action', 'vote_down', -1, votable_factory
  end

  describe 'POST #reset_vote' do
    context 'votable by other user' do
      let!(:votable) { create(votable_factory) }
      before { votable.vote_up(@user) }

      it 'renders json' do
        post :reset_vote, params: { id: votable.id }, xhr: true
        expect(response.header['Content-Type']).to include('application/json')
      end

      it 'returns updated voting info' do
        post :reset_vote, params: { id: votable.id }, xhr: true
        response_data = JSON.parse(response.body, symbolize_names: true)
        expect(response_data[:rating]).to eq(0)
        expect(response_data[:user_vote]).to be_nil
      end

      it 'updates rating in database' do
        expect do
          post :reset_vote, params: { id: votable.id }, xhr: true
        end.to change(votable, :rating).by(-1)
      end
    end

    context 'votable by same user' do
      let!(:votable) { create(votable_factory, user: @user) }

      it 'return 403 Forbidden' do
        post :reset_vote, params: { id: votable.id }, xhr: true
        expect(response).to have_http_status(403)
      end

      it 'does not update votable rating in database' do
        expect do
          post :reset_vote, params: { id: votable.id }, xhr: true
        end.not_to change(votable, :rating)
      end
    end
  end
end
