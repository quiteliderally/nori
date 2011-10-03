require 'delegate'

module Nori
  class XMLReferenceNode < DelegateClass(XMLUtilityNode)
    attr_accessor :name, :processed

    def initialize(name, obj)
      super(obj)
      self.name = name
      self.processed = false
    end

    def to_html
      copy.to_html
    end
    alias :to_s :to_html

    def to_hash
      copy.to_hash
    end

    def copy
      if processed?
        return @childless_dup ||= __getobj__.dup.tap do |o|
          o.name = name
          o.children = []
        end
      else
        processed!
        return @dup ||= __getobj__.dup.tap do |o|
          o.name = name
        end
      end
    end

    def processed?
      self.processed
    end

    def processed!
      self.processed = true
    end
  end
end
