module InputReader

  def self.read(sample = false)
    # depends on file structure looking like this
    # inputs
    #   day_1.txt
    #   day_2.txt
    # day_1.rb
    # day_2.rb     
    path = "inputs/#{File.basename($0).gsub('.rb', '.txt')}"
    File.read(path)
  end
end
