require 'spec_helper'
require "cancan/matchers"

class AdminAbility < CanOpener::Ability
  def abilities
    if user.admin?
      can :manage, :all
    end
  end
end

class SupportAbility < CanOpener::Ability
  def abilities
    if user.support?
      can :read, :all
      can :write, :all
    end
  end
end

class ReaderAbility < CanOpener::Ability
  def abilities
    can :read, :all
    alias_action :read, :to => :speed_read
  end
end

class BannedAbility < CanOpener::Ability
  def abilities
    if user.banned?
      cannot do |action, object_class, object|
        true
      end
    end
  end
end

class Ability
  include CanOpener
  
  configure_abilities do |c|
    c.add ReaderAbility
    c.add SupportAbility
    c.add AdminAbility
    c.add BannedAbility
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
    before(:each) { @ability = Ability.new(admin_user) }
    
    it "should have the abilities loaded in the expected order" do
      Ability.ability_classes.should == [ReaderAbility, SupportAbility, AdminAbility, BannedAbility]
    end
  end
  
  describe "checking abilities" do
    context "for the admin user" do
      before(:each) { @ability = Ability.new(admin_user) }

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
      before(:each) { @ability = Ability.new(support_user) }
      
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
      before(:each) { @ability = Ability.new(reader_user) }
      
      it "should not allow management" do
        @ability.should_not be_able_to(:manage, :foo)
      end
      
      it "should allow reading" do
        @ability.should be_able_to(:read, :foo)
      end
      
      it "should not allow writing" do
        @ability.should_not be_able_to(:write, :foo)
      end
    end
    
    context "for the banned user" do
      before(:each) { @ability = Ability.new(banned_user) }
      
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
  
  describe "aliasing actions" do
    it "should still work" do
      ability = Ability.new(reader_user)
      ability.should be_able_to(:read, :foo)
    end
  end
end