# Methods relating to videos.
class Video < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  validates :title, presence: true
  # TODO: validate link for correct Youtube URL
  validates :link, format: { with: %r{\Ahttps?:\/\/},
                             message: "Url must begin with 'http://'" },
                   presence: true
  validates :year, presence: true,
                   numericality: { only_integer: true,
                                   greater_than_or_equal_to: 2005,
                                   less_than_or_equal_to: Time.new.year }

  def slug_candidates
    [
      :title,
      [:title, :year]
    ]
  end

  def embed_link
    link.sub('watch?v=', 'embed/')
  end

  def self.by_year(videos)
    by_year = {}
    videos.each do |video|
      by_year[video.year.to_s] ||= []
      by_year[video.year.to_s] << video
    end
    by_year
  end
end
