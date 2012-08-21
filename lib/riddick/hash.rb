::Hash

class Hash
  def riddick_normalize
    _riddick_normalize self
  end

  def _riddick_normalize(hash, lines = [], path = '')
    hash.keys.each do |key|
      sub_path = path.dup
      value = hash[key]
      if value.kind_of? Hash
        if sub_path.present?
          sub_path << ".#{key}"
        else
          sub_path = key.to_s
        end
        _riddick_normalize value, lines, sub_path
      else
        lines << [[I18n.locale, sub_path, key].join('.').squeeze('.'), value.to_s]
      end
    end
    lines.sort_by(&:first)
  end
end
