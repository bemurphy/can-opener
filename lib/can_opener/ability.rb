module CanOpener
  class Ability
    extend Forwardable
  
    def_delegators :@base, *CanCan::Ability.public_instance_methods
  
    def initialize(base, user)
      @base = base
    end
  end
end