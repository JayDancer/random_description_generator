require 'yaml'
require 'pry'

#Allows specifying multiple files or a single file.
#Limitation: all options must have the same number, i.e. 10 options per file.

class RandomDescriptionGenerator

    @number_of_files #How many files do you need read to compile the data?
    @complete_description #Stringing together all the info.
    @file_path_names #array of path names needed.
    @collection_of_files #Used to store all loaded yaml.
    @max_options_per_file #If your file has categories like Bike, Car, Motorcycle then breaks it down further, how many main categories?
    @max_choices_per_option #If your file lists types of car, how many types of car are listed?

  def accept_scope(how_many_files, how_many_options, how_many_choices_per_option)
    @number_of_files = how_many_files
    @max_options_per_file = how_many_options
    @max_choices_per_option = how_many_choices_per_option
  end

  def load_file(path_name_of_file)
    puts path_name_of_file + " is the file we're looking for in load_file"
    temp_file = YAML.load_file(Dir.pwd + path_name_of_file)
    puts "The data we loaded is: " + temp_file.to_s
    (@collection_of_files ||= []).push(temp_file)
  end

  def call_files_to_load(array_of_file_pathnames)
    @file_path_names = array_of_file_pathnames
    track_file_load = 0
    if @number_of_files > 1
        loop do
          puts "The file path we'll try to load is " + @file_path_names[track_file_load]
            load_file(@file_path_names[track_file_load])
            track_file_load += 1
            if track_file_load >= @number_of_files
                break
            end
        end
    elsif @number_of_files == 0
        puts "No files provided."
    elsif @number_of_files == 1
        load_file(array_of_file_pathnames[track_file_load])
    end
  end

  def generate_description_from_multiple_files
    count_files = 0
    loop do
        temp_random_number = rand(@max_choices_per_option)
        puts "The number we got was " + temp_random_number.to_s
        (@complete_description ||= []).push(@collection_of_files[count_files][temp_random_number])
        count_files += 1
        if count_files >= @number_of_files
          return @complete_description
        end
    end
  end

  def generate_description_from_single_file
    count_options = 0
    loop do
        temp_random_number = rand(@max_choices_per_option)
        puts "The number we got was "  + temp_random_number
        complete_description[count_options].push(@collection_of_files[0][temp_random_number])
        count_options += 1
        if count_options >= @max_options_per_file
            return complete_description
        end
    end
  end
end
