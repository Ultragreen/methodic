# Methodic

## Content

* Author : Romain GEORGES <romain@ultragreen.net> 
* Version : 1.2
* WWW : http://www.ultragreen.net/projects/methodic


[![Build Status](https://travis-ci.org/lecid/methodic.png?branch=master)](https://travis-ci.org/lecid/methodic) [![CodeClimate](https://codeclimate.com/github/lecid/methodic.png)](https://codeclimate.com/github/lecid/methodic)


## Description 

Methodic is a macro-like utility to help test, validate, control options passed by an Hash param to a method, it could help you to merge with defaults values, 
It raise explained exceptions and return false if the validations steps failed.

## Installation

In a valid Ruby environment :

```
   $ sudo zsh
   # gem ins methodic
```
## Implementation 

* [Methodic]
* [Methodic::Options]

## Examples

### Without known options control

```ruby
  require 'rubygems'                                                                                                                                                                             
  require 'methodic'
  [...]                                                                                                                                                                                          
  # in a method                                                                                                                                                                                  
  def amethod ( _options = {})                                                                                                                                                                   
    myOptions = Methodic::get_options(_options) do |m|                                                                                                                                           
      m.specify_default_value_of :country => 'France'                                                                                                                                            
      m.specify_classes_of :name => String, :surname => String, :age => Fixnum, :country => String                                                                                               
      aCond = Proc::new {|option| case options when 'Doe' then true else false end }                                                                                                                
      m.specify_condition_for :name => aCond
      m.specify_presence_of :name                                                                                                                                                                
      m.specify_presence_of :surname                                                                                                                                                             
      m.specify_formats_of :name => /\w+/, :surname => /\w+/, :country => /\w+/                                                                                                                  
      m.merge!                                                                                                                                                                                   
    end                                                                                                                                                                                          
    # processing method                                                                                                                                                                          
  end                                                                                                                                                                                    
  [...]  
```

### With known options control

```ruby
  require 'rubygems'                                                                                                                                                                             
  require 'methodic'
  [...]                                                                                                                                                                                          
  # in a method                                                                                                                                                                                  
  def amethod ( _options = {})                                                                                                                                                                   
    myOptions = Methodic::get_options(_options,true) do |m|
      # all others definitions MUST be included in known options list (explained in Spec), so :                                                                                                             m.specify_known_options [:country,:name,:surname, :age]          
      m.specify_default_value_of :country => 'France'
      aCond = Proc::new {|option| case options when 'Doe' then true else false end }                                                                                                                
      m.specify_condition_for :name => aCond                                                                                                                                            
      m.specify_classes_of :name => String, :surname => String, :age => Fixnum, :country => String                                                                                               
      m.specify_presence_of :name                                                                                                                                                                
      m.specify_presence_of :surname                                                                                                                                                             
      m.specify_formats_of :name => /\w+/, :surname => /\w+/, :country => /\w+/                                                                                                                  
      m.merge!                                                                                                                                                                                   
    end                                                                                                                                                                                          
    # processing method                                                                                                                                                                          
  end                                                                                                                                                                                    
  [...]  
```

### Remarque about conditions 


* Condition MUST :

- be ruby code
- be a Proc Object
- have an argument |option| who provide the option symbol, like :an_option
- return true or false

* Make your condition like

```ruby
   aCond = Proc::new do |option| 
           case options
             when .... then ...
             when .... then ...
             else ...
           end
   end
```


## Copyright

<pre>Methodic (c) 2012-2013 Romain GEORGES <romain@ultragreen.net> for Ultragreen Software </pre>

