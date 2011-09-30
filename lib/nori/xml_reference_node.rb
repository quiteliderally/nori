require 'delegate'

module Nori
  class XMLReferenceNode < DelegateClass(XMLUtilityNode)
    attr_accessor :name

    def initialize(name, obj, recursive = false)
      if recursive
        obj = obj.dup
        obj.children = []
        obj.name = name
      end
      super(obj)
      self.name = name
    end

    def inner_html
      make_dup.inner_html 
    end
    
    def to_hash
      make_dup.to_hash
    end

    def make_dup
      __getobj__.dup.tap do |o|
        o.name = name
      end
    end

  end
end
