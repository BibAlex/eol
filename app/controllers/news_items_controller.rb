class NewsItemsController < ApplicationController
  
  layout 'v2/users'
  
  def index
    @news_items=NewsItem.paginate(:conditions=>['language_id=? and active=1 and activated_on<=?',Language.from_iso(I18n.locale.to_s), DateTime.now],:order=>'display_date desc',:page => params[:page])
    @news_items_count=NewsItem.count(:conditions=>['language_id=? and active=1 and activated_on<=?',Language.from_iso(I18n.locale.to_s), DateTime.now])
  end
  
  def show
    @news_item = NewsItem.find_by_id(params[:id])
  end
    
end
