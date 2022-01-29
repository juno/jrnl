require 'spec_helper'

RSpec.describe PostsController, type: :controller do
  def stub_recent_posts
    @posts = []
    5.times { @posts << FactoryBot.build(:post) }
    allow(Post).to receive_message_chain(:recent, :page, :per) { @posts }
  end

  describe "GET index" do
    subject { get :index }
    before { stub_recent_posts }

    it 'returns status code 200' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET index.rss" do
    subject { get :index, params: { format: 'rss' } }
    before { stub_recent_posts }

    it 'returns status code 200' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET show" do
    subject { get :show, params: { id: '37' } }
    let(:post) { FactoryBot.build_stubbed(:post) }

    before do
      expect(Post).to receive(:find).with('37').and_return(post)
    end

    it 'returns status code 200' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET new" do
    subject { get :new }

    context "not sign in" do
      it 'redirects to sign in page' do
        subject
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "sign in" do
      let(:author) { FactoryBot.create(:author) }
      let(:post) { FactoryBot.create(:post, ) }

      before { sign_in(author) }

      it 'returns status code 200' do
        subject
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET edit" do
    subject { get :edit, params: params }

    context "not sign in" do
      let(:params) { { id: '37' } }

      it 'redirects to sign in page' do
        subject
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "sign in" do
      let(:author) { FactoryBot.create(:author) }
      before { sign_in(author) }

      context "with invalid id" do
        let(:params) { { id: '0' } }

        it "raises exception" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "with valid id" do
        let(:params) { { id: post.id } }
        let(:post) { FactoryBot.create(:post) }

        it 'returns status code 200' do
          subject
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "POST create" do
    subject { post :create, params: params }

    context "not sign in" do
      let(:params) { { post: {} } }
      it 'redirects to sign in page' do
        subject
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "sign in" do
      let(:author) { FactoryBot.create(:author) }
      let(:new_post) { FactoryBot.build_stubbed(:post) }
      let(:params) do
        {
          post: {
            body: 'This is a test post.',
          },
        }
      end

      before { sign_in(author) }

      context "create failure" do
        before do
          expect(new_post).to receive(:save).and_return(false)
          expect(Post).to receive(:new).and_return(new_post)
        end

        it 'returns status code 200' do
          subject
          expect(response).to have_http_status(:ok)
        end
      end

      context "successfully created" do
        before do
          expect(new_post).to receive(:save).and_return(true)
          expect(Post).to receive(:new).and_return(new_post)
        end

        it 'redirects to the created post url' do
          subject
          expect(response).to redirect_to(post_url(new_post))
        end

        it 'sets notice to flash' do
          subject
          expect(flash[:notice]).to eq('Post was successfully created.')
        end
      end
    end
  end

  describe "PUT update" do
    subject { put :update, params: params }

    context "not sign in" do
      let(:params) { { id: '1' } }

      it 'redirects to sign in page' do
        subject
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "sign in" do
      let(:author) { FactoryBot.create(:author) }
      let(:a_post) { FactoryBot.create(:post) }
      let(:params) do
        {
          id: a_post.id,
          post: {
            content: 'Updated content.',
          },
        }
      end

      before { sign_in(author) }

      context "update failure" do
        before do
          expect(a_post).to receive(:update).and_return(false)
          expect(Post).to receive(:find).and_return(a_post)
        end

        it 'returns status code 200' do
          subject
          expect(response).to have_http_status(:ok)
        end
      end

      context "successfully updated" do
        before do
          expect(a_post).to receive(:update).and_return(true)
          expect(Post).to receive(:find).and_return(a_post)
        end

        it 'redirects to the updated post url' do
          subject
          expect(response).to redirect_to(post_url(a_post))
        end

        it 'sets notice to flash' do
          subject
          expect(flash[:notice]).to eq('Post was successfully updated.')
        end
      end
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, params: params }

    context "not sign in" do
      let(:params) { { id: '1' } }

      it 'redirects to sign in page' do
        subject
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "sign in" do
      let(:author) { FactoryBot.create(:author) }
      let!(:a_post) { FactoryBot.create(:post) }
      let(:params) { { id: a_post.id } }

      before { sign_in(author) }

      context "destroy failure" do
        before do
          expect(a_post).to receive(:destroy).and_raise(RuntimeError)
          expect(Post).to receive(:find).and_return(a_post)
        end

        it 'raises error' do
          expect { subject }.to raise_error(RuntimeError)
        end
      end

      context "successfully destroyed" do
        it 'destroys a post' do
          expect { subject }.to change(Post, :count).by(-1)
        end

        it 'redirects to posts url' do
          subject
          expect(response).to redirect_to(posts_url)
        end
      end
    end
  end

  describe "GET monthly_archive" do
    subject { get :monthly_archive, params: params }
    let(:params) { { year: '2011', month: '1' } }

    before do
      # stub posts
      posts = FactoryBot.build_list(:post, 5)
      allow(Post).to receive_message_chain(:created_within, :oldest, :page, :per) { posts }
    end

    it 'returns status code 200' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end
end
