require 'tspec/callback'

module TSpec
  class Description
    attr_reader :title

    def initialize title, &block
      @title = title
      instance_exec(&block)
    end

    def let attribute, &block
      attributes << Attribute.new(attribute, &block)
    end

    def it title, &block
      examples << Example.new(title, self, &block)
    end
    alias :specify :it

    def before &block
      before_callbacks << Callback.new(&block)
    end

    def after
      after_callbacks << Callback.new(&block)
    end

    def describe title, &block
      new_description = Description.new("#{self.title} #{title}", &block)
      attributes.each do |attr|
        unless new_description.has_attribute?(attr)
          new_description.let(attr.name, &attr.block)
        end
      end
      TSpec.add_description new_description, &block
    end
    alias :context :describe

    def before_callbacks
      @before_callbacks ||= []
    end

    def after_callbacks
      @after_callbacks ||= []
    end

    def examples
      @examples ||= []
    end

    def attributes
      @attributes ||= []
    end

    def has_attribute? attribute
      attributes.any? { |attr| attr.name.to_s == attribute.name.to_s }
    end
  end
end
