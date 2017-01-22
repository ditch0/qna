require 'rails_helper'

describe SearchController do
  describe 'GET #index' do
    context 'with non-empty query' do
      it 'renders index view' do
        get :index, params: { query: 'Anything' }
        expect(response).to render_template(:index)
      end

      it 'assigns @results array' do
        get :index, params: { query: 'Anything' }
        expect(assigns(:results)).to be_a_kind_of(Array)
      end

      it 'passes search request to SearchService' do
        expect(SearchService).to receive(:call).with('Anything', 'Question')
        get :index, params: { query: 'Anything', class: 'Question' }
      end
    end
  end
end
