require 'spec_helper'

describe RummagerNotifier do
  describe '#call(changed_best_bet)' do
    before do
      @exact_job_bets = [
        FactoryGirl.create(:best_bet, query: 'jobs', match_type: 'exact', link: '/jobs/more-jobs', position: 2),
        FactoryGirl.create(:best_bet, query: 'jobs', match_type: 'exact', link: '/jobsearch', position: 1),
        FactoryGirl.create(:best_bet, query: 'jobs', match_type: 'exact', link: '/topics/employment', position: nil),
        FactoryGirl.create(:best_bet, query: 'jobs', match_type: 'exact', link: '/people/steve-jobs', position: nil)
      ]

      FactoryGirl.create(:best_bet, query: 'jobs', match_type: 'stemmed', link: 'http://example.com/jobs', position: 3)
      FactoryGirl.create(:best_bet, query: 'visas', match_type: 'exact', link: '/something/something/visas', position: 1)
    end

    it "sends an elasticsearch doc from all related best bets" do
      es_doc_body = double(:es_doc_body)
      es_doc = double(:es_doc, body: es_doc_body)
      expect(ElasticSearchBestBet).to receive(:from_matching_bets)
        .with(@exact_job_bets, include_id_and_type_in_body: true)
        .and_return(es_doc)

      RummagerNotifier.call(query: 'jobs', match_type: 'exact', link: '/jobsearch', position: 1)

      expect(SearchAdmin.services(:rummager_index)).to have_received(:add).with(es_doc_body)
    end

    it "removes the best bet from elasticsearch if all matching bets have been deleted" do
      es_doc_id = double(:es_doc_id)
      expect(ElasticSearchBestBet).to receive(:new)
        .with('jobs', 'exact', nil)
        .and_return(double(:es_doc, id: es_doc_id))

      BestBet.destroy_all

      RummagerNotifier.call(query: 'jobs', match_type: 'exact', link: '/jobsearch', position: 1)

      expect(SearchAdmin.services(:rummager_index)).to have_received(:delete).with(es_doc_id, type: 'best_bet')
    end
  end
end
