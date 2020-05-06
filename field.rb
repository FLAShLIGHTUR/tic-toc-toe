class Field
  attr_accessor :field
  def initialize
    puts "start"
    @field = Array.new(3) { Array.new(3) { ' * ' } }
    @field.each { |a| p a.join('') }


  end

end

field = Field.new
