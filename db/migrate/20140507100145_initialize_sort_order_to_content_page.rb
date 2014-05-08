class InitializeSortOrderToContentPage < ActiveRecord::Migration
  def up
    parents_ids = ContentPage.connection.execute("SELECT DISTINCT(parent_content_page_id) FROM content_pages")
    parents_ids.each do |parent_id|
      sort_order = 1
      children = ContentPage.find_all_by_parent_content_page_id(parent_id, order: 'sort_order')
      children.each do |child|
        child.update_column(:sort_order, sort_order)
        sort_order = sort_order + 1
      end
    end
  end

  def down
  end
end