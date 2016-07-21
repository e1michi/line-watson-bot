module LabelLogger
  def info(tag, value)
    Rails.logger.info(label('INFO', tag) + value)
  end
  
  def debug(tag, value)
    Rails.logger.debug(label('DEBUG', tag) + value)
  end
  
  def error(tag, value)
    Rails.logger.error(label('ERROR', tag) + value)
  end
  
  private
  def label(type, tag)
    return "  [#{type}] " if tag.nil?
    return "  [#{type}/#{tag}] "
  end
end
