class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  #投稿
  has_many :microposts
  
  #フォロー機能
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  #お気に入り機能
  has_many :favorites
  has_many :likes, through: :favorites, source: :micropost

  #お気に入り機能
  def like(other_micropost)
    self.favorites.find_or_create_by(micropost_id: other_micropost.id)
  end
  
  def unlike(other_micropost)
    favorite = self.favorites.find_by(micropost_id: other_micropost.id)
    favorite.destroy if favorite
  end 
  
  def like?(other_micropost)
    self.likes.include?(other_micropost)
  end 
  
  #def feed_likes
    #Micropost.where(like_id: self.likes_ids)
  #end 
  
  #フォロー機能
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end 
  end 
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end 
  
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end 
end
