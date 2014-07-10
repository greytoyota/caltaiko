=begin rdoc
Members have name, gen, major, bio, and avatar fields.
To create a member, all of the fields except the avatar must be present.
* The name must be at least two characters long
* The gen must be an integer greater than 0
* The major must also be at least two characters long
If no avatar is given, an image is provided by http://robohash.org, 
which hashes input to pictures of robots.

Should robohash.org ever close down, there are also regular 
default images available to be used.
They can be found in
    /public/images/:style/missing.png
=end
class Member < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }
  validates :gen, presence: true, numericality: {only_integer: true, greater_than: 0 }
  validates :major, presence: true, length: {minimum: 2}
  validates :bio, presence: true

  has_attached_file :avatar, :styles => { thumb: "200x200#" },
  path: "/members/:id/:attachment/:style/:filename",
  url: "/members/:id/:attachment/:style/:filename",
  # default_url: "/images/:style/missing.png"
  # if robohash website ever closes down, delete below and uncomment above
  default_url: "http://robohash.org/:id?size=200x200&bgset=bgany"
  include DeletableAttachment
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def self.current_members
    return Member.where(current: true).order('gen ASC')
  end

  def self.alumni
    return Member.where(current: false).order('gen DESC')
  end
end
