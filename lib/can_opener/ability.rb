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

    def self.additional_ability_arguments(*args)
      @@initializer_arguments = [:user]
      args.each_with_index do |arg, idx|
        raise ArgumentError, "user cannot be an additional argument as it is required as the first arg" if arg.to_sym == :user
        @@initializer_arguments << arg.to_sym
      end
    end

    protected

    def setup_vars(*args)
      if @@initializer_arguments && @@initializer_arguments.length > 0
        @@initializer_arguments.each_with_index do |arg, idx|
          self.class.send(:attr_accessor, arg)
          self.send("#{arg}=", args[idx])
        end
      else
        @user = args[0]
      end
    end
  end
end