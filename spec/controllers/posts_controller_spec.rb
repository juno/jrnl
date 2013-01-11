require 'spec_helper'

describe PostsController do

  def mock_post(stubs = {})
    (@mock_post ||= mock_model(Post).as_null_object).tap do |post|
      post.stub(stubs) unless stubs.empty?
    end
  end

  def stub_recent_posts
    @posts = []
    5.times { @posts << mock_model(Post) }
    Post.stub_chain(:recent, :page, :per) { @posts }
  end

  before { Settings.stub(:caching).and_return({ 'use' => false }) }

  describe "GET index" do
    before do
      stub_recent_posts
      get :index
    end

    subject { controller }
    it { should assign_to(:posts).with(@posts) }
    it { should respond_with_content_type(:html) }
    it { should render_template(:index) }
  end

  describe "GET index.rss" do
    before do
      stub_recent_posts
      get :index, :format => :rss
    end

    subject { controller }
    it { should assign_to(:posts).with(@posts) }
    it { should respond_with_content_type(:rss) }
    it { should render_template(:index) }
  end

  describe "GET show" do
    before do
      Post.stub(:find).with('37') { mock_post }
      get :show, :id => '37'
    end

    subject { controller }
    it { should render_template(:show) }
    it { should assign_to(:post).with(mock_post) }
  end

  describe "GET new" do
    before { Post.stub(:new) { mock_post} }

    context "not sign in" do
      before { get :new }
      subject { controller }
      it { should respond_with(:redirect) }
    end

    context "sign in" do
      before do
        sign_in FactoryGirl.create(:author)
        get :new
      end

      subject { controller }
      it { should render_template(:new) }
      it { should assign_to(:post).with(mock_post) }
    end
  end

  describe "GET edit" do
    context "not sign in" do
      before { get :edit, :id => '37' }
      subject { controller }
      it { should respond_with(:redirect) }
    end

    context "sign in" do
      before { sign_in FactoryGirl.create(:author) }

      context "with invalid id" do
        it "raises exception" do
          expect { get :edit, :id => '0' }.to raise_error
        end
      end

      context "with valid id" do
        before do
          Post.stub(:find).with('37') { mock_post }
          get :edit, :id => '37'
        end
        subject { controller }
        it { should assign_to(:post).with(mock_post) }
        it { should render_template(:edit) }
      end
    end
  end

  describe "POST create" do
    context "not sign in" do
      before { post :create }
      subject { controller }
      it { should respond_with(:redirect) }
    end

    context "sign in" do
      before { sign_in FactoryGirl.create(:author) }

      context "create failure" do
        before do
          Post.stub(:new) { mock_post(:save => false) }
          post :create, :post => {}
        end

        subject { controller }
        it { should assign_to(:post).with(mock_post) }
        it { should render_template(:new) }
      end

      context "successfully created" do
        before do
          Post.stub(:new) { mock_post(:save => true) }
          post :create, :post => {}
        end

        subject { controller }
        it { should assign_to(:post).with(mock_post) }
        it { should redirect_to(post_url(mock_post)) }
        it { should set_the_flash.to('Post was successfully created.') }
      end
    end
  end

  describe "PUT update" do
    context "not sign in" do
      before { put :update, :id => '1' }
      subject { controller }
      it { should respond_with(:redirect) }
    end

    context "sign in" do
      before { sign_in FactoryGirl.create(:author) }

      context "update failure" do
        before do
          Post.stub(:find) { mock_post(:update_attributes => false) }
          put :update, :id => '1'
        end

        subject { controller }
        it { should assign_to(:post).with(mock_post) }
        it { should render_template(:edit) }
      end

      context "successfully updated" do
        before do
          Post.should_receive(:find).with('37') { mock_post }
          mock_post.should_receive(:update_attributes).and_return(true)
          put :update, :id => '37', :post => {}
        end

        subject { controller }
        it { should assign_to(:post).with(mock_post) }
        it { should redirect_to(post_url(mock_post)) }
        it { should set_the_flash.to('Post was successfully updated.') }
      end
    end

  end

  describe "DELETE destroy" do
    context "not sign in" do
      before { delete :destroy, :id => '1' }
      subject { controller }
      it { should respond_with(:redirect) }
    end

    context "sign in" do
      before { sign_in FactoryGirl.create(:author) }

      context "destroy failure" do
        before do
          Post.should_receive(:find).with('37') { mock_post }
          mock_post.stub(:destroy).and_raise(RuntimeError)
          expect { delete :destroy, :id => '37' }.should raise_error
        end
      end

      context "successfully destroyed" do
        before do
          Post.should_receive(:find).with('37') { mock_post }
          mock_post.should_receive(:destroy)
          delete :destroy, :id => '37'
        end

        subject { controller }
        it { should assign_to(:post).with(mock_post) }
        it { should redirect_to(posts_url) }
      end
    end
  end

  describe "GET monthly_archive" do
    before do
      # stub posts
      @posts = []
      5.times { @posts << mock_model(Post) }
      Post.stub_chain(:created_within, :oldest, :page, :per) { @posts }

      get :monthly_archive, :year => '2011', :month => '1'
    end

    subject { controller }
    it { should assign_to(:posts).with(@posts) }
    it { should render_template(:index) }
  end

end
