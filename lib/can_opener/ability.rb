module CanOpener
  class Ability
    extend Forwardable
  
    def_delegators :@base, *CanCan::Ability.public_instance_methods

    attr_accessor :user
    protected :user=
  
    def initialize(base, *args)
      @base = base
      setup_vars(*args)
      abilities
    end
    
    protected
    
    def setup_vars(*args)
      @user = args[0]
    end
  end
end