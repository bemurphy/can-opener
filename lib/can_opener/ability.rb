module CanOpener
  class Ability
    extend Forwardable
  
    def_delegators :@base, *CanCan::Ability.public_instance_methods

    attr_accessor :user
    protected :user=
  
    def initialize(base, user)
      @base = base
      self.user = user
      abilities
    end
  end
end