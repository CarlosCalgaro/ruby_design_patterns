class Component
  def description
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def cost
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class AddOn < Component
  attr_accessor :beverage

  def initialize(beverage)
    @beverage = beverage
  end
end

class WhippedCream < AddOn
  def description
    "#{@beverage.description}, Whipped Cream"
  end

  def cost
    @beverage.cost + 0.70
  end
end

class CaramelSyrup < AddOn
  def description
    "#{@beverage.description}, Caramel Syrup"
  end

  def cost
    @beverage.cost + 0.60
  end
end

class Espresso < Component
  def description
    "Espresso"
  end

  def cost
    2.50
  end
end


class Milk < AddOn
  def description
    "#{@beverage.description}, Milk"
  end

  def cost
    @beverage.cost + 0.50
  end
end
  
class Latte < Component
  def description
    "Latte"
  end

  def cost
    3.00
  end
end

class SoyMilk < AddOn
  def description
    "#{@beverage.description}, Soy Milk"
  end

  def cost
    @beverage.cost + 0.70
  end
end

class ExtraShot < AddOn
  def description
    "#{@beverage.description}, Extra Shot"
  end

  def cost
    @beverage.cost + 1.00
  end
end

# Simple order
order1 = Espresso.new
puts order1.description  # => "Espresso"
puts order1.cost         # => 2.50

# Decorated order
order2 = Espresso.new
order2 = Milk.new(order2)
order2 = WhippedCream.new(order2)
order2 = CaramelSyrup.new(order2)

puts order2.description  # => "Espresso, Milk, Whipped Cream, Caramel Syrup"
puts order2.cost         # => 4.30

# Complex order
order3 = Latte.new
order3 = SoyMilk.new(order3)
order3 = ExtraShot.new(order3)
order3 = ExtraShot.new(order3)  # Double shot!

puts order3.description  # => "Latte, Soy Milk, Extra Shot, Extra Shot"
puts order3.cost         # => 5.75