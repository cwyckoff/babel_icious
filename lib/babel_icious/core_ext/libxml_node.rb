require 'xml/libxml'

module BabeliciousNodeHacks

  def to_a
    self.children.reject { }
    res = self.children.inject([]) do |a,b| 
      unless b.content.strip.empty?
        a << b.content.strip
      else 
        a
      end 
    end 
  end
  
  def concatenate_children(glue)
    to_a.join("glue")
  end
  
  def child_content(child)
    child_arr(child).first.content unless child_arr(child).empty?
  end

  def child_name(child)
    child_arr(child).first.name
  end
  
  def elements
    e = []
    self.each_element {|elem| e << elem}
    e
  end
  
  private
  
  def child_arr(child)
    child_arr = self.find(child)
    raise "Cannot retrieve content or name for child node #{child}.  Current node has more than one child." if child_arr.size > 1
    child_arr
  end

end

class XML::Node; include BabeliciousNodeHacks; end
