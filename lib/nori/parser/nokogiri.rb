require "nokogiri"

module Nori
  module Parser

    # = Nori::Parser::Nokogiri
    #
    # Nokogiri SAX parser.
    module Nokogiri

      class Document < ::Nokogiri::XML::SAX::Document

        def stack
          @stack ||= []
        end

        def references
          @references ||= {}
        end

        def start_element(name, attrs = [])
          attributes = Hash[*attrs.flatten]

          if href = (attributes["href"][1..-1] rescue nil)
            raise "Reference Error: #{href} is not a valid references" unless ref = references[href]
            node = Nori::XMLReferenceNode.new(name, ref, stack.include?(ref))
          else
            node = Nori::XMLUtilityNode.new(name, attributes)
            if id = attributes["id"]
              references[id] = node
            end
          end
          puts "pushing node #{node}"
          stack.push node
        end

        def end_element(name)
          if stack.size > 1
            last = stack.pop
            stack.last.add_node last
          end
        end

        def characters(string)
          stack.last.add_node(string) unless string.strip.length == 0 || stack.empty?
        end

        alias cdata_block characters

      end

      def self.parse(xml)
        document = Document.new
        parser = ::Nokogiri::XML::SAX::Parser.new document
        parser.parse xml
        document.stack.length > 0 ? document.stack.pop.to_hash : {}
      end

    end
  end
end
