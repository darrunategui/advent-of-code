require '../input_reader'
input = InputReader.read

class Directory
  attr_reader :name, :parent, :contents
  def initialize(name, parent)
    @name = name
    @parent = parent
    @contents = {}
  end

  def files
    contents.values.filter { |c| c.is_a? File }
  end

  def directories
    contents.values.filter { |c| c.is_a? Directory }
  end

  def navigate(cd_command)
    if cd_command.command == '$ cd ..'
      parent
    elsif cd_command.command == '$ cd /'
      return self if parent.nil?
      dir = parent
      while !dir.parent.nil?
        dir = dir.parent
      end
      dir
    else
      target_dir = cd_command.command.split(' ').last
      contents[target_dir]
    end
  end

  def populate(ls_command)
    ls_command.output.each do |line|
      # the name of the file or dir is the last word
      name = line.split(' ').last

      if /^\d/.match?(line) # starts with digit. It's a file
        size = line.split(' ').first.to_i
        contents[name] = File.new(name, size)
      elsif line.start_with?('dir') # starts with 'dir. It's a directory
        contents[name] = Directory.new(name, self)
      end
    end
  end

  def size
    deep_files(self).sum { |f| f.size }
  end

  def to_s
    "#{name} #{contents.keys} #{size}"
  end

  private

  def deep_files(dir)
    [*dir.files, *dir.directories.map { |d| deep_files(d) }.flatten]
  end
end

class File
  attr_reader :name, :size
  def initialize(name, size)
    @name = name
    @size = size
  end

  def to_s
    "#{size} #{name}"
  end
end

class Command
  attr_reader :command, :output
  def initialize(input)
    lines = input.split("\n")
    @command = lines.first
    @output = lines.drop(1)
  end

  def cd?
    command.start_with?('$ cd')
  end
  
  def ls?
    command == '$ ls'
  end
end

root = Directory.new('/', nil)
current_dir = root

# this is a dirty solution to breaking the input into commands and their output
commands = input.split("\n$")
commands.each_with_index { |s, i| commands[i] = "$#{s}" if !s.start_with?('$') }

commands.each do |c|
  command = Command.new(c)

  if command.cd?
    current_dir = current_dir.navigate(command)
  elsif command.ls?
    current_dir.populate(command)
  end
end

def find_directories(directory)
  [directory, *directory.directories.map { |c| find_directories(c) }.flatten ]
end

directories = find_directories(root)

# part 1
max_size = 100000
puts directories.filter { |d| d.size <= max_size }.sum { |d| d.size } 


# part 2
file_system_size = 70000000
needed_space = 30000000
puts directories.
  sort_by(&:size).
  find { |d| file_system_size - root.size + d.size >= needed_space }.size
