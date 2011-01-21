require 'spec_helper'
require "cancan/matchers"

class SpecAdminAbility < CanOpener::Ability
  def initialize(base, user)
    super
    
    if user.admin?
      can :manage, :all
    end
  end
end

class SpecSupportAbility < CanOpener::Ability
  def initialize(base, user)
    super
    
    if user.support?
      can :read, :all
      can :write, :all
    end
  end
end

class SpecReaderAbility < CanOpener::Ability
  def initialize(base, user)
    super
    
    if user.support?
      can :read, :all
    end
  end
end

class SpecBannedAbility < CanOpener::Ability
  def initialize(base, user)
    super
    
    if user.banned?
      cannot do |action, object_class, object|
        true
      end
    end
  end
end

class SpecAbility
  include CanOpener
  
  configure_abilities do |c|
    c.add SpecReaderAbility
    c.add SpecSupportAbility
    c.add SpecAdminAbility
    c.add SpecBannedAbility
  end
end

describe CanOpener do
  def user_double(opts = {})
    double(:user, 
      { :admin? => false, :support? => false, :banned? => false }.merge(opts) 
    )
  end
  
  let(:admin_user) { user_double(:admin? => true) }  
  let(:support_user) { user_double(:support? => true) }
  let (:reader_user) { user_double }
  let (:banned_user) { user_double(:admin? => true, :banned? => true) }

  describe "loading abilities" do
    before(:each) { @ability = SpecAbility.new(admin_user) }
    
    it "should have the abilities loaded in the expected order" do
      SpecAbility.ability_classes.should == [SpecReaderAbility, SpecSupportAbility, SpecAdminAbility, SpecBannedAbility]
    end
  end
  
  
  describe "checking abilities" do
    context "for the admin user" do
      before(:each) { @ability = SpecAbility.new(admin_user) }

      it "should allow management" do
        @ability.should be_able_to(:manage, :foo)
      end
      
      it "should allow reading" do
        @ability.should be_able_to(:read, :foo)
      end
      
      it "should allow writing" do
        @ability.should be_able_to(:write, :foo)
      end
    end
    
    context "for the support user" do
      before(:each) { @ability = SpecAbility.new(support_user) }
      
      it "should not allow management" do
        @ability.should_not be_able_to(:manage, :foo)
      end
      
      it "should allow reading" do
        @ability.should be_able_to(:read, :foo)
      end
      
      it "should not allow writing" do
        @ability.should be_able_to(:write, :foo)
      end
    end
    
    context "for the reader user" do
      before(:each) { @ability = SpecAbility.new(reader_user) }
      
      it "should not allow management" do
        @ability.should_not be_able_to(:manage, :foo)
      end
      
      it "should allow reading" do
        @ability.should_not be_able_to(:read, :foo)
      end
      
      it "should not allow writing" do
        @ability.should_not be_able_to(:write, :foo)
      end
    end
    
    context "for the banned user" do
      before(:each) { @ability = SpecAbility.new(banned_user) }
      
      it "should not allow management" do
        @ability.should_not be_able_to(:manage, :foo)
      end
      
      it "should not allow reading" do
        @ability.should_not be_able_to(:read, :foo)
      end
      
      it "should not allow writing" do
        @ability.should_not be_able_to(:write, :foo)
      end
    end
  end
end