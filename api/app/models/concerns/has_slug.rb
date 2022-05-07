# frozen_string_literal: true

module HasSlug
  extend ActiveSupport::Concern
  include ActiveModel::Callbacks

  included do
    before_validation :set_slug

    validates :slug, uniqueness: true, presence: true
  end

  def set_slug
    unless send(sluggable).present?
      errors.add(sluggable, "can't be blank")
      raise ActiveRecord::RecordInvalid
    end

    self.slug = send(sluggable).parameterize
  end

  def sluggable
    raise NotImplementedError, "#{self.class} instance did not define #sluggable"
  end
end
