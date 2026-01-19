🎯 Challenge: Builder (real backend scenario)

Scenario

You’re implementing a Report generator for a SaaS admin dashboard.

A report has many optional parts:
	•	date range
	•	filters (status, country, plan)
	•	grouping (by day / week / month)
	•	columns (fields to include)
	•	output format (JSON, CSV, PDF — for now just JSON/CSV strings)

You want to avoid doing this in one ugly initializer like:

```ruby
Report.new(start_date:, end_date:, status:, country:, plan:, group_by:, columns:, format:)
```

Instead, you’ll build it fluently and safely.

⸻

✅ Requirements

1) The “product”

Create a ReportRequest object that holds:
	•	start_date (required)
	•	end_date (required)
	•	filters (hash, default {})
	•	group_by (nil or "day"|"week"|"month")
	•	columns (array, default [])
	•	format ("json" default, or "csv")

2) The Builder

Create ReportRequestBuilder with a fluent API:
	•	for_range(start_date, end_date) (required, must be called before build)
	•	filter(key, value) (can be called multiple times)
	•	group_by(value) (day/week/month)
	•	select(*columns) (add columns)
	•	as_json / as_csv (sets format)
	•	build returns a ReportRequest

3) Validations enforced by the builder

The builder must prevent invalid reports:
	•	cannot build without for_range
	•	end_date must be >= start_date
	•	group_by must be one of allowed values
	•	format must be "json" or "csv"

Raise ArgumentError with clear messages.

4) Demo usage (must work)

```ruby
report =
  ReportRequestBuilder.new
    .for_range(Date.new(2026,1,1), Date.new(2026,1,31))
    .filter("status", "paid")
    .filter("country", "BR")
    .group_by("week")
    .select("id", "amount", "created_at")
    .as_csv
    .build
```

Expected:
	•	report.format == "csv"
	•	report.filters == {"status"=>"paid","country"=>"BR"}
	•	report.columns == ["id","amount","created_at"]

⸻

⭐ Extra twist (optional but valuable)

Add reset! to the builder so it can be reused for multiple reports safely.