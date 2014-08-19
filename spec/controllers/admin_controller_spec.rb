require 'spec_helper'

describe AdminController, :type => :controller do

  def stub_posts(count = 10)
    @posts = []
    count.times { @posts << FactoryGirl.build(:post) }
    allow(Post).to receive_message_chain(:recent, :page, :per) { @posts }
  end

  describe "GET 'index'" do
    context "not sign in" do
      before { get :index }
      subject { controller }
      it { is_expected.to respond_with(:redirect) }
    end

    context "sign in" do
      before do
        stub_posts(10)
        sign_in FactoryGirl.create(:author)
        get :index
      end

      subject { controller }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:index) }

      describe '@posts' do
        subject { assigns(:posts) }
        it { is_expected.to eq(@posts) }
      end
    end
  end

end
