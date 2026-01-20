# Decorator Pattern

## Pattern Explanation

The Decorator pattern is a structural design pattern that allows you to dynamically add new behaviors to objects by wrapping them in special wrapper objects. It provides a flexible alternative to subclassing for extending functionality.

Key concepts:
- **Component**: Common interface for both wrappers and wrapped objects
- **Concrete Component**: Basic object that can be wrapped
- **Decorator**: Base wrapper class that implements the component interface
- **Concrete Decorators**: Add specific behaviors before/after delegating to the wrapped object

## Challenge: Coffee Shop Order System

You're building an order system for a coffee shop where customers can customize their drinks with various add-ons. Each add-on modifies the price and description of the beverage.

### Requirements

1. Create a beverage system where base drinks can be decorated with add-ons
2. Base beverages:
   - Espresso ($2.50)
   - Latte ($3.50)
   - Cappuccino ($3.75)
   - Tea ($2.00)
3. Available add-ons (decorators):
   - Milk (+$0.50)
   - Soy Milk (+$0.75)
   - Whipped Cream (+$0.70)
   - Caramel Syrup (+$0.60)
   - Vanilla Syrup (+$0.60)
   - Extra Shot (+$1.00)
   - Ice (+$0.00)
4. Each decorator should:
   - Add its cost to the total
   - Append its name to the description
   - Be stackable (can add multiple decorators)

### Example Usage

```ruby
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
```

### Bonus Points

- Implement a size decorator (Small, Medium, Large) that multiplies the base price
- Add a discount decorator for loyalty program members
- Create a receipt formatter that pretty-prints the order
- Implement undo functionality to remove the last decorator
