class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  extend FriendlyId
  
  friendly_id :full_name, use: [:slugged, :finders]
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :posts, dependent: :destroy
  has_many :comments
  
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy

  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy

  has_many :followers, through: :passive_relationships, source: :follower
  
  

  
  
  #validations
  validates :first_name, :last_name, :email, presence: true
  
  validates :email, uniqueness: true
  
  validates :introduction, length: { maximum: 500 } 
  
  #paperclip
  has_attached_file :avatar, styles: { large:"600x600#", medium: "250x250#", thumb: "50x50#" }, default_url: "/images/missing_:style.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  #valdiations for paperclip
  validates_with AttachmentSizeValidator, attributes: :avatar, less_than: 2.megabytes
  
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  
  
  #start the following stuff
  def following?(other_user)
    following.include?(other_user)
  end
  
  def being_followed?(other_user)
    followers.include?(other_user)
  end
  
     # Follows a user
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end



end
