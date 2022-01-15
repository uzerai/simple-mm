module HasSlug 
  extend ActiveSupport::Concern
  include ActiveModel::Callbacks

  included do
    before_validation :set_slug

    validates :slug, uniqueness: true, presence: true
  end
  
  def set_slug
    self.slug = self.send(:sluggable).parameterize
  end

  def sluggable
    raise NotImplementedError, "#{self.class} instance did not define #sluggable"
  end
end