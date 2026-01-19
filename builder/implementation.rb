require_relative 'report_request'
require 'date'
require 'pry'
class ReportRequestBuilder
  def initialize
    @report_request = ReportRequest.new
  end

  def for_range(start_date, end_date)
    @report_request.start_date = start_date
    @report_request.end_date = end_date
    self
  end

  def filter(key, value)
    @report_request.filters[key] = value
    self
  end

  def group_by(period)
    @report_request.group_by = period
    self
  end

  def select(*columns)
    @report_request.columns.concat(columns)
    self
  end

  def as_csv
    @report_request.format = :csv
    self
  end

  def build
    validate!
    @report_request
  end

  private


  def validate!
    raise ArgumentError, "Start date and end date must be provided" if @report_request.start_date.nil? || @report_request.end_date.nil?
    
    unless @report_request.start_date.is_a?(Date) && @report_request.end_date.is_a?(Date)
      raise ArgumentError, "Start date and end date must be Date objects"
    end

    if @report_request.start_date > @report_request.end_date
      raise ArgumentError, "Start date cannot be after end date"
    end

    if !@report_request.group_by.nil? && !ReportRequest::ALLOWED_GROUP_BY.include?(@report_request.group_by)
      raise ArgumentError, "Invalid group_by value. Allowed values are: #{ReportRequest::ALLOWED_GROUP_BY.join(', ')}"
    end

    unless ReportRequest::ALLOWED_FORMATS.include?(@report_request.format.to_s)
      raise ArgumentError, "Invalid format value. Allowed values are: #{ReportRequest::ALLOWED_FORMATS.join(', ')}"
    end
    
  end

end

report =
  ReportRequestBuilder.new
    .for_range(Date.new(2026,1,1), Date.new(2026,1,31))
    .filter("status", "paid")
    .filter("country", "BR")
    .group_by("week")
    .select("id", "amount", "created_at")
    .as_csv
    .build

puts report.inspect