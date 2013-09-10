require 'tspec/description'
require 'tspec/example'
require 'tspec/failure'
require 'tspec/expectation'
require 'tspec/block_expectation'
require 'tspec/attribute'
require 'tspec/matcher'
require 'tspec/autorun'
require 'tspec/top_level_describe'
require 'tspec/exceptions'

module TSpec
  def self.descriptions
    @descriptions ||= []
  end

  def self.add_description text, &block
    if text.is_a? Description
      descriptions << text
    else
      descriptions << Description.new(text, &block)
    end
  end
end
