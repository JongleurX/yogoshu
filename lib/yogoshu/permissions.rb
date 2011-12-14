# ref: http://railstips.org/blog/archives/2009/04/20/how-to-add-simple-permissions-into-your-simple-app-also-thoughtbot-rules/ 

module Permissions
  def changeable_by?(other_user)
    return false if other_user.nil?
    user == other_user || other_user.manager?
  end

  # added for testing User model which has no user association
  def user
    self.class == User ? self : super
  end
end
