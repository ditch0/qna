require 'rails_helper'

describe UsersController do
  describe 'GET #show' do
    let!(:user) { create(:user) }
    before { get :show, params: { id: user.id } }

    it 'renders show view' do
      expect(response).to render_template(:show)
    end

    it 'assigns user' do
      expect(assigns(:user)).to eq(user)
    end
  end
end
