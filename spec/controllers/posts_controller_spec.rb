require "spec_helper"

RSpec.describe PostsController, type: :controller do
  def stub_recent_posts
    @posts = []
    5.times { @posts << build(:post) }
    allow(Post).to receive_message_chain(:recent, :page, :per) { @posts }
  end

  describe "GET index" do
    before { stub_recent_posts }

    it "returns status code 200" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET index.rss" do
    before { stub_recent_posts }

    it "returns status code 200" do
      get :index, params: { format: "rss" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET show" do
    let(:post) { FactoryBot.build_stubbed(:post) }

    before do
      expect(Post).to receive(:find).with("37").and_return(post)
    end

    it "returns status code 200" do
      get :show, params: { id: "37" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET new" do
    context "when not sign in" do
      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "when signed in" do
      let(:author) { create(:author) }
      let(:post) { create(:post) }

      before { sign_in(author) }

      it "returns status code 200" do
        get :new
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET edit" do
    context "when not sign in" do
      let(:params) { { id: "37" } }

      it "redirects to sign in page" do
        get :edit, params: params
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "when signed in with invalid id" do
      let(:author) { create(:author) }
      let(:params) { { id: "0" } }

      before { sign_in(author) }

      it "raises exception" do
        expect {
          get :edit, params: params
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when signed in with valid id" do
      let(:author) { create(:author) }
      let(:params) { { id: post.id } }
      let(:post) { create(:post) }

      before { sign_in(author) }

      it "returns status code 200" do
        get :edit, params: params
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST create" do
    context "when not sign in" do
      let(:params) { { post: {} } }

      it "redirects to sign in page" do
        post :create, params: params
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "when signed in and create failure" do
      let(:author) { create(:author) }
      let(:new_post) { build_stubbed(:post) }
      let(:params) do
        {
          post: {
            body: "This is a test post.",
          },
        }
      end

      before do
        expect(new_post).to receive(:save).and_return(false)
        expect(Post).to receive(:new).and_return(new_post)

        sign_in(author)
      end

      it "returns status code 200" do
        post :create, params: params
        expect(response).to have_http_status(:ok)
      end
    end

    context "when signed in and successfully created" do
      let(:author) { create(:author) }
      let(:new_post) { build_stubbed(:post) }
      let(:params) do
        {
          post: {
            body: "This is a test post.",
          },
        }
      end

      before do
        expect(new_post).to receive(:save).and_return(true)
        expect(Post).to receive(:new).and_return(new_post)

        sign_in(author)
      end

      it "redirects to the created post url" do
        post :create, params: params
        expect(response).to redirect_to(post_url(new_post))
      end

      it "sets notice to flash" do
        post :create, params: params
        expect(flash[:notice]).to eq("Post was successfully created.")
      end
    end
  end

  describe "PUT update" do
    context "when not sign in" do
      let(:params) { { id: "1" } }

      it "redirects to sign in page" do
        put :update, params: params
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "when signed in and update failure" do
      let(:author) { create(:author) }
      let(:a_post) { create(:post) }
      let(:params) do
        {
          id: a_post.id,
          post: {
            content: "Updated content.",
          },
        }
      end

      before do
        expect(a_post).to receive(:update).and_return(false)
        expect(Post).to receive(:find).and_return(a_post)

        sign_in(author)
      end

      it "returns status code 200" do
        put :update, params: params
        expect(response).to have_http_status(:ok)
      end
    end

    context "when signed in and successfully updated" do
      let(:author) { create(:author) }
      let(:a_post) { create(:post) }
      let(:params) do
        {
          id: a_post.id,
          post: {
            content: "Updated content.",
          },
        }
      end

      before do
        expect(a_post).to receive(:update).and_return(true)
        expect(Post).to receive(:find).and_return(a_post)

        sign_in(author)
      end

      it "redirects to the updated post url" do
        put :update, params: params
        expect(response).to redirect_to(post_url(a_post))
      end

      it "sets notice to flash" do
        put :update, params: params
        expect(flash[:notice]).to eq("Post was successfully updated.")
      end
    end
  end

  describe "DELETE destroy" do
    context "when not sign in" do
      let(:params) { { id: "1" } }

      it "redirects to sign in page" do
        delete :destroy, params: params
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "when signed in and destroy failure" do
      let(:author) { create(:author) }
      let!(:a_post) { create(:post) }
      let(:params) { { id: a_post.id } }

      before do
        expect(a_post).to receive(:destroy).and_raise(RuntimeError)
        expect(Post).to receive(:find).and_return(a_post)

        sign_in(author)
      end

      it "raises error" do
        expect {
          delete :destroy, params: params
        }.to raise_error(RuntimeError)
      end
    end

    context "when signed in and successfully destroyed" do
      let(:author) { create(:author) }
      let!(:a_post) { create(:post) }
      let(:params) { { id: a_post.id } }

      before { sign_in(author) }

      it "destroys a post" do
        expect {
          delete :destroy, params: params
        }.to change(Post, :count).by(-1)
      end

      it "redirects to posts url" do
        delete :destroy, params: params
        expect(response).to redirect_to(posts_url)
      end
    end
  end

  describe "GET monthly_archive" do
    let(:params) { { year: "2011", month: "1" } }

    before do
      # stub posts
      posts = build_list(:post, 5)
      allow(Post).to receive_message_chain(:created_within, :oldest, :page, :per) { posts }
    end

    it "returns status code 200" do
      get :monthly_archive, params: params
      expect(response).to have_http_status(:ok)
    end
  end
end
