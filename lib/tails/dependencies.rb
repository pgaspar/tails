class Object
  def self.const_missing(const)
    require Tails.to_underscore(const.to_s)
    Object.const_get(const)
  end
end
