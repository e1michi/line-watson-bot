class LineRequestModel
  include LabelLogger
  include ActiveModel::Model
  attr_accessor :from, :fromChannel, :to, :toChannel, :eventType, :id, :content
  
  validates :id, presence: true
  
  def initialize(data)
    debug('LineRequestModel#initialize', data.inspect)
    @from = data[:from]
    @fromChannel = data[:fromChannel]
    @to = data[:to]
    @toChannel = data[:toChannel]
    @eventType = data[:eventType]
    @id = data[:id]
    @content = LineContentModel.new data[:content]
  end
end
