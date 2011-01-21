module CanOpener
  class Ability
    extend Forwardable

    class << self;
      attr_accessor :initializer_arguments
    end
    # superclass_delegating_reader :initializer_arguments

    def_delegators :@base, *CanCan::Ability.public_instance_methods
    
    attr_accessor :user
    protected :user=

    def initialize(base, *args)
      raise "You should only work with subclasses of CanOpener::Ability" if self.class == CanOpener::Ability
      @base = base
      setup_vars(*args)
      abilities
    end

    def self.additional_ability_arguments(*args)
      self.initializer_arguments = [:user]
      args.each_with_index do |arg, idx|
        raise ArgumentError, "user cannot be an additional argument as it is required as the first arg" if arg.to_sym == :user
        self.initializer_arguments << arg.to_sym
      end
    end
    
    protected

    def setup_vars(*args)
      if has_additional_ability_arguments?
        initializer_arguments.each_with_index do |arg, idx|
          self.class.send(:attr_accessor, arg)
          self.send("#{arg}=", args[idx])
        end
      else
        @user = args[0]
      end
    end
    
    def has_additional_ability_arguments?
      initializer_arguments && initializer_arguments.length > 0
    end
    
    def initializer_arguments
      self.class.superclass.initializer_arguments
    end
  end
end