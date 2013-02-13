class Permission < ActiveRecord::Base

  uses_translations

  has_and_belongs_to_many :users, :counter_cache => true

  KNOWN_PERMISSIONS = [:edit_permissions]

  def self.create_defaults
    KNOWN_PERMISSIONS.each do |sym|
      name = sym.gsub('_', ' ')
      perm = cached_find_translated(:name, name)
      unless perm
        perm = Permission.create
        TranslatedPermission.create(:name => name, :language => Language.default,
                                    :permission => perm)
      end
    end
  end

  def self.method_missing(sym, *args, &block)
    super unless KNOWN_PERMISSIONS.include?(sym)
    cached_find_translated(:name, sym.gsub('_', ' ')) || super
  end

end
