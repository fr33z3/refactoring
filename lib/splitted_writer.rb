class SplittedWriter
  def initialize(file_manager, file_name, max_lines = 120000)
    @file_manager = file_manager
    @file_name = file_name
    @max_lines = max_lines
    @headers_writen = false
    @lines_writen = 0
    @file_index = -1
  end

  def write(row)
    @row = row
    if !file || @lines_writen >= max_lines
      close
      open_new_file!
    end
    write_headers! unless headers_writen
    write_values!
  end

  def close
    if file
      file.close
      @file = nil
    end
  end

  private

  attr_reader :file_name, :file_index, :headers_writen, :max_lines, :file, :file_manager

  def write_headers!
    file << @row.keys
    @headers_writen = true
    @lines_writen += 1
  end

  def write_values!
    file << @row.values
    @lines_writen += 1
  end

  def open_new_file!
    @headers_writen = false
    @lines_writen = 0
    @file_index += 1
    @file = file_manager.open_write(splitted_name)
  end

  def splitted_name
    parts = file_name.split('.')
    base = parts[0..-2].join('.')
    ext = parts.last

    "#{base}_#{file_index}.#{ext}"
  end
end
