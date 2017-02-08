class LineContentModel
  include LabelLogger
  include ActiveModel::Model
  attr_accessor :type, :id, :text
  
  validates :id, presence: true
  
  def initialize(content)
    debug('LineContentModel#initialize', "content=#{content.inspect}")
    @type = content[:type]
    @id = content[:id]
    @text = content[:text]
  end
end
