require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  context 'quest user' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }

    it { should_not be_able_to :create, Question }
    it { should_not be_able_to :create, Answer }
    it { should_not be_able_to :create, Comment }

    [:answer, :question].each do |model_type|
      [:update, :destroy, :vote_up, :vote_down, :reset_vote]. each do |action|
        it { should_not be_able_to action, create(model_type) }
      end
    end

    it { should_not be_able_to :set_is_best, create(:answer) }
  end

  context 'authenticated user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    it { should_not be_able_to :manage, :all }

    context 'questions' do
      let(:question) { create(:question, user: user) }
      let(:other_users_question) { create(:question) }

      it { should be_able_to :create, Question }
      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, other_users_question, user: user }
      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, other_users_question, user: user }

      it { should be_able_to :vote_up, other_users_question, user: user }
      it { should_not be_able_to :vote_up, question, user: user }
      it { should be_able_to :vote_down, other_users_question, user: user }
      it { should_not be_able_to :vote_down, question, user: user }
      it { should be_able_to :reset_vote, other_users_question, user: user }
      it { should_not be_able_to :reset_vote, question, user: user }
    end

    context 'answers' do
      let(:answer) { create(:answer, user: user) }
      let(:other_users_answer) { create(:answer) }
      let(:question) { create(:question, user: user) }
      let(:other_users_question) { create(:question) }

      it { should be_able_to :create, Answer }
      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, other_users_answer, user: user }
      it { should be_able_to :destroy, answer, user: user }
      it { should_not be_able_to :destroy, other_users_answer, user: user }

      it { should be_able_to :vote_up, other_users_answer, user: user }
      it { should_not be_able_to :vote_up, answer, user: user }
      it { should be_able_to :vote_down, other_users_answer, user: user }
      it { should_not be_able_to :vote_down, answer, user: user }
      it { should be_able_to :reset_vote, other_users_answer, user: user }
      it { should_not be_able_to :reset_vote, answer, user: user }

      it { should be_able_to :set_is_best, create(:answer, question: question), user: user }
      it { should_not be_able_to :set_is_best, create(:answer, question: other_users_question), user: user }
    end

    context 'answers' do
      it { should be_able_to :create, Comment }
    end
  end
end
