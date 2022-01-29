require "spec_helper"

describe Post, type: :model do
  def setup_post_fixtures
    create(:post, created_at: Time.zone.local(2010, 12, 31), content: "oldest one")
    create(:post, created_at: Time.zone.local(2011, 1, 1))
    create(:post, created_at: Time.zone.local(2011, 1, 31))
    create(:post, created_at: Time.zone.local(2011, 2, 1))
    create(:post, created_at: Time.zone.local(2011, 2, 2), content: "newest one")
  end

  it { is_expected.to validate_presence_of :content }

  describe ".created_within" do
    before { setup_post_fixtures }

    let(:beginning_of_month) { Time.zone.local(2011, 1, 10).beginning_of_month }
    let(:end_of_month) { Time.zone.local(2011, 1, 10).end_of_month }

    it "has 2 posts" do
      actual = described_class.created_within(beginning_of_month, end_of_month)
      expect(actual.size).to eq(2)
    end
  end

  describe ".oldest" do
    subject { described_class.oldest }

    before { setup_post_fixtures }

    it "has 5 posts" do
      expect(subject.size).to eq(5)
    end

    describe "#first" do
      subject { super().first }

      describe "#content" do
        subject { super().content }

        it { is_expected.to eq("oldest one") }
      end
    end

    describe "#last" do
      subject { super().last }

      describe "#content" do
        subject { super().content }

        it { is_expected.to eq("newest one") }
      end
    end
  end

  describe ".recent" do
    subject { Post.recent }

    before { setup_post_fixtures }

    it "has 5 posts" do
      expect(subject.size).to eq(5)
    end

    describe "#first" do
      subject { super().first }

      describe "#content" do
        subject { super().content }

        it { is_expected.to eq("newest one") }
      end
    end

    describe "#last" do
      subject { super().last }

      describe "#content" do
        subject { super().content }

        it { is_expected.to eq("oldest one") }
      end
    end
  end

  describe "#html" do
    context "content contains valid Markdown" do
      subject { described_class.new(content:).html }

      let(:content) { "[Example](http://example.com/)" }

      it { is_expected.to eq("<p><a href=\"http://example.com/\">Example</a></p>\n") }
    end

    context "content contains invalid Markdown" do
      subject { described_class.new(content: "dummy").html }

      before do
        stub = instance_double("Redcarpet::Markdown")
        allow(stub).to receive(:render).and_raise("render error")
        allow(Redcarpet::Markdown).to receive(:new).and_return(stub)
      end

      it { is_expected.to match(/^Couldn't parse content as HTML: .+/) }
    end
  end

  describe "#title" do
    context "when length of first line less than 71" do
      subject { described_class.new(content:).title }

      let(:content) { "*First* line\nSecond line." }

      it { is_expected.to match(/^First /) }
      it { is_expected.not_to match(/\n/) }
    end

    context "when length of first line greater than 70" do
      subject { described_class.new(content:).title }

      let(:content) { "*a*#{'b' * 70}" }

      it { is_expected.to match(/...$/) }
      it { is_expected.not_to match(/<em>/) }

      it "returns 73 characters as string" do
        expect(subject.length).to eq(70 + 3)
      end
    end
  end
end
