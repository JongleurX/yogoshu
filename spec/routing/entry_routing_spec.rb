# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Entry routing" do

  it "correctly routes entry requests with slashes in id" do
    { :get => "/entries/a/term/with/slashes"  }.
      should route_to(
        :controller => "entries",
        :action => "show",
        :id => "a/term/with/slashes"
    )
  end

  it "prioritizes action keyword 'edit' over id with slashes" do
    { :get => "/entries/a/term/with/slashes/edit"  }.
      should route_to(
        :controller => "entries",
        :action => "edit",
        :id => "a/term/with/slashes"
    )
  end

  it "prioritizes action keywords 'approve' and 'unapprove' over id with slashes" do
    { :post => "/entries/a/term/with/slashes/approve"  }.
      should route_to(
        :controller => "entries",
        :action => "approve",
        :id => "a/term/with/slashes"
    )
  end

end
