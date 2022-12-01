# ------ Base class with metaprogramming ------

# This might make more sense if you skip ahead to the 🦄🦄🦄🌈🌈🌈 first
# and study the desired results, then come back here.

class Animal
    def initialize(name)
      @name = name
    end
  
    attr_reader :name
  
    # `noise` is a metaprogramming method. Subclasses definitions can call it to
    # generate many methods at once, according to a preset pattern.
    #
    # Comments in the right column show the effective metaprogramming results
    # if a subclass said “noise :bark”.
    #
    def self.noise(noise_name)
      attr_name = "#{noise_name}_mode"
  
      attr_reader attr_name                            # attr_reader :bark_mode   # ← getter method
                                                       #
      define_method("#{noise_name}ing?") do            # def barking?
        !send(attr_name).nil?                          #   !bark_mode.nil?   # We're barking if bark_mode is not nil
      end                                              # end
                                                       #
      define_method("stop_#{noise_name}ing") do        # def stop_barking
        puts "#{@name} has stopped #{noise_name}ing."  #   puts "#{@name} has stopped barking."
        instance_variable_set("@" + attr_name, nil)    #   @bark_mode = nil
      end                                              # end
  
      # Calling `noise :bark` generates a new `bark_type` method that will
      # generate yet more methods.
      #
      # We are metaprogramming metaprogramming! 
      #
      # Comments in the right column show the effective metaprogramming results
      # if a subclass said “bark_type :loudly.
      #
      self.class.define_method("#{noise_name}_type") do |adverb|
        define_method("#{noise_name}_#{adverb}!") do      # def bark_loudly!
          puts "#{@name} is #{noise_name}ing #{adverb}."  #   puts "#{@name} is barking loudly."
          instance_variable_set("@" + attr_name, adverb)  #   @bark_mode = :loudly
        end                                               # end
                                                          #
        define_method("#{noise_name}ing_#{adverb}?") do   # def barking_loudly?
          send(attr_name) == adverb                       #   @bark_mode == :loudly
        end                                               # end
      end
    end
  end
  
  # ------ Using Animal's metaprogramming to create new classes ------
  
  # 🦄🦄🦄🌈🌈🌈 (This is where Ruby shines) 🌈🌈🌈🦄🦄🦄
  
  class Duck < Animal
    noise :quack
  
    quack_type :softly
    quack_type :angrily
    quack_type :inscrutibly
    quack_type :ineluctibly
  end
  
  class Cat < Animal
    noise :meow
    meow_type :hungrily
    meow_type :pathetically
  
    noise :hiss
    hiss_type :disturbingly
    hiss_type :pathologically
  end
  
  # ------ Using the new classes ------
  
  donald = Duck.new("Donald Duck")
  donald.quack_softly!       # Q: Where are these methods declared?
  donald.quack_inscrutibly!  # A: They aren’t declared! They’re metaprogrammed!
  donald.stop_quacking
  
  felix = Cat.new("Felix the Cat")
  felix.meow_hungrily!       # Q: What does the ! mean?
  felix.hiss_pathologically! # A: It’s just part of the method name.
  felix.meow_pathetically!
  
  puts "------------------------------------------"
  
  puts "Felix meow mode: #{felix.meow_mode}"  # Q: How does the Cat class store this state?
  puts "Felix hiss mode: #{felix.hiss_mode}"  # A: The metaprogramming creates an instance variable.
  
  puts "Is Donald Duck quacking softly?"
  p donald.quacking_softly?
  
  puts "Is Felix hissing pathologically?"
  p felix.hissing_pathologically?
  
  puts "------------------------------------------"
  
  puts "Full state of both objects:"
  p donald
  p felix
  
  puts "------------------------------------------"
  
  # Prints all instance methods that a class has that another comparison class doesn’t have.
  # The comparison class is the first class’s superclass by default.
  #
  # (Just try writing this in Java!)
  #
  def print_methods_added(target_class, comparison_class = target_class.superclass)
    puts "Instance methods added to #{target_class} (vs #{comparison_class}):"
    (target_class.instance_methods - comparison_class.instance_methods).sort.each do |method_name|
      puts "    #{method_name}"
    end
    puts
  end
  
  print_methods_added(Animal)
  print_methods_added(Duck)
  print_methods_added(Cat)