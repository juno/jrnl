require 'spec_helper'

describe AdminController do

  def stub_posts(count = 10)
    @posts = []
    count.times { @posts << mock_model(Post) }
    Post.stub_chain(:recent, :page, :per) { @posts }
  end

  describe "GET 'index'" do
    context "not sign in" do
      before { get :index }
      subject { controller }
      it { should respond_with(:redirect) }
    end

    context "sign in" do
      before do
        stub_posts(10)
        sign_in FactoryGirl.create(:author)
        get :index
      end

      subject { controller }
      it { should respond_with(:success) }
      it { should render_template(:index) }

      describe '@posts' do
        subject { assigns(:posts) }
        it { should eq(@posts) }
      end
    end
  end

end
