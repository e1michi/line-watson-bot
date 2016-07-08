class LineContentModel
  include LabelLogger
  include ActiveModel::Model
  attr_accessor :location, :id, :contentType, :from, :createdTime, :to, :toType, :contentMetadata, :text
  
  validates :id, presence: true
  
  def initialize(content)
    info('LineContentModel#initialize', "content=#{content.inspect}")
    @location = content[:location]
    @id = content[:id]
    @contentType = content[:contentType]
    @from = content[:from]
    @createdTime = content[:createdTime]
    @to = content[:to]
    @toType = content[:toType]
    @contentMetadata = content[:contentMetadata]
    @text = content[:text]
  end
end
