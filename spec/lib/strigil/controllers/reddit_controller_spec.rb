RSpec.describe Strigil::RedditController do
  describe 'initialize' do
    it 'sets a target' do
      target = Strigil.configuration.reddit_username

      controller = Strigil::RedditController.new(target)

      expect(controller.target).to eq(target)
    end
  end

  describe '#pool' do
    it 'returns a hashset of pooled permalinks' do
      result = Strigil::RedditController.pool

      expect(result).to be_instance_of(Set)
    end
  end

  describe '.archive' do
    before(:each) do
      target = Strigil.configuration.reddit_username
      @controller = Strigil::RedditController.new(target)
    end

    context 'one link' do
      before(:each) do
        @permalink = attributes_for(:reddit_comment)[:permalink]
      end

      context 'input exists in model but not pool' do
        it 'does not queue' do
          create :reddit_comment

          @controller.archive(@permalink)

          expect(Strigil::RedditController.pool.size).to eq(0)
          expect(Strigil::RedditWorker.jobs.size).to eq(0)
        end
      end

      context 'input exists in pool but not model' do
        it 'does not queue' do
          Strigil::RedditController.pool.add(@permalink)

          @controller.archive(@permalink)

          expect(Strigil::RedditController.pool.size).to eq(1)
          expect(Strigil::RedditWorker.jobs.size).to eq(0)
        end
      end

      context 'input does not exist in model or pool' do
        it 'queues' do
          @controller.archive(@permalink)

          expect(Strigil::RedditController.pool.size).to eq(1)
          expect(Strigil::RedditWorker.jobs.size).to eq(1)
        end
      end
    end

    context 'multiple links' do
      before(:each) do
        @permas = []
        @permas.push(attributes_for(:reddit_comment)[:permalink])
        @permas.push(attributes_for(:reddit_comment2)[:permalink])
      end

      context 'input does not exist in model or pool' do
        it 'queues jobs from array' do
          @controller.archive(@permas)

          expect(Strigil::RedditController.pool.size).to eq(2)
          expect(Strigil::RedditWorker.jobs.size).to eq(2)
        end
      end

      context 'input exists in model but not pool' do
        it 'does not queue' do
          create :reddit_comment

          @controller.archive(@permas)

          expect(Strigil::RedditController.pool.size).to eq(1)
          expect(Strigil::RedditWorker.jobs.size).to eq(1)
        end
      end

      context 'input exists in pool but not model' do
        it 'does not queue' do
          Strigil::RedditController.pool.add(@permas[0])

          @controller.archive(@permas)

          expect(Strigil::RedditController.pool.size).to eq(2)
          expect(Strigil::RedditWorker.jobs.size).to eq(1)
        end
      end
    end
  end
end
