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

      it 'passes search request to ThinkingSphinx with all available classes' do
        expect(ThinkingSphinx).to receive(:search).with('Anything', classes: [Question, Answer, Comment, User])
        get :index, params: { query: 'Anything' }
      end

      %w(Question Answer Comment User).each do |klass|
        it "passes class #{klass} to ThinkingSphinx search when it is selected" do
          expect(ThinkingSphinx).to receive(:search).with('Anything', classes: [klass.constantize])
          get :index, params: { query: 'Anything', class: klass }
        end
      end
    end

    context 'with blank query' do
      ['', ' '].map do |query|
        it %(assigns empty results when "#{query}" is passed as query) do
          get :index, params: { query: query }
          expect(assigns(:results)).to eq([])
        end

        it %(does not call ThinkingSpinx to search when "#{query}" is passed as query) do
          expect(ThinkingSphinx).not_to receive(:search)
          get :index, params: { query: query }
        end
      end
    end
  end
end
