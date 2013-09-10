def self.describe text, &block
  TSpec.add_description text, &block
end

class Module
  def describe text, &block
    TSpec.add_description text, &block
  end
end
