require 'rails_helper'

describe SearchService do
  describe '.call' do
    let(:stubbed_results) { ['result 1', 'result 2'] }

    it 'returns array' do
      results = SearchService.call('Anything')
      expect(results).to be_a_kind_of(Array)
    end

    it 'passes search request to ThinkingSphinx with all available classes when class is not specified' do
      expect(ThinkingSphinx).to receive(:search)
        .with('Anything', classes: SearchService::SEARCH_CLASSES)
        .and_return(stubbed_results)
      results = SearchService.call('Anything')
      expect(results).to eq(stubbed_results)
    end

    SearchService::SEARCH_CLASSES.each do |klass|
      it "passes class #{klass} to ThinkingSphinx search when it is specified" do
        expect(ThinkingSphinx).to receive(:search).with('Anything', classes: [klass]).and_return(stubbed_results)
        results = SearchService.call('Anything', klass.to_s)
        expect(results).to eq(stubbed_results)
      end
    end

    it 'passes search request to ThinkingSphinx with all available classes when class is not available for search' do
      expect(ThinkingSphinx).to receive(:search)
        .with('Anything', classes: SearchService::SEARCH_CLASSES)
        .and_return(stubbed_results)
      results = SearchService.call('Anything', 'Vote')
      expect(results).to eq(stubbed_results)
    end

    ['', ' '].map do |query|
      it %(assigns empty results when "#{query}" is passed as query) do
        results = SearchService.call(query)
        expect(results).to eq([])
      end

      it %(does not call ThinkingSpinx to search when "#{query}" is passed as query) do
        expect(ThinkingSphinx).not_to receive(:search)
        SearchService.call(query)
      end
    end
  end
end
