module Babelicious

  class PathTranslator
    attr_reader :parsed_path, :full_path
    include Enumerable
    
    def initialize(untranslated_path)
      set_path(untranslated_path)
    end
    
    def initialize_copy(other)
      @full_path = other.full_path.dup
      @parsed_path = other.parsed_path.dup
    end

    def [](index)
      @parsed_path[index]
    end

    def each(&block)
      @parsed_path.each(&block)
    end
    
    def last_index
      @parsed_path.size - 1
    end
    
    def last
      @parsed_path.last
    end

    def prepare_path(path)
      path.gsub(/^\//, "").gsub(/\/$/, "")
    end 
    
    def set_path(untranslated_path)
      @full_path = untranslated_path
      @parsed_path = translate(untranslated_path)
    end 

    def size
      @parsed_path.size
    end
    
    def translate(path)
      prepare_path(path).split("/")
    end

    def unshift(path)
      @parsed_path.unshift(translate(path)).flatten!
      @full_path = "#{prepare_path(path)}/" << @full_path
    end 

  end

end

