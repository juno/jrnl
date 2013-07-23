require 'spec_helper'

describe PostsController do

  describe 'GET /posts' do
    it { { get: '/posts' }.should route_to(controller: 'posts', action: 'index') }
  end

  describe 'GET /posts/new' do
    it { { get: '/posts/new' }.should route_to(controller: 'posts', action: 'new') }
  end

  describe 'GET /posts/1' do
    it { { get: '/posts/1' }.should route_to(controller: 'posts', action: 'show', id: '1') }
  end

  describe 'GET /posts/1/edit' do
    it { { get: '/posts/1/edit' }.should route_to(controller: 'posts', action: 'edit', id: '1') }
  end

  describe 'POST /posts' do
    it { { post: '/posts' }.should route_to(controller: 'posts', action: 'create') }
  end

  describe 'PUT /posts/1' do
    it { { put: '/posts/1' }.should route_to(controller: 'posts', action: 'update', id: '1') }
  end

  describe 'DELETE /posts/1' do
    it { { delete: '/posts/1' }.should route_to(controller: 'posts', action: 'destroy', id: '1') }
  end

  describe 'GET /1' do
    it { { get: '/1' }.should route_to(controller: 'posts', action: 'show', id: '1') }
  end

  describe 'GET /archives/2011/1' do
    it { { get: '/archives/2011/1' }.should route_to(controller: 'posts', action: 'monthly_archive', year: '2011', month: '1') }
  end

end
