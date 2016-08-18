class RecommendedLink < ActiveRecord::Base
  validates :title, :link, :description, :keywords, presence: true
  validates :link, uniqueness: true

  def self.to_csv(*_args)
    CSV.generate do |csv|
      csv << %w(title link description keywords comment)

      all.each do |link|
        csv << [link.title,
                link.link,
                link.description,
                link.keywords,
                link.comment.to_s
              ]
      end
    end
  end
end
