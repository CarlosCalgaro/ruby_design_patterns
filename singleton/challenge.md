Challenge: Singleton (realistic backend scenario)

You’re building a backend app (Ruby/Python vibes) and you need a feature flag / config loader that:
	•	Reads configuration from an environment variable called APP_CONFIG_JSON (a JSON string).
	•	If the env var is missing, it falls back to a default config.
	•	The config must be parsed exactly once per process (JSON parsing is “expensive” here).
	•	Any part of the app can access config quickly: Config.instance.get("...") (or equivalent).
	•	It must be thread-safe (two threads calling at the same time must not create two instances).
	•	It must be testable: tests must be able to reset/replace the singleton state.

Default config (use this)

```json
{
  "log_level": "info",
  "payments_provider": "stripe",
  "max_retries": 3,
  "features": {
    "new_checkout": false,
    "dark_mode": false
  }
}
```

Your tasks

1) Implement the Singleton

Create a Config singleton with at least:
	•	Config.instance → returns the same object always
	•	get(path) → supports nested keys via dot-path
	•	set(path, value) → can override values in memory (useful for tests/runtime)
	•	reload!() → re-reads and re-parses from env (still singleton, but refreshes state)
	•	reset_for_tests!() (or similar) → clears singleton instance (testing hook)

Constraints:
	•	Must be lazy: don’t parse until first access.
	•	Must be thread-safe for initialization.
	•	Avoid global variables except what you need for the singleton itself.