
class Article < ActiveRecord::Base

  include TextValidations

  attr_accessible :title, :body, :tag_list, :image

  validates :title, :presence => true, :format => {:without => /jeremy/}
  validates :body, :presence => true, :format => {:without => /jeremy/}
  validate :valid_text

  has_many :comments
  has_many :taggings
  has_many :tags, :through => :taggings

  has_attached_file :image

  def tag_list
    return self.tags.join(", ")
  end

  def tag_list=(tags_string)
    self.taggings.destroy_all

    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq

    tag_names.each do |tag_name|
      tag = Tag.find_or_create_by_name(tag_name)
      tagging = self.taggings.new
      tagging.tag_id = tag.id
    end
  end

  def self.only(params)
    limit = "LIMIT #{params[:limit]}" unless params[:limit] == nil
    case params[:order_by]
    when 'title'     then Article.order("title #{limit}")
    when 'published' then Article.order("created_at DESC #{limit}")
    when 'wordcount' then Article.order("length(body) #{limit}")
    else                  Article.all
    end
  end

end
