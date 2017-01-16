shared_examples_for 'votable controller with guest user' do |votable_factory|
  describe 'POST #vote_up' do
    let!(:votable) { create(votable_factory) }

    it 'return 401 Unauthorized' do
      post :vote_up, params: { id: votable.id }, xhr: true
      expect(response).to have_http_status(401)
    end
  end

  describe 'POST #vote_down' do
    let!(:votable) { create(votable_factory) }

    it 'return 401 Unauthorized' do
      post :vote_down, params: { id: votable.id }, xhr: true
      expect(response).to have_http_status(401)
    end
  end

  describe 'POST #reset_vote' do
    let!(:votable) { create(votable_factory) }

    it 'return 401 Unauthorized' do
      post :reset_vote, params: { id: votable.id }, xhr: true
      expect(response).to have_http_status(401)
    end
  end
end
