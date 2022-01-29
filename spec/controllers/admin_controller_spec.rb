require "spec_helper"

RSpec.describe AdminController, type: :controller do
  def stub_posts(count = 10)
    @posts = []
    count.times { @posts << build(:post) }
    allow(Post).to receive_message_chain(:recent, :page, :per) { @posts }
  end

  describe "GET 'index'" do
    context "when not sign in" do
      it "redirects to sign in page" do
        get :index
        expect(request).to redirect_to(new_user_session_url)
      end
    end

    context "when signed in" do
      let(:author) { create(:author) }

      before do
        stub_posts(10)
        sign_in(author)
      end

      it "returns status code 200" do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
