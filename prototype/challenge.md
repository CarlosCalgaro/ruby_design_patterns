Prototype — brief explanation

Prototype creates new objects by cloning an existing object (the “prototype”) instead of instantiating a class directly with new.
It’s useful when:
	•	object creation is expensive/complex (lots of defaults, nested objects)
	•	you need many similar objects with small variations
	•	you want to avoid huge constructors and repeated setup

Key point: often you want a deep copy, not a shallow one.

⸻

🎯 Challenge: Prototype (realistic backend scenario)

Scenario

You’re building a system that generates product listings for an e-commerce catalog.

A Listing object is “expensive” to construct because it contains nested objects and defaults:
	•	pricing (base price, taxes, discounts)
	•	shipping (dimensions, weight, carrier options)
	•	metadata (tags, SEO, attributes)

You have a template listing per category (e.g., “T-shirt”, “Shoes”) and for each new product you want to create a new listing by cloning the template and applying small changes.

⸻

Requirements

1) The product model

Create a Listing with nested structures, like:
	•	title (string)
	•	pricing (hash)
	•	shipping (hash)
	•	metadata (hash)

Example template:

```ruby
T_SHIRT_TEMPLATE = Listing.new(
  title: "Template: T-shirt",
  pricing:  { "price_cents" => 7900, "currency" => "BRL", "tax_rate" => 0.12, "discount_cents" => 0 },
  shipping: { "weight_grams" => 250, "dimensions_cm" => [30, 20, 2], "carriers" => ["correios", "jadlog"] },
  metadata: { "tags" => ["clothing", "tshirt"], "seo" => { "title" => "Basic Tee", "description" => "Cotton tee" } }
)
```

2) Implement Prototype cloning

Implement:
	•	Listing#clone_for(overrides: {})
Returns a new Listing cloned from the current one, then applies overrides.

Overrides must support nested dot paths, like:
	•	"pricing.price_cents" => 9900
	•	"metadata.seo.title" => "Premium Tee"

3) Deep copy requirement (important!)

Cloning must be a deep copy:
	•	If you modify the clone’s nested hashes/arrays, the template must not change.

Example test you must pass:

```ruby
clone = T_SHIRT_TEMPLATE.clone_for(overrides: { "metadata.tags" => ["clothing", "premium"] })
clone.metadata["seo"]["title"] = "Changed"

# Must stay unchanged:
T_SHIRT_TEMPLATE.metadata["seo"]["title"] == "Basic Tee"
```