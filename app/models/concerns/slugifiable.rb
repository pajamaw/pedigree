module Slugifiable

  def slug
    self.username.downcase
  end

  def find_by_slug(slug)
    self.all.find { |instance| instance.slug == slug }
    end
  end
