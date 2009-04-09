class PathTranslator
  attr_reader :parsed_path, :full_path
  include Enumerable
  
  def initialize(untranslated_path)
    @full_path = untranslated_path
    @parsed_path = translate(untranslated_path)
  end

  def each(&block)
    @parsed_path.each(&block)
  end
  
  def translate(untranslated_path)
    untranslated_path.gsub(/^\//, "").split("/")
  end
end
