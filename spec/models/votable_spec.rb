require 'rails_helper'

describe Votable do
  with_model :SomethingVotable do
    table do |t|
      t.timestamps null: false
    end

    model do
      include Votable

      def user_can_vote?(_user)
        true
      end
    end
  end

  describe 'relations' do
    subject { SomethingVotable.new }
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'behaviour' do
    let(:user) { create(:user) }
    let(:votable) { SomethingVotable.create }

    shared_examples_for 'a vote method' do |vote_method_name, vote_value|
      describe vote_method_name do
        before { votable.send(vote_method_name, user) }

        it "changes rating by #{vote_value}" do
          expect(votable.rating).to eq(vote_value)
        end

        it "does not change rating by #{vote_value} when called second time by the same user" do
          votable.send(vote_method_name, user)
          expect(votable.rating).to eq(vote_value)
        end

        it "changes rating by #{vote_value} when called second time by the same user" do
          votable.send(vote_method_name, create(:user))
          expect(votable.rating).to eq(vote_value * 2)
        end
      end
    end

    it_should_behave_like 'a vote method', 'vote_up', 1
    it_should_behave_like 'a vote method', 'vote_down', -1

    describe 'reset_vote' do
      before do
        votable.vote_up(user)
        votable.vote_up(create(:user))
      end

      it 'sets resets user vote' do
        expect { votable.reset_vote(user) }.to change(votable, :rating).by(-1)
      end

      it 'sets resets user vote' do
        expect { votable.reset_vote(user) }.to change(Vote, :count).by(-1)
      end
    end

    describe 'find_vote_by_user' do
      before { votable.vote_up(user) }

      it 'returns Vote instance' do
        expect(votable.find_vote_by_user(user)).to be_a(Vote)
      end

      it 'returns Vote instance with right attributes' do
        vote = votable.find_vote_by_user(user)
        expect(vote.user_id).to eq(user.id)
        expect(vote.votable_id).to eq(votable.id)
        expect(vote.value).to eq(1)
      end

      it 'returns nil for the user, who did not vote' do
        vote = votable.find_vote_by_user(create(:user))
        expect(vote).to be_nil
      end
    end

    describe 'change vote' do
      it 'updates vote value for user' do
        votable.vote_up(user)
        votable.vote_down(user)
        expect(votable.rating).to eq(-1)
      end
    end

    describe 'voting restriction for user' do
      before do
        allow(votable).to receive(:user_can_vote?).and_return(false)
      end

      it 'raises exception if user is forbidden to vote' do
        expect { votable.vote_up(user) }.to raise_exception(/forbidden to vote/)
      end
    end
  end
end
