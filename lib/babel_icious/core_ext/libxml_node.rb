require 'xml/libxml'

module BabeliciousNodeHacks

  def concatenate_children(glue)
    res = self.children.inject('') {|a,b| a << "#{b.content}#{glue}"}
    res.chop
  end
  
  def child_content(child)
    child_arr(child).first.content
  end

  def child_name(child)
    child_arr(child).first.name
  end
  
  private
  
  def child_arr(child)
    child_arr = self.find(child)
    raise "Cannot retrieve content or name for child node #{child}.  Current node has more than one child." if child_arr.size > 1
    child_arr
  end

end

class XML::Node; include BabeliciousNodeHacks; end
