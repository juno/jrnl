require 'spec_helper'

RSpec.describe AdminController, type: :controller do
  def stub_posts(count = 10)
    @posts = []
    count.times { @posts << FactoryBot.build(:post) }
    allow(Post).to receive_message_chain(:recent, :page, :per) { @posts }
  end

  describe "GET 'index'" do
    subject { get :index }

    context "not sign in" do
      it 'redirects to sign in page' do
        subject
        expect(request).to redirect_to(new_user_session_url)
      end
    end

    context "sign in" do
      let(:author) { FactoryBot.create(:author) }

      before do
        stub_posts(10)
        sign_in(author)
      end

      it 'returns status code 200' do
        subject
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
