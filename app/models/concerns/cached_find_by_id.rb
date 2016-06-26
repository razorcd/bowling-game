require 'active_support/concern'

module CachedFindById
  extend ActiveSupport::Concern

  def remove_from_cache
    Rails.cache.delete([self.class.name, self.id])
  end

  class_methods do
    def cached_find_by_id game_id
      Rails.cache.fetch([name, game_id]) { self.find_by_id game_id }
    end
  end
end
