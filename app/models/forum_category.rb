class ForumCategory < ActiveRecord::Base
  establish_connection(Rails.env)
  extend SiteSpecific
  
  belongs_to :user
  has_many :forums

  validates_presence_of :title

  before_create :set_view_order

  def can_be_deleted_by?(user_wanting_access)
    user_wanting_access.is_admin?
  end
  def can_be_updated_by?(user_wanting_access)
    user_wanting_access.is_admin?
  end

  def self.with_forums
    ForumCategory.joins(:forums).uniq.order(:view_order)
  end
  
  def older_than?(compared_arg, compared_criteria)
   compared_time = compared_arg.class.name == self.class.name ? compared_arg.send(compared_criteria) : compared_arg
   self.send(compared_criteria).nil? ||  self.send(compared_criteria) < compared_time
  end
  
  private

  def set_view_order
    self.view_order = (ForumCategory.maximum('view_order') || 0) + 1
  end

end
