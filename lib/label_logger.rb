module LabelLogger
  def info(text)
    fname = caller(1,1).pop.sub(/^.+`(.+)'$/,'\1')
    Rails.logger.info(label('INFO', "#{self.class}##{fname}") + text)
  end
  
  def debug(text)
    fname = caller(1,1).pop.sub(/^.+`(.+)'$/,'\1')
    Rails.logger.debug(label('DEBUG', "#{self.class}##{fname}") + text)
  end
  
  def error(text)
    fname = caller(1,1).pop.sub(/^.+`(.+)'$/,'\1')
    Rails.logger.error(label('ERROR', "#{self.class}##{fname}") + text)
  end
  
  private
  def label(type, tag)
    # return "  [#{type}] " if tag.nil?
    return "  [#{type}/#{tag}] "
  end
end
