RSpec.describe Strigil::RedditWebClient do
  describe '#get_comment_permalinks' do
    it "throws InvalidUserError if user doesn't exist" do
      target = 'invaliduser2083490134'

      expect do
        Strigil::RedditWebClient.get_comment_permalinks(target)
      end.to raise_error(Strigil::InvalidUserError)
    end

    it 'returns permalinks for all comments' do
      target = Strigil.configuration.reddit_username

      result = Strigil::RedditWebClient.get_comment_permalinks(target)

      expect(result.size).to eq(1)
    end
  end

  describe '#permalink_to_json' do
    context 'for a permalink' do
      it 'returns correct json' do
        permalink = attributes_for(:real_reddit_comment)[:permalink]

        result = Strigil::RedditWebClient.permalink_to_json(permalink)

        expect(
          Strigil::RedditComment.new(result)
        ).to be_valid
      end
    end
  end
end
