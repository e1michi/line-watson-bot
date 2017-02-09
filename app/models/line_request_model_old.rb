class LineRequestModel
  include LabelLogger
  include ActiveModel::Model
  attr_accessor :type, :replyToken, :userId, :content
  
  validates :id, presence: true
  
  def initialize(data)
    debug('LineRequestModel#initialize', "data=#{data.inspect}")
    @type = data[:type]
    @replyToken = data[:replyToken]
    @userId = data[:source][:userId]
    @content = LineContentModel.new data[:message]
  end
end
