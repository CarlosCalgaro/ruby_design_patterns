🎯 Challenge: Factory Method (real backend scenario)

Scenario

You are building a notification system for a backend application.

The system must send notifications through different channels:
	•	Email
	•	SMS
	•	Push notification

Each notification type:
	•	Has its own implementation
	•	Must expose the same interface: send(message:)

Business rules
	•	The app receives a channel string: "email" | "sms" | "push"
	•	Based on that, the correct notifier must be created
	•	The caller must not know which concrete class is instantiated
	•	Adding a new channel later (e.g. "whatsapp") must not require changing existing logic

⸻

Your task

1️⃣ Define the product interface


2️⃣ Create concrete products

At least:
	•	EmailNotifier
	•	SmsNotifier
	•	PushNotifier

Each should implement send(message:) with a simple puts / print.

3️⃣ Implement the Factory Method

Create a factory class or base creator that:
	•	Exposes a method like create_notifier(channel)
	•	Returns the correct notifier instance
	•	Raises a clear error for unsupported channels


⚠️ Important constraint
You are not allowed to use if/else or case chains inside the caller.


Code:
```
service = NotificationService.new(channel: "email")
service.notify("Welcome!")
```

Output:

```
Sending EMAIL: Welcome!
```

🚫 Common mistakes (avoid these)
	•	❌ Using a big case statement in the service
	•	❌ Returning symbols or lambdas instead of objects
	•	❌ Mixing Factory Method with Strategy in the same step
	•	❌ Making the factory itself a Singleton (not needed here)