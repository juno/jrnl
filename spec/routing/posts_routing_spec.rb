require "spec_helper"

describe PostsController, type: :routing do
  describe "GET /posts" do
    it { expect({ get: "/posts" }).to route_to(controller: "posts", action: "index") }
  end

  describe "GET /posts/new" do
    it { expect({ get: "/posts/new" }).to route_to(controller: "posts", action: "new") }
  end

  describe "GET /posts/1" do
    it { expect({ get: "/posts/1" }).to route_to(controller: "posts", action: "show", id: "1") }
  end

  describe "GET /posts/1/edit" do
    it { expect({ get: "/posts/1/edit" }).to route_to(controller: "posts", action: "edit", id: "1") }
  end

  describe "POST /posts" do
    it { expect({ post: "/posts" }).to route_to(controller: "posts", action: "create") }
  end

  describe "PUT /posts/1" do
    it { expect({ put: "/posts/1" }).to route_to(controller: "posts", action: "update", id: "1") }
  end

  describe "DELETE /posts/1" do
    it { expect({ delete: "/posts/1" }).to route_to(controller: "posts", action: "destroy", id: "1") }
  end

  describe "GET /1" do
    it { expect({ get: "/1" }).to route_to(controller: "posts", action: "show", id: "1") }
  end

  describe "GET /archives/2011/1" do
    it { expect({ get: "/archives/2011/1" }).to route_to(controller: "posts", action: "monthly_archive", year: "2011", month: "1") }
  end
end
