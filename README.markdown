can-opener
==========

Split up your CanCan Ability by allowing you to easily create abilities in separate classes which you reference in your main ability model.  This is mainly useful if you want to break down your abilities into smaller classes for organizational purposes.

Usage
-----

    gem install can_opener

Declare ability classes than inherit from CanOpener::Ability, and implement the `abilities` public instance method.  By default, the method will have access to the the local `user` as per typical use in CanCan.

    require 'can_opener'
    
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

    class BannedAbility < CanOpener::Ability
      def abilities
        if user.banned?
          cannot do |action, object_class, object|
            true
          end
        end
      end
    end
    
Then declare your Ability class, but include `CanOpener` rather than `CanCan::Abilities`

    class Ability
      include CanOpener

      configure_abilities do |c|
        c.add ReaderAbility
        c.add SupportAbility
        c.add AdminAbility, BannedAbility
      end
    end
    
Remember that CanCan processes abilities in a top down fashion, so add your general abilities up top, and then things you want to override everything (like banning a user) at the bottom.  You can add line by line or multiple on one line if you wish.
  
Why?
----

A couple times when I used CanCan, my abilities definition method got a little long, and I wanted a simple way to break it up for readability.

Todo
----

* Perhaps a generator for CanOpener::Ability subclasses.
* Allow easy initializer overriding to allow additional values passed to the ability (Project, IP Address, etc)
