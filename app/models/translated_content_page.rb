class TranslatedContentPage < ActiveRecord::Base
  belongs_to :content_page
  belongs_to :language

  validates_presence_of :title
  validates_presence_of :main_content
  validates_length_of :title, maximum: 255

  before_destroy :archive_self

  def can_be_read_by?(user_wanting_access)
    user_wanting_access.is_admin? || active_translation?
  end
  def can_be_created_by?(user_wanting_access)
    user_wanting_access.is_admin?
  end
  def can_be_updated_by?(user_wanting_access)
    user_wanting_access.is_admin?
  end
  def can_be_deleted_by?(user_wanting_access)
    user_wanting_access.is_admin?
  end

  def title_with_language
    title + " (" + self.language.iso_639_1 + ")"
  end

  def page_url
    return self.page_name.gsub(' ', '_').downcase
  end

  def is_discover_page?
    main_content =~ /discover_content_section/
  end
  
  def older_than?(compared_arg, compared_criteria)
    compared_time = compared_arg.class.name == self.class.name ? compared_arg.send(compared_criteria) : compared_arg
    self.send(compared_criteria).nil? ||  self.send(compared_criteria) < compared_time
  end

private

  def archive_self
    TranslatedContentPageArchive.backup(self)
  end
end
