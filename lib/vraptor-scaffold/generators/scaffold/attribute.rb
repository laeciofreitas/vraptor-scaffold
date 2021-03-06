class Attribute
  attr_accessor :name, :type

  def initialize(name, type)
    @name = name.underscore.camelize(:lower)
    @type = type.downcase
    validate
  end

  def html_input
    input = "text"
    input = "checkbox" if boolean?
    input = "textarea" if type.eql?("text")
    input
  end

  def html_label
    @name.underscore.humanize
  end

  def java_type
    java = type.capitalize
    java = "boolean" if boolean?
    java = "String" if type.eql?("text")
    java = "BigDecimal" if type.eql?("big_decimal")
    java = "BigInteger" if type.eql?("big_integer")
    java = "LocalDate" if type.eql?("local_date")
    java = "LocalDateTime" if type.eql?("local_date_time")
    java = "LocalTime" if type.eql?("local_time")
    java = "Date" if type.eql?("date")
    java = name.camelize if type.eql?("references")    
    java
  end

  def import
    ImportManager.new(type).package
  end

  def annotation
    AnnotationManager.new(type).annotation
  end
  
  def self.valid_types
    %w(boolean double float short integer long string text big_decimal big_integer date local_date local_time local_date_time references)
  end

  def boolean?
    type.eql? "boolean"
  end
  
  def getter_prefix
    return "is" if boolean?
    "get"
  end

  def validate
    unless Attribute.valid_types.include?(@type)
      puts "Attribute #{@type} is not supported. The supported attributes types are: #{Attribute.valid_types.join(", ")}"
      Kernel::exit
    end
  end
end
