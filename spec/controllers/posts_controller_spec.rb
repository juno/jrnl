require 'spec_helper'

describe PostsController, :type => :controller do

  def stub_recent_posts
    @posts = []
    5.times { @posts << FactoryGirl.build(:post) }
    allow(Post).to receive_message_chain(:recent, :page, :per) { @posts }
  end

  before { allow(Settings).to receive(:caching).and_return({ 'use' => false }) }

  describe "GET index" do
    before do
      stub_recent_posts
      get :index
    end

    subject { controller }
    it { is_expected.to render_template(:index) }

    describe '@posts' do
      subject { assigns(:posts) }
      it { is_expected.to eq(@posts) }
    end
  end

  describe "GET index.rss" do
    before do
      stub_recent_posts
      get :index, :format => :rss
    end

    subject { controller }
    it { is_expected.to render_template(:index) }

    describe '@posts' do
      subject { assigns(:posts) }
      it { is_expected.to eq(@posts) }
    end
  end

  describe "GET show" do
    before do
      @post = FactoryGirl.build_stubbed(:post)
      expect(Post).to receive(:find).with('37').and_return(@post)
      get :show, :id => '37'
    end

    subject { controller }
    it { is_expected.to render_template(:show) }

    describe '@post' do
      subject { assigns(:post) }
      it { is_expected.to eq(@post) }
    end
  end

  describe "GET new" do
    context "not sign in" do
      before { get :new }
      subject { controller }
      it { is_expected.to respond_with(:redirect) }
    end

    context "sign in" do
      before do
        @post = FactoryGirl.build_stubbed(:post)
        expect(Post).to receive(:new).and_return(@post)

        sign_in FactoryGirl.create(:author)
        get :new
      end

      subject { controller.response }
      it { is_expected.to render_template(:new) }

      describe '@post' do
        subject { assigns(:post) }
        it { is_expected.to eq(@post) }
      end
    end
  end

  describe "GET edit" do
    context "not sign in" do
      before { get :edit, :id => '37' }
      subject { controller }
      it { is_expected.to respond_with(:redirect) }
    end

    context "sign in" do
      before { sign_in FactoryGirl.create(:author) }

      context "with invalid id" do
        it "raises exception" do
          expect { get :edit, :id => '0' }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "with valid id" do
        before do
          @post = FactoryGirl.build_stubbed(:post)
          expect(Post).to receive(:find).with('37').and_return(@post)
          get :edit, :id => '37'
        end
        subject { controller }
        it { is_expected.to render_template(:edit) }

        describe '@post' do
          subject { assigns(:post) }
          it { is_expected.to eq(@post) }
        end
      end
    end
  end

  describe "POST create" do
    context "not sign in" do
      before { post :create }
      subject { controller }
      it { is_expected.to respond_with(:redirect) }
    end

    context "sign in" do
      before { sign_in FactoryGirl.create(:author) }

      context "create failure" do
        before do
          @post = FactoryGirl.build_stubbed(:post)
          expect(@post).to receive(:save).and_return(false)
          expect(Post).to receive(:new).and_return(@post)
          post :create, post: { body: 'This is a test post.'}
        end

        subject { controller }
        it { is_expected.to render_template(:new) }

        describe '@post' do
          subject { assigns(:post) }
          it { is_expected.to eq(@post) }
        end
      end

      context "successfully created" do
        before do
          @post = FactoryGirl.build_stubbed(:post)
          expect(@post).to receive(:save).and_return(true)
          expect(Post).to receive(:new).and_return(@post)
          post :create, post: { body: 'This is a test post.'}
        end

        subject { controller }
        it { is_expected.to redirect_to(post_url(@post)) }
        it 'sets notice to flash' do
          expect(flash[:notice]).to eq('Post was successfully created.')
        end

        describe '@post' do
          subject { assigns(:post) }
          it { is_expected.to eq(@post) }
        end
      end
    end
  end

  describe "PUT update" do
    context "not sign in" do
      before { put :update, :id => '1' }
      subject { controller }
      it { is_expected.to respond_with(:redirect) }
    end

    context "sign in" do
      before { sign_in FactoryGirl.create(:author) }

      context "update failure" do
        before do
          @post = FactoryGirl.build_stubbed(:post)
          expect(@post).to receive(:update_attributes).and_return(false)
          expect(Post).to receive(:find).and_return(@post)
          put :update, :id => '1', :post => { content: 'Updated content.' }
        end

        subject { controller }
        it { is_expected.to render_template(:edit) }

        describe '@post' do
          subject { assigns(:post) }
          it { is_expected.to eq(@post) }
        end
      end

      context "successfully updated" do
        before do
          @post = FactoryGirl.build_stubbed(:post)
          expect(@post).to receive(:update_attributes).and_return(true)
          expect(Post).to receive(:find).with('37').and_return(@post)
          put :update, :id => '37', :post => { content: 'Updated content.' }
        end

        subject { controller }
        it { is_expected.to redirect_to(post_url(@post)) }
        it 'sets notice to flash' do
          expect(flash[:notice]).to eq('Post was successfully updated.')
        end

        describe '@post' do
          subject { assigns(:post) }
          it { is_expected.to eq(@post) }
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "not sign in" do
      before { delete :destroy, :id => '1' }
      subject { controller }
      it { is_expected.to respond_with(:redirect) }
    end

    context "sign in" do
      before { sign_in FactoryGirl.create(:author) }

      context "destroy failure" do
        before do
          @post = FactoryGirl.build_stubbed(:post)
          expect(@post).to receive(:destroy).and_raise(RuntimeError)
          expect(Post).to receive(:find).with('37').and_return(@post)
          expect { delete :destroy, :id => '37' }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "successfully destroyed" do
        before do
          @post = FactoryGirl.build_stubbed(:post)
          expect(@post).to receive(:destroy)
          expect(Post).to receive(:find).with('37').and_return(@post)
          delete :destroy, :id => '37'
        end

        subject { controller }
        it { is_expected.to redirect_to(posts_url) }

        describe '@post' do
          subject { assigns(:post) }
          it { is_expected.to eq(@post) }
        end
      end
    end
  end

  describe "GET monthly_archive" do
    before do
      # stub posts
      @posts = []
      5.times { @posts << FactoryGirl.build(:post) }
      allow(Post).to receive_message_chain(:created_within, :oldest, :page, :per) { @posts }

      get :monthly_archive, :year => '2011', :month => '1'
    end

    subject { controller }
    it { is_expected.to render_template(:index) }

    describe '@posts' do
      subject { assigns(:posts) }
      it { is_expected.to eq(@posts) }
    end
  end

end
