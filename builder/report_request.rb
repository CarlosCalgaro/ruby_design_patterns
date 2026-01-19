
class ReportRequest

  ALLOWED_GROUP_BY = %w[day week month].freeze
  ALLOWED_FORMATS  = %w[json csv].freeze
  
  attr_accessor :start_date, :end_date, :filters, :group_by, :columns, :format

  def initialize
    @filters = {}
    @columns = []
    @format = :csv
  end
end