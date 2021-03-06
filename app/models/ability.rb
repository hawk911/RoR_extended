class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)

    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer, Comment] , user_id: user.id
    can :destroy, [Question, Answer, Comment, Subscription], user_id: user.id

    can :set_best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can [:like, :dislike], [Question, Answer] do |votable|
      user.can_vote?(votable)
    end

    can [:change_vote, :cancel_vote], [Question, Answer] do |votable|
      !user.author_of?(votable) && user.voted?(votable)
    end
    can :destroy, [Attachment], attachable: { user: user }
    can [:read, :me], User

  end
end
