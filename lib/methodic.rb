#!/usr/bin/env ruby
# -*- coding: undecided -*-
# Copyright Ultragreen (c) 2012-2Â013
#---
# Author : Romain GEORGES 
# type : gem component library 
# obj : Methodic Module
#---

# inherited List class from Array to patch push for uniqness carateristique 
class List < Array

  # override of push for uniqness and flatten return
  def push(*value) 
    super(value)
    self.flatten!
    self.uniq!
    return self
  end


  # override of << for uniqness and flatten return
  def <<(*value)
    super(value)
    self.flatten!
    self.uniq!
    return self
  end

end


# module Methodic 
# @author Romain GEORGES <romain@ultragreen.net>
# @see http://www.ultragreen.net/projects/methodic
# @version 0.2
# @note this module include a class, but please use the module method Methodic::get_options to Build a Methodic::Options instance
# @example Complete usage 
#    require 'rubygems'
#    require 'methodic'
#    [...]
#    # in a method
#    def amethod ( _options = {})
#      myOptions = Methodic::get_options(_options,true) do |m|
#        m.specify_known_options [:country,:name,:surname,:age]
#        m.specify_default_value :country => 'France'
#        aCond = Proc::new {|option| case options when 'Doe' then true else false end } 
#        m.specify_condition_for :name => aCond
#        m.specify_classes_of :name => String, :surname => String, :age => Fixnum, :country => String
#        m.specify_presence_of :name
#        m.specify_presence_of :surname
#        m.specify_formats_of :name => /\w+/, :surname => /\w+/, :country => /\w+/
#        m.merge
#      end
#      # processing method
#    end
#    [...]
module Methodic

  # class Options
  # an Options utility class
  # @note please do not instantiate with Options::new use Methodic::get_options
  # @example Complete usage 
  #    require 'rubygems'
  #    require 'methodic'
  #    [...]
  #    # in a method
  #    def amethod ( _options = {})
  #      myOptions = Methodic::get_options(_options,true) do |m|
  #        m.specify_known_options [:country,:name,:surname,:age]
  #        m.specify_default_value :country => 'France'
  #        aCond = Proc::new {|option| case options when 'Doe' then true else false end } 
  #        m.specify_condition_for :name => aCond
  #        m.specify_classes_of :name => String, :surname => String, :age => Fixnum, :country => String
  #        m.specify_presence_of :name
  #        m.specify_presence_of :surname
  #        m.specify_formats_of :name => /\w+/, :surname => /\w+/, :country => /\w+/
  #        m.merge
  #      end
  #      # processing method
  #    end
  #    [...]
  class Options < Hash

    # @example writing
    #   myOptions = Methodic::get_options(options)
    #   myOptions.known = [:name]
    #   myOptions.known.push :surname
    # @example reading
    #   p myOptions.known 
    #   => [ :name, :surname ]
    # @attr [Hash] the list of all options assumed for a method 
   attr_accessor :known
    
    # @example writing
    #   myOptions = Methodic::get_options(options)
    #   myOptions.classes = {:name => String }
    #   myOptions.classes[:surname] = String
    # @example reading
    #   p myOptions.classes 
    #   => { :name => String, :surname => String }
    # @attr [Hash] classes a hash table of some options associated with their corresponding types or classes
   attr_accessor :classes

    # @attr [Array] mandatories the full list of mandatories options
    # @example writing
    #   myOptions = Methodic::get_options(options)
    #   myOptions.mandatories = [:name]
    #   myOptions.mandatories.push :surname
    # @example reading
    #   p myOptions.mandatories 
    #   => [ :name, :surname ]
    attr_accessor :mandatories

    # @attr [Hash] defaults a hash table of some options with defaults values
    # @example writing
    #   myOptions = Methodic::get_options(options)
    #   myOptions.defaults = {:name => 'John' }
    #   myOptions.defaults[:surname] = 'Doe'
    # @example reading
    #   p myOptions.defaults 
    #   => { :name => 'John', :surname => 'Doe' }
    attr_accessor :defaults

    # @attr [Hash] formats a hash table of some options with their corresponding
    # @example writing
    #   myOptions = Methodic::get_options(options)
    #   myOptions.formats = {:name => /\w+/ }
    #   myOptions.formats[:surname] = /\w+/
    # @example reading
    #   p myOptions.defaults 
    #   => { :name => /\w+/, :surname => /\w+/ }
    attr_accessor :formats
    
    # @attr [Hash] conditions a hash table of some conditions with their corresponding
    # @example writing
    #   myOptions = Methodic::get_options(options)
    #   myOptions.conditions = {:name => aProcObject }
    #   myOptions.conditions[:surname] = aProcObject
    # @example reading
    #   p myOptions.defaults 
    #   => { :name => /\w+/, :surname => /\w+/ }
    attr_accessor :conditions

    # initializer for [Options]
    # @note please do not use standalone, build from module method Methodic::get_options
    # @param [Hash] _options the options hash (define for the method you would prototype)
    # @note _options keys must be symbols
    # @example prototype for informational only
    #   Methodic::Options::new({:toto => 'titi', :tutu => 'tata'})
    # @return [Options] self
    def initialize(_options = {},_validate_known_options = false)

      raise ArgumentError::new('Argument _options must be a Hash') unless _options.class == Hash or _options.class == Methodic::Options # ;) reintrance and cascading
      raise ArgumentError::new('keys must be Symbol') unless _options.keys.select{|i| i.class == Symbol }.size ==  _options.keys.size 
      self.replace _options
      @conditions = Hash::new
      @defaults = Hash::new
      @formats = Hash::new
      @classes = Hash::new
      @known = List::new
      @mandatories = List::new
      @validate_known_options = _validate_known_options
      yield self if block_given?
    end
    

    # read only accessor on the [Hash] slef keys
    # @return [Array] self.keys the keys of The Options object itself
    # @example usage
    #   options = {:name => 'Doe', :surname => 'John'}
    #   p myOptions = Methodic::get_options(options)
    #   => { :name => String, :surname => String }
    #   p myOptions.options 
    #   => [:name, :surname]
    def options 
      return self.keys
    end

    
    # pretty accessor for specifying the default(s) value(s)  for options
    # @param [Hash] values a value definition, keys are symbols
    # @return [hash] @defaults merged with values
    # @example usage
    #    myOptions = Methodic::get_options(_options)
    #    myOptions.specify_default_value :name => 'Doe'
    #    myOptions.specify_defaults_values :name => 'Doe', :surname => 'John'
    def specify_default_value(values)
      @defaults.merge! values
      return @defaults
   end
    alias :specify_defaults_values :specify_default_value
    
    # pretty accessor for specifying classes of options
    # @param [Hash] values a value definition, keys are symbols
    # @return [hash] @classes merged with values
    # @note classes must be precised in Ruby not a string like Fixnum, Hash, Array, String
    # @example usage
    #    myOptions = Methodic::get_options(_options)
    #    myOptions.specify_class_of :name => String
    #    myOptions.specify_classes_of :name => String, :surname => String
    def specify_class_of(values)
      @classes.merge! values
      return @classes
    end
    alias :specify_classes_of :specify_class_of

    # pretty accessor for specifying conditions for options
    # @param [Hash] values a Conditions Proc definition, keys are symbols
    # @return [hash] @conditions merged with values
    # @note Conditions must be precised in Ruby as a Proc Object returning a boolean
    # @note Convention : Proc MUST return true or false ONLY ( false trigged the exception raising )
    # @example usage
    #    myOptions = Methodic::get_options(_options)
    #    myOptions.specify_condition_for :name => aProcObject
    #    myOptions.specify_conditions_for :name => aProcObject, :surname => aProcObject
    def specify_condition_for(values)
      @conditions.merge! values
      return @conditions
    end
    alias :specify_conditions_for :specify_condition_for


    
    # pretty accessor for specifying mandatories options
    # @param [Array] values a Array of symbols or a unique symbol
    # @return [Array] @mandatories merged with values
    # @example usage
    #    myOptions = Methodic::get_options(_options)
    #    myOptions.specify_presence_of :name 
    #    myOptions.specify_presences_of [ :name, :surname ]
    def specify_presence_of(*values) 
      @mandatories << values
      @mandatories.flatten!
      @mandatories.uniq!
      return @mandatories 
    end
    alias :specify_presences_of :specify_presence_of


    # pretty accessor for specifying known options
    # @param [Array] values a Array of symbols or a unique symbol
    # @return [Array] @known merged with values
    # @example usage
    #    myOptions = Methodic::get_options(_options)
    #    myOptions.specify_known_option :name 
    #    myOptions.specify_known_options [ :name, :surname ]
    def specify_known_option(*values) 
      @known << values
      @known.flatten!
      @known.uniq!
      return @known 
    end
    alias :specify_known_options :specify_known_option
    
    # pretty accessor for specifying the format of options
    # @param [Hash] values a value definition, keys are symbols
    # @return [hash] @formats merged with values
    # @note formats must be Regular Expression
    # @example usage
    #    myOptions = Methodic::get_options(_options)
    #    myOptions.specify_format_of :name => /\w+/
    #    myOptions.specify_formats_of :name => /\w+/, :surname => /\w+/
    def specify_format_of(values)
      @formats.merge! values
      return @formats
    end
    alias :specify_formats_of :specify_format_of
    
    
    # default values merge method 
    # merge @defaults with self 
    # @return [self|Options]
    # @example usage
    #    myOptions = Methodic::get_options(:name = 'Walker')
    #    myOptions.specify_default_value_of :surname => 'John'
    #    p myOptions                                                                                                                                                                                  
    #      # =>{:surname=>"John", :name=>"Doe"}
    #    myOptions.merge
    #    p myOptions
    #      # =>{:surname=>"John", :name=>"Walker"} 
    def merge_with_defaults
      self.replace( @defaults.merge self)
      return self
    end
    alias :merge :merge_with_defaults
    # Validation method for options, start the validation for classes, options, formats, presences
    # @return [true|false] if validations failed or succeed
    # @raise ArgumentError for each kind of validations, that could failed
    # @note order for validation and Exception raising : Options inclusion >> Classes matching >> Mandatories Options presences >> Formats matching
    def validate
      table = []
      raise ArgumentError::new("Option : known list of options empty.") and return false if @known.empty? and @validate_known_options
      table.push validate_known_options if @validate_known_options
      table.push validate_classes unless @classes.empty?
      table.push validate_presences unless @mandatories.empty?
      table.push validate_formats unless @formats.empty?
      table.push validate_conditions unless @conditions.empty?
      return true unless table.include?(false) 
    end
    alias :validate! :validate
    
    private
    # private method for the formats validation step
    def validate_formats
      self.each do |option,value|
        if @formats.key? option then
          raise ArgumentError::new("Option : #{option} don't match  /#{@formats[option]}/") and return false unless value =~ @formats[option] 
        end
      end
      
      return true
    end

    # private method for known options validation step
    def validate_known_options
      @mandatories.each do |mdt|
        raise ArgumentError::new("Mandatories options :#{mdt} is not a known options") and return false unless @known.include?(mdt)
      end
      @classes.each do |aclass,value|
        raise ArgumentError::new("Classes definition :#{aclass} => #{value} is not a known options") and return false unless @known.include?(aclass)
      end
      @formats.each do |format,value|
        raise ArgumentError::new("Formats definition :#{format} => #{value} is not a known options") and return false unless @known.include?(format)
      end
      @defaults.each do |default,value|
        raise ArgumentError::new("Defaults value definition :#{default} => #{value} is not a known options") and return false unless @known.include?(default)
      end
      return true
    end

    # private method for mandatories presence validation step
    def validate_presences
      @mandatories.each do |mdt|
        raise ArgumentError::new("Missing option : #{mdt}") and return false unless self.include?(mdt)
      end
      return true
    end

    # private method for conditions validation step
    def validate_conditions
      @conditions.each do |option,cond|
        raise ArgumentError::new("Option : #{option} condition failed") and return false unless cond.call(self[option]) == true
      end
      return true
    end


    # private method for classes validation step
    def validate_classes
      @classes.each do |option,value|

        raise ArgumentError::new("Option : #{option} type mismatch must be a #{value}") and return false unless self[option].class == value
      end
      return true
    end
  end

  # Module method factory to build [Options] instance
  # @return [Options] instance
  # @param [Hash] _options the options [Hash] from the method, you want to prototype
  # @example usage
  #  myOptions = Methodic::get_options({:foo => 'bar'})
  #  p myOptions.class
  #  => Options
  # @note _options key must be symbols
  def Methodic::get_options(_options = {},_validate_known_options=false)
    return Methodic::Options::new(_options,_validate_known_options)
  end
 

end
