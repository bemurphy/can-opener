require "forwardable"
require "cancan"
require "can_opener/ability"

module CanOpener
  include CanCan::Ability

  def self.included(base)
    base.extend ClassMethods
    class << base;
      attr_accessor :ability_classes
      protected :ability_classes=
    end
  end

  module ClassMethods    
    def configure_abilities(&block)
      yield self
    end
    
    protected

    def add(*klasses)
      self.ability_classes ||= []
      self.ability_classes.concat Array(klasses)
      self.ability_classes.uniq!
    end
  end

  def initialize(user)
    self.class.ability_classes.each do |ability_class|
      ability_class.new(self, user)
    end
  end
end