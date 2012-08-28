::Hash

class Hash
  def riddick_normalize_i18n(prefix)
    Hash[_riddick_normalize_i18n prefix, self]
  end

  def _riddick_normalize_i18n(prefix, hash, lines = [], path = '')
    hash.keys.each do |key|
      sub_path = path.dup
      value = hash[key]
      if value.kind_of? Hash
        if sub_path && !sub_path.empty?
          sub_path << ".#{key}"
        else
          sub_path = key.to_s
        end
        _riddick_normalize_i18n prefix, value, lines, sub_path
      else
        lines << [[prefix, sub_path, key].join('.').squeeze('.'), value.to_s]
      end
    end
    lines.sort_by &:first
  end
end
