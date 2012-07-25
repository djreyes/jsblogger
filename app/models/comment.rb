class Comment < ActiveRecord::Base
  attr_accessible :author_name, :body

  belongs_to :article

  validates :body, :length => {:maximum => 250}
  validates :article_id, :presence => true
end
