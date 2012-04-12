require 'spec_helper'

describe "users/index" do

  before do
    Yogoshu::Locales.set_base_languages(:ja,:en)
    Yogoshu::Locales.set_glossary_language(:ja)
    assign(:base_languages, Yogoshu::Locales.base_languages) 
    assign(:glossary_language, Yogoshu::Locales.glossary_language) 
    @alice = FactoryGirl.create(:user, name: "alice")
    @bob = FactoryGirl.create(:manager, name: "bob")
    @users = [@alice, @bob]

    view.stub(:logged_in?) { true }
  end

  context "as contributor" do
    before do
      view.stub(:manager?) { false }
    end

    it "does not render delete/destroy links" do
      render
      rendered.should_not have_xpath("//tr[./td[contains(.,'alice')]]/td/a", :text => /^edit$/i)
      rendered.should_not have_xpath("//tr[./td[contains(.,'alice')]]/td/a", :text => /^delete$/i)
      rendered.should_not have_xpath("//tr[./td[contains(.,'bob')]]/td/a", :text => /^edit$/i)
      rendered.should_not have_xpath("//tr[./td[contains(.,'bob')]]/td/a", :text => /^delete$/i)
    end

  end


  context "as manager" do
    before do
      view.stub(:manager?) { true }
    end

    it "renders delete/destroy links for all users" do
      render
      rendered.should have_xpath("//tr[./td[contains(.,'alice')]]/td/a", :text => /^edit$/i)
      rendered.should have_xpath("//tr[./td[contains(.,'alice')]]/td/a", :text => /^delete$/i)
      rendered.should have_xpath("//tr[./td[contains(.,'bob')]]/td/a", :text => /^edit$/i)
      rendered.should have_xpath("//tr[./td[contains(.,'bob')]]/td/a", :text => /^delete$/i)
    end

  end
end
